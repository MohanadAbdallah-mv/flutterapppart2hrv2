// lib/features/cancel_salary_confirmation/screens/my_requests/new_cancel_salary_confirmation_request_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart'; // إضافة

import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/models/worker_model.dart'; // إضافة

class NewCancelSalaryConfirmationRequestScreen extends StatefulWidget {
  static const String routeName = '/new-cancel-salary-confirmation-request';
  const NewCancelSalaryConfirmationRequestScreen({super.key});

  @override
  State<NewCancelSalaryConfirmationRequestScreen> createState() => _NewCancelSalaryConfirmationRequestScreenState();
}

class _NewCancelSalaryConfirmationRequestScreenState extends State<NewCancelSalaryConfirmationRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _trnsDate;
  final TextEditingController _notesController = TextEditingController();


  // ---== متغيرات العمال ==---
  bool _isForWorker = false;
  WorkerModel? _selectedWorker;

  @override
  void initState() {
    super.initState();
    _trnsDate = DateTime.now();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // جلب العمال
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    if (hrProvider.workersList.isEmpty && authProvider.currentUser != null) {
      hrProvider.fetchWorkersList(authProvider.currentUser!.usersCode);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();

    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _trnsDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _trnsDate) {
      setState(() {
        _trnsDate = picked;
      });
    }
  }

  void _submitForm() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // التحقق من العامل
    if (_isForWorker && _selectedWorker == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectWorkerError ?? "Please select a worker"), backgroundColor: Colors.red),
      );
      return;
    }

    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user == null) return;



    // ---== تحديد البيانات ==---
    final int targetEmpCode = _isForWorker ? _selectedWorker!.empCode : user.empCode;
    final int targetCompEmpCode = _isForWorker ? _selectedWorker!.compEmpCode : user.compEmpCode;
    final int insertingUserCode = user.usersCode;

    final bool success = await hrProvider.createCancelSalaryConfirmationRequest(
      empCode: targetEmpCode,
      compEmpCode: targetCompEmpCode,
      userCode: insertingUserCode,
      insertUser: insertingUserCode,
      trnsDate: _trnsDate!,
      notes: _notesController.text,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.cancelSalaryConfirmationRequestSentSuccessfully), backgroundColor: Colors.green));
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hrProvider.error ?? l10n.actionFailed), backgroundColor: Colors.red));
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
        title: Text(l10n.newCancelSalaryConfirmationRequest),
        actions: const [LanguageSwitcherButton()],
      ),
      body: hrProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---== كارت العمال ==---
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
                              onChanged: (val) => setState(() { _isForWorker = val!; _selectedWorker = null; }),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: Text(l10n.requestForWorker ?? "For Worker"),
                              value: true,
                              groupValue: _isForWorker,
                              onChanged: (val) => setState(() => _isForWorker = val!),
                            ),
                          ),
                        ],
                      ),
                      if (_isForWorker) ...[
                        const Divider(),
                        DropdownSearch<WorkerModel>(
                          items: (filter, loadProps) => hrProvider.workersList,
                          itemAsString: (u) => isArabic ? u.empName : (u.empNameE ?? u.empName),
                          compareFn: (i1, i2) => i1.empCode == i2.empCode,
                          selectedItem: _selectedWorker,
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(labelText: l10n.workerName ?? "Worker Name", border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.person_search)),
                          ),
                          popupProps: const PopupProps.menu(showSearchBox: true, searchFieldProps: TextFieldProps(decoration: InputDecoration(hintText: "بحث...", prefixIcon: Icon(Icons.search)))),
                          onChanged: (data) => setState(() => _selectedWorker = data),
                        ),
                        const SizedBox(height: 10),
                        DropdownSearch<WorkerModel>(
                          items: (filter, loadProps) => hrProvider.workersList,
                          itemAsString: (u) => u.compEmpCode.toString(),
                          compareFn: (i1, i2) => i1.empCode == i2.empCode,
                          selectedItem: _selectedWorker,
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(labelText: l10n.workerNumber ?? "Worker Number", border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.badge)),
                          ),
                          popupProps: const PopupProps.menu(showSearchBox: true, searchFieldProps: TextFieldProps(decoration: InputDecoration(hintText: "بحث بالرقم...", prefixIcon: Icon(Icons.search)))),
                          onChanged: (data) => setState(() => _selectedWorker = data),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              ),

              _buildDatePicker(
                label: l10n.requestDateLabel,
                date: _trnsDate,
                onPressed: () => _selectDate(context),
                validator: (value) => _trnsDate == null ? l10n.selectRequestDate : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _notesController,
                l10n.notesLabel,
                Icons.notes_outlined,
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: hrProvider.isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: hrProvider.isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                    : Text(l10n.sendRequest, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required VoidCallback onPressed,
    required FormFieldValidator<String> validator,
  }) {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    final l10n = AppLocalizations.of(context)!;
    final text = date == null ? l10n.selectDate : DateFormat.yMd(locale).format(date);

    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.calendar_today_outlined),
      ),
      onTap: onPressed,
      controller: TextEditingController(text: text),
      validator: validator,
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon,
      {int maxLines = 1, bool isNumber = false, FormFieldValidator<String>? validator}
      ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
      validator: validator,
    );
  }
}