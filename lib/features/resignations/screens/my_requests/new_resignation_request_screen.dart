// features/resignations/screens/my_requests/new_resignation_request_screen.dart

import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart'; // إضافة المكتبة

import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/models/worker_model.dart'; // إضافة الموديل

class NewResignationRequestScreen extends StatefulWidget {
  static const String routeName = '/new-resignation-request';
  const NewResignationRequestScreen({super.key});

  @override
  State<NewResignationRequestScreen> createState() => _NewResignationRequestScreenState();
}

class _NewResignationRequestScreenState extends State<NewResignationRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _endDate;
  DateTime? _lastWorkDate;
  final _reasonsController = TextEditingController();

  // ---== متغيرات العمال (جديد) ==---
  bool _isForWorker = false;
  WorkerModel? _selectedWorker;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // التأكد من جلب العمال عند فتح الشاشة
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    if (hrProvider.workersList.isEmpty && authProvider.currentUser != null) {
      hrProvider.fetchWorkersList(authProvider.currentUser!.usersCode);
    }
  }

  @override
  void dispose() {
    _reasonsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, {required bool isEndDate}) async {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
      locale: locale,
    );
    if (picked != null) {
      setState(() {
        if (isEndDate) {
          _endDate = picked;
        } else {
          _lastWorkDate = picked;
        }
      });
    }
  }

  Future<void> _saveForm() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    // التحقق من اختيار العامل إذا كان الخيار مفعلاً
    if (_isForWorker && _selectedWorker == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectWorkerError ?? "Please select a worker"), backgroundColor: Colors.red),
      );
      return;
    }

    _formKey.currentState!.save();

    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // ---== تحديد البيانات بناءً على الاختيار ==---
    final int targetEmpCode = _isForWorker ? _selectedWorker!.empCode : authProvider.currentUser!.empCode;
    final int targetCompEmpCode = _isForWorker ? _selectedWorker!.compEmpCode : authProvider.currentUser!.compEmpCode;
    // المستخدم الذي يقوم بالإدخال (دائماً أنا)
    final int insertingUserCode = authProvider.currentUser!.usersCode;

    final success = await hrProvider.createNewResignationRequest(
      empCode: targetEmpCode,
      compEmpCode: targetCompEmpCode,
      endDate: _endDate!,
      lastWorkDate: _lastWorkDate!,
      reasons: _reasonsController.text,
      usersCode: insertingUserCode, // تمرير المستخدم الحالي كـ InsertUser
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.resignationRequestSentSuccessfully), backgroundColor: AppColors.successColor));
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hrProvider.error ?? l10n.unexpectedError), backgroundColor: AppColors.errorColor));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hrProvider = Provider.of<HrProvider>(context); // للاستماع للتحميل وللقائمة
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newResignationRequestTitle),
        backgroundColor: AppColors.primaryColor,
        actions: const [
          LanguageSwitcherButton(),
          SizedBox(width: 8),
        ],
      ),
      body: hrProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---== كارت اختيار نوع الطلب (جديد) ==---
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

                        // 1. بحث باسم العامل
                        DropdownSearch<WorkerModel>(
                          items: (filter, loadProps) => hrProvider.workersList,
                          itemAsString: (WorkerModel u) => isArabic ? u.empName : (u.empNameE ?? u.empName),
                          compareFn: (item1, item2) => item1.empCode == item2.empCode,
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

                        // 2. بحث برقم العامل
                        DropdownSearch<WorkerModel>(
                          items: (filter, loadProps) => hrProvider.workersList,
                          itemAsString: (WorkerModel u) => u.compEmpCode.toString(),
                          compareFn: (item1, item2) => item1.empCode == item2.empCode,
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
              // ---== نهاية الجزء الجديد ==---

              Text(l10n.requestData, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
              const SizedBox(height: 16),
              _buildDatePicker(l10n.resignationEndDate, _endDate, () => _selectDate(context, isEndDate: true)),
              const SizedBox(height: 16),
              _buildDatePicker(l10n.lastWorkDate, _lastWorkDate, () => _selectDate(context, isEndDate: false)),
              const SizedBox(height: 16),
              _buildTextField(_reasonsController, l10n.reasonsForLeaving, Icons.notes_outlined, maxLines: 5),
              const SizedBox(height: 30),

              // الزر (تم تعديله ليتناسق مع الـ provider.isLoading)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: hrProvider.isCreatingRequest ? null : _saveForm,
                  icon: hrProvider.isCreatingRequest
                      ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : const Icon(Icons.save),
                  label: Text(hrProvider.isCreatingRequest ? l10n.saving : l10n.saveRequest),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, VoidCallback onPressed) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    final text = date == null ? l10n.selectDate : DateFormat.yMd(locale).format(date);
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.calendar_today_outlined),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      onTap: onPressed,
      controller: TextEditingController(text: text),
      validator: (value) => date == null ? l10n.selectDateValidation : null,
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      maxLines: maxLines,
      validator: (v) => v == null || v.isEmpty ? l10n.fieldRequiredValidation : null,
    );
  }
}