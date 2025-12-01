// features/loans/screens/my_requests/new_loan_request_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';


import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/models/worker_model.dart';
import '../../../../core/models/loan_type_model.dart';
import '../../../purchases/widgets/language_switcher_button.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../purchases/widgets/language_switcher_button.dart';

class NewLoanRequestScreen extends StatefulWidget {
  static const String routeName = '/new-loan-request';
  const NewLoanRequestScreen({super.key});

  @override
  State<NewLoanRequestScreen> createState() => _NewLoanRequestScreenState();
}

class _NewLoanRequestScreenState extends State<NewLoanRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedLoanType;
  DateTime? _startDate;
  final _totalValueController = TextEditingController();
  final _installmentCountController = TextEditingController();
  final _installmentValueController = TextEditingController();
  final _notesController = TextEditingController();

  // ---== متغيرات العمال ==---
  bool _isForWorker = false;
  WorkerModel? _selectedWorker;

  @override
  void initState() {
    super.initState();
    // Logic for auto-calculating fields
    _totalValueController.addListener(_onAmountChanged);
    _installmentCountController.addListener(_onAmountChanged);
    _installmentValueController.addListener(_onAmountChanged);
  }

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

  void _onAmountChanged() {
    if (!mounted) return;

    final total = double.tryParse(_totalValueController.text) ?? 0.0;
    final count = int.tryParse(_installmentCountController.text) ?? 0;
    final installment = double.tryParse(_installmentValueController.text) ?? 0.0;

    final focusedChild = FocusScope.of(context).focusedChild;
    if (focusedChild == null) return;
    final focusedHashCode = focusedChild.hashCode;

    if (focusedHashCode != _totalValueController.hashCode && count > 0 && installment > 0) {
      _totalValueController.removeListener(_onAmountChanged);
      _totalValueController.text = (count * installment).toStringAsFixed(2);
      _totalValueController.addListener(_onAmountChanged);
    } else if (focusedHashCode != _installmentValueController.hashCode && total > 0 && count > 0) {
      _installmentValueController.removeListener(_onAmountChanged);
      _installmentValueController.text = (total / count).toStringAsFixed(2);
      _installmentValueController.addListener(_onAmountChanged);
    } else if (focusedHashCode != _installmentCountController.hashCode && total > 0 && installment > 0) {
      _installmentCountController.removeListener(_onAmountChanged);
      _installmentCountController.text = (total / installment).round().toString();
      _installmentCountController.addListener(_onAmountChanged);
    }
  }

  @override
  void dispose() {
    _totalValueController.dispose();
    _installmentCountController.dispose();
    _installmentValueController.dispose();
    _notesController.dispose();
    super.dispose();
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

    // تحديد بيانات الموظف (صاحب الطلب الفعلي)
    final int targetEmpCode = _isForWorker ? _selectedWorker!.empCode : authProvider.currentUser!.empCode;
    final int targetCompEmpCode = _isForWorker ? _selectedWorker!.compEmpCode : authProvider.currentUser!.compEmpCode;
    // المستخدم الذي يقوم بالإدخال (دائماً أنا)
    final int insertingUserCode = authProvider.currentUser!.usersCode;

    final success = await hrProvider.createNewLoanRequest(
      empCode: targetEmpCode,
      compEmpCode: targetCompEmpCode,
      userCode: insertingUserCode,
      loanType: _selectedLoanType!,
      startDate: _startDate!,
      installmentsCount: int.parse(_installmentCountController.text),
      totalValue: double.parse(_totalValueController.text),
      installmentValue: double.parse(_installmentValueController.text),
      notes: _notesController.text,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.loanRequestSentSuccessfully), backgroundColor: AppColors.successColor));
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hrProvider.error ?? l10n.unexpectedError), backgroundColor: AppColors.errorColor));
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
        title: Text(l10n.newLoanRequestTitle),
        backgroundColor: AppColors.primaryColor,
        actions: const [
          LanguageSwitcherButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Form(
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

              _buildSectionTitle(l10n.requestData),
              const SizedBox(height: 16),
              _buildDropdown(context.watch<HrProvider>().loanTypes),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 16),
              _buildTextField(_totalValueController, l10n.totalLoanAmount, Icons.attach_money_outlined, isNumber: true),
              const SizedBox(height: 16),
              _buildTextField(_installmentCountController, l10n.installmentsCount, Icons.format_list_numbered, isNumber: true),
              const SizedBox(height: 16),
              _buildTextField(_installmentValueController, l10n.installmentValue, Icons.payment, isNumber: true),
              const SizedBox(height: 16),
              _buildTextField(_notesController, l10n.notes, Icons.notes_outlined, maxLines: 4, isRequired: false),
              const SizedBox(height: 30),
              Consumer<HrProvider>(
                builder: (context, provider, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: provider.isCreatingRequest ? null : _saveForm,
                      icon: provider.isCreatingRequest
                          ? Container(width: 24, height: 24, padding: const EdgeInsets.all(2.0), child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : const Icon(Icons.save),
                      label: Text(provider.isCreatingRequest ? l10n.saving : l10n.saveRequest),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor));
  }

  Widget _buildDropdown(List<LoanTypeItem> loanTypes) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode == 'ar';
    return DropdownButtonFormField<int>(
      value: _selectedLoanType,
      decoration: InputDecoration(labelText: l10n.loanType, prefixIcon: const Icon(Icons.category_outlined)),
      items: loanTypes.map((type) => DropdownMenuItem<int>(value: type.loanTypeCode, child: Text(isArabic ? (type.nameA ?? '') : (type.nameE ?? type.nameA ?? '')))).toList(),
      onChanged: (value) => setState(() => _selectedLoanType = value),
      validator: (v) => v == null ? l10n.selectLoanTypeValidation : null,
    );
  }

  Widget _buildDatePicker() {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale;
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(labelText: l10n.repaymentStartDate, prefixIcon: const Icon(Icons.calendar_today_outlined), suffixIcon: const Icon(Icons.arrow_drop_down)),
      onTap: () async {
        final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030), locale: locale);
        if (date != null) setState(() => _startDate = date);
      },
      controller: TextEditingController(text: _startDate == null ? l10n.selectDate : DateFormat.yMd(locale.toLanguageTag()).format(_startDate!)),
      validator: (v) => _startDate == null ? l10n.selectDateValidation : null,
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false, int maxLines = 1, bool isRequired = true}) {
    final l10n = AppLocalizations.of(context)!;
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.multiline,
      maxLines: maxLines,
      validator: (v) {
        if (isRequired && (v == null || v.isEmpty)) {
          return l10n.fieldRequiredValidation;
        }
        return null;
      },
    );
  }
}