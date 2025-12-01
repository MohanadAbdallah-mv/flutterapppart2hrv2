// features/vacations/screens/my_requests/new_vacation_request_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:dropdown_search/dropdown_search.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/models/worker_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../purchases/widgets/language_switcher_button.dart';

class NewVacationRequestScreen extends StatefulWidget {
  static const String routeName = '/new-vacation-request';
  const NewVacationRequestScreen({super.key});

  @override
  State<NewVacationRequestScreen> createState() => _NewVacationRequestScreenState();
}

class _NewVacationRequestScreenState extends State<NewVacationRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedVacationType;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // ---== متغيرات العمال ==---
  bool _isForWorker = false;
  WorkerModel? _selectedWorker;

  Map<int, String> _vacationTypes = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;

    _vacationTypes = {
      1: l10n.vacationTypeRegular,
      2: l10n.vacationTypeUnpaid,
      12: l10n.vacationTypeAnnual,

    };

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    // التأكد من جلب العمال عند فتح الشاشة
    if (hrProvider.workersList.isEmpty && authProvider.currentUser != null) {
      hrProvider.fetchWorkersList(authProvider.currentUser!.usersCode);
    }
  }

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
            _durationController.text = '';
          }
        } else {
          _endDate = picked;
        }
        _calculateDuration();
      });
    }
  }

  void _calculateDuration() {
    if (_startDate != null && _endDate != null) {
      final duration = _endDate!.difference(_startDate!).inDays + 1;
      _durationController.text = duration > 0 ? duration.toString() : '';
    }
  }

  Future<void> _saveForm() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    if (_isForWorker && _selectedWorker == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectWorkerError ?? "Please select a worker"), backgroundColor: Colors.red),
      );
      return;
    }

    _formKey.currentState!.save();

    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final int targetEmpCode = _isForWorker ? _selectedWorker!.empCode : authProvider.currentUser!.empCode;
    final int targetCompEmpCode = _isForWorker ? _selectedWorker!.compEmpCode : authProvider.currentUser!.compEmpCode;
    final int insertingUserCode = authProvider.currentUser!.usersCode;

    final success = await hrProvider.createNewVacationRequest(
      empCode: targetEmpCode,
      compEmpCode: targetCompEmpCode,
      userCode: insertingUserCode,
      vacationType: _selectedVacationType!,
      startDate: _startDate!,
      endDate: _endDate!,
      period: int.tryParse(_durationController.text) ?? 0,
      notes: _notesController.text,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.requestSentSuccessfully), backgroundColor: Colors.green));
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(hrProvider.error ?? l10n.unexpectedError), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hrProvider = Provider.of<HrProvider>(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newRequest),
        actions: const [LanguageSwitcherButton()],
      ),
      body: hrProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // كارت اختيار نوع الطلب
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: Text(l10n.requestForMyself ?? "For Me"),
                              value: false,
                              groupValue: _isForWorker,
                              onChanged: (val) {
                                setState(() {
                                  _isForWorker = val!;
                                  _selectedWorker = null;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: Text(l10n.requestForWorker ?? "For Worker"),
                              value: true,
                              groupValue: _isForWorker,
                              onChanged: (val) {
                                setState(() {
                                  _isForWorker = val!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      if (_isForWorker) ...[
                        const Divider(),

                        // ---== 1. بحث باسم العامل ==---
                        DropdownSearch<WorkerModel>(
                          items: (filter, loadProps) => hrProvider.workersList,
                          itemAsString: (WorkerModel u) => isArabic ? u.empName : (u.empNameE ?? u.empName),
                          // +++ التعديل الهام هنا +++
                          // دالة المقارنة المطلوبة لإصلاح الخطأ
                          compareFn: (item1, item2) => item1.empCode == item2.empCode,
                          // +++++++++++++++++++++++++
                          selectedItem: _selectedWorker,
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              labelText: l10n.workerName ?? "Worker Name",
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.person_search),
                            ),
                          ),
                          popupProps: const PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                hintText: "بحث...",
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          onChanged: (WorkerModel? data) {
                            setState(() {
                              _selectedWorker = data;
                            });
                          },
                        ),

                        const SizedBox(height: 10),

                        // ---== 2. بحث برقم العامل ==---
                        DropdownSearch<WorkerModel>(
                          items: (filter, loadProps) => hrProvider.workersList,
                          itemAsString: (WorkerModel u) => u.compEmpCode.toString(),
                          // +++ التعديل الهام هنا أيضاً +++
                          compareFn: (item1, item2) => item1.empCode == item2.empCode,
                          // +++++++++++++++++++++++++
                          selectedItem: _selectedWorker,
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              labelText: l10n.workerNumber ?? "Worker Number",
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.badge),
                            ),
                          ),
                          popupProps: const PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                hintText: "بحث بالرقم...",
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          onChanged: (WorkerModel? data) {
                            setState(() {
                              _selectedWorker = data;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              ),

              _buildDropdownField(l10n),
              const SizedBox(height: 16),

                  _buildDatePicker(
                      l10n.startDateLabel, _startDate, () => _selectDate(context, true)),
                  const SizedBox(height: 16),
                  _buildDatePicker(
                      l10n.endDateLabel, _endDate, () => _selectDate(context, false)),

              const SizedBox(height: 16),
              _buildTextField(_durationController, l10n.durationLabel, Icons.timer, isNumber: true, isEnabled: false),
              const SizedBox(height: 16),
              _buildTextField(_notesController, l10n.notesLabel, Icons.notes, maxLines: 3),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: hrProvider.isLoading ? null : _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: hrProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(l10n.sendRequest, style: const TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(AppLocalizations l10n) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: l10n.vacationTypeLabel,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.category),
      ),
      value: _selectedVacationType,
      items: _vacationTypes.entries.map((entry) {
        return DropdownMenuItem<int>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedVacationType = value),
      validator: (value) => value == null ? l10n.selectVacationTypeValidation : null,
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, VoidCallback onPressed) {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    final l10n = AppLocalizations.of(context)!;
    final text = date == null ? l10n.selectDate : DateFormat.yMd(locale).format(date);
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.calendar_today),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      onTap: onPressed,
      controller: TextEditingController(text: text),
      validator: (value) => date == null ? l10n.selectDateValidation : null,
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {bool isNumber = false, int maxLines = 1, bool isEnabled = true}) {
    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
    );
  }
}