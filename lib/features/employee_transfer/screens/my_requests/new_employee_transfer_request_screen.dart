// lib/features/employee_transfer/screens/my_requests/new_employee_transfer_request_screen.dart
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
// ---== Imports جديدة للـ Dropdowns ==---
import '../../models/company_model.dart';
import '../../models/department_model.dart';

class NewEmployeeTransferRequestScreen extends StatefulWidget {
  static const String routeName = '/new-employee-transfer-request';
  const NewEmployeeTransferRequestScreen({super.key});

  @override
  State<NewEmployeeTransferRequestScreen> createState() => _NewEmployeeTransferRequestScreenState();
}

class _NewEmployeeTransferRequestScreenState extends State<NewEmployeeTransferRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _movingDate;

  int? _selectedCompanyCode;
  int? _selectedDCode;

  final TextEditingController _movingNoteController = TextEditingController();
  final TextEditingController _movingNoteEController = TextEditingController();

  // ---== متغيرات العمال ==---
  bool _isForWorker = false;
  WorkerModel? _selectedWorker;

  @override
  void initState() {
    super.initState();
    // جلب قائمة الشركات أول ما الشاشة تفتح
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HrProvider>(context, listen: false).fetchCompanies();
      Provider.of<HrProvider>(context, listen: false).clearDepartments(); // تنظيف قائمة الإدارات القديمة
    });
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
    _movingNoteController.dispose();
    _movingNoteEController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _movingDate) {
      setState(() {
        _movingDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

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

    final int? companyCodeNew = _selectedCompanyCode;
    final int? dCodeNew = _selectedDCode;

    if (companyCodeNew == null || dCodeNew == null ) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.numericFieldsError), backgroundColor: Colors.red));
      return;
    }

    // ---== تحديد البيانات ==---
    final int targetEmpCode = _isForWorker ? _selectedWorker!.empCode : user.empCode;
    final int targetCompEmpCode = _isForWorker ? _selectedWorker!.compEmpCode : user.compEmpCode;
    final int insertingUserCode = user.usersCode;

    final bool success = await hrProvider.createEmployeeTransferRequest(
        empCode: targetEmpCode,
        insertUser: insertingUserCode,
        companyCodeNew: companyCodeNew,
        dCodeNew: dCodeNew,
        compEmpCodeNew: targetCompEmpCode,
        movingDate: _movingDate!,
        movingNote: _movingNoteController.text,
        movingNoteE: _movingNoteEController.text,
        userCode: insertingUserCode
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.employeeTransferRequestSentSuccessfully), backgroundColor: Colors.green));
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hrProvider.error ?? l10n.actionFailed), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hrProvider = context.watch<HrProvider>();
    final isArabic = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newEmployeeTransferRequest),
        actions: const [LanguageSwitcherButton()],
      ),
      body: Form(
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
                label: l10n.transferDate,
                date: _movingDate,
                onPressed: () => _selectDate(context),
                validator: (value) => _movingDate == null ? l10n.selectTransferDate : null,
              ),
              const SizedBox(height: 16),

              // ---== استخدام Dropdown للشركات ==---
              _buildCompanyDropdown(hrProvider, l10n, isArabic),
              const SizedBox(height: 16),

              // ---== استخدام Dropdown للإدارات ==---
              _buildDepartmentDropdown(hrProvider, l10n, isArabic),
              const SizedBox(height: 16),

              const SizedBox(height: 16),
              _buildTextField(_movingNoteController, l10n.transferNotesAr, Icons.notes_outlined, maxLines: 2),
              const SizedBox(height: 16),
              _buildTextField(_movingNoteEController, l10n.transferNotesEn, Icons.notes_outlined, maxLines: 2),
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

  // ---== ودجت الشركات ==---
  Widget _buildCompanyDropdown(HrProvider hrProvider, AppLocalizations l10n, bool isArabic) {
    return DropdownButtonFormField<int>(
      value: _selectedCompanyCode,
      decoration: InputDecoration(
        labelText: l10n.newCompanyCode,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.business_outlined),
      ),
      isExpanded: true,
      hint: Text(l10n.selectCompany),
      items: hrProvider.companies.map((CompanyItem company) {
        return DropdownMenuItem<int>(
          value: company.companyCode,
          child: Text(isArabic ? company.companyDesc ?? '' : company.companyDescE ?? company.companyDesc ?? ''),
        );
      }).toList(),
      onChanged: (int? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedCompanyCode = newValue;
            _selectedDCode = null;
          });
          hrProvider.clearDepartments();
          hrProvider.fetchDepartments(newValue);
        }
      },
      validator: (value) => value == null ? l10n.selectCompany : null,
    );
  }

  // ---== ودجت الإدارات ==---
  Widget _buildDepartmentDropdown(HrProvider hrProvider, AppLocalizations l10n, bool isArabic) {
    bool isDisabled = _selectedCompanyCode == null || hrProvider.departments.isEmpty;

    return DropdownButtonFormField<int>(
      value: _selectedDCode,
      decoration: InputDecoration(
        labelText: l10n.newDCode,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.account_tree_outlined),
        filled: isDisabled,
        fillColor: Colors.grey[50],
      ),
      isExpanded: true,
      hint: Text(l10n.selectDepartment),
      items: hrProvider.departments.map((DepartmentItem dept) {
        return DropdownMenuItem<int>(
          value: dept.dCode,
          child: Text(isArabic ? dept.dName ?? '' : dept.dNameE ?? dept.dName ?? ''),
        );
      }).toList(),
      onChanged: isDisabled ? null : (int? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedDCode = newValue;
          });
        }
      },
      validator: (value) => value == null ? l10n.selectDepartment : null,
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