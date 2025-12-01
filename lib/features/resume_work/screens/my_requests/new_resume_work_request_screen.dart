// lib/features/resume_work/screens/my_requests/new_resume_work_request_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart'; // إضافة المكتبة

import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/models/worker_model.dart'; // إضافة الموديل

class NewResumeWorkRequestScreen extends StatefulWidget {
  static const String routeName = '/new-resume-work-request';
  const NewResumeWorkRequestScreen({super.key});

  @override
  State<NewResumeWorkRequestScreen> createState() => _NewResumeWorkRequestScreenState();
}

class _NewResumeWorkRequestScreenState extends State<NewResumeWorkRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _actualResumeDate;
  final TextEditingController _lateReasonController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _cCodeController = TextEditingController();
  final TextEditingController _dCodeController = TextEditingController();

  // ---== متغيرات العمال (جديد) ==---
  bool _isForWorker = false;
  WorkerModel? _selectedWorker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final hrProvider = Provider.of<HrProvider>(context, listen: false);
      if (hrProvider.workersList.isEmpty && authProvider.currentUser != null) {
        hrProvider.fetchWorkersList(authProvider.currentUser!.usersCode);
      }
    });
  }

  @override
  void dispose() {
    _lateReasonController.dispose();
    _notesController.dispose();
    _cCodeController.dispose();
    _dCodeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, {required ValueChanged<DateTime> onDateSelected}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)), // Can be in the past
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  void _submitForm() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // التحقق من اختيار العامل إذا كان الخيار مفعلاً
    if (_isForWorker && _selectedWorker == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectWorkerError ?? "Please select a worker"), backgroundColor: Colors.red),
      );
      return;
    }

    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // ---== تحديد البيانات بناءً على الاختيار ==---
    final int targetEmpCode = _isForWorker ? _selectedWorker!.empCode : authProvider.currentUser!.empCode;
    final int targetCompEmpCode = _isForWorker ? _selectedWorker!.compEmpCode : authProvider.currentUser!.compEmpCode;
    final String targetUserName = _isForWorker ? _selectedWorker!.empName : authProvider.currentUser!.usersName; // للاستخدام في الملاحظات
    // المستخدم الذي يقوم بالإدخال (دائماً أنا)
    final int insertingUserCode = authProvider.currentUser!.usersCode;

    // Validation
    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.endDateAfterStartDateError), backgroundColor: Colors.red));
      return;
    }
    if (_actualResumeDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.resumeDateAfterStartDateError), backgroundColor: Colors.red));
      return;
    }

    // Generate notes
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    final String resumeDateStr = DateFormat.yMd(locale).format(_actualResumeDate!);

    // استخدام الكود والاسم الصحيحين في الملاحظات التلقائية
    final String notes = _notesController.text.isEmpty
        ? "طلب مباشرة عمل بعد اجازة للموظف : $targetCompEmpCode - $targetUserName بتاريخ $resumeDateStr"
        : _notesController.text;

    final bool success = await hrProvider.createResumeWorkRequest(
      userCode: insertingUserCode, // تمرير المستخدم الحالي كـ userCode لجلب السيريال
      empCode: targetEmpCode,      // الموظف المعني (أنا أو العامل)
      compEmpCode: targetCompEmpCode, // كود شركة الموظف المعني
      insertUser: insertingUserCode, // المستخدم الذي أدخل الطلب
      fDate: _startDate!,
      tDate: _endDate!,
      actTDate: _actualResumeDate!,
      lateReason: _lateReasonController.text,
      notes: notes,
      companyCode: int.parse(_cCodeController.text),
      dCode: int.parse(_dCodeController.text),
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.resumeWorkRequestSentSuccessfully), backgroundColor: Colors.green));
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
        title: Text(l10n.newResumeWorkRequest),
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

              _buildDatePicker(
                label: l10n.vacationStartDate,
                date: _startDate,
                onPressed: () => _selectDate(context, onDateSelected: (date) => setState(() => _startDate = date)),
                validator: (value) => _startDate == null ? l10n.selectStartDate : null,
              ),
              const SizedBox(height: 16),
              _buildDatePicker(
                label: l10n.vacationEndDate,
                date: _endDate,
                onPressed: () => _selectDate(context, onDateSelected: (date) => setState(() => _endDate = date)),
                validator: (value) => _endDate == null ? l10n.selectEndDate : null,
              ),
              const SizedBox(height: 16),
              _buildDatePicker(
                label: l10n.resumeWorkDate,
                date: _actualResumeDate,
                onPressed: () => _selectDate(context, onDateSelected: (date) => setState(() => _actualResumeDate = date)),
                validator: (value) => _actualResumeDate == null ? l10n.selectResumeDate : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(_lateReasonController, l10n.delayReason, Icons.notes_outlined, maxLines: 2),
              const SizedBox(height: 16),
              _buildTextField(_notesController, l10n.notesLabel, Icons.article_outlined, maxLines: 3),
              const SizedBox(height: 16),
              _buildTextField(_cCodeController, l10n.componyCode, Icons.numbers, maxLines: 1),
              const SizedBox(height: 16),
              _buildTextField(_dCodeController, l10n.dCode, Icons.numbers, maxLines: 1),
              const SizedBox(height: 16),
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

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      maxLines: maxLines,
      // Validator is optional for notes/reason
    );
  }
}