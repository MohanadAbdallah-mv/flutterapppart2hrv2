/*
// features/permissions/screens/my_requests/new_permission_request_screen.dart

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

class NewPermissionRequestScreen extends StatefulWidget {
  static const String routeName = '/new-permission-request';
  const NewPermissionRequestScreen({super.key});

  @override
  State<NewPermissionRequestScreen> createState() => _NewPermissionRequestScreenState();
}

class _NewPermissionRequestScreenState extends State<NewPermissionRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedPermissionType;
  int? _selectedReasonType;
  DateTime? _permissionDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  final TextEditingController _reasonsController = TextEditingController();

  // ---== متغيرات العمال (جديد) ==---
  bool _isForWorker = false;
  WorkerModel? _selectedWorker;

  Map<int, String> _permissionTypes = {};
  Map<int, String> _reasonTypes = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    _permissionTypes = {
      1: l10n.permissionType1,
      2: l10n.permissionType2,
      3: l10n.permissionType3,
      4: l10n.permissionType4,
    };
    _reasonTypes = {
      1: l10n.reasonType1,
      2: l10n.reasonType2,
      3: l10n.reasonType3,
    };

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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _permissionDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _permissionDate) {
      setState(() {
        _permissionDate = picked;
      });
    }
  }

  Future<void> _selectTime(bool isFromTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (isFromTime ? _fromTime : _toTime) ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isFromTime) {
          _fromTime = picked;
        } else {
          _toTime = picked;
        }
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay tod, String locale) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat.jm(locale).format(dt);
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

    final DateTime fromDateTime = DateTime(_permissionDate!.year, _permissionDate!.month, _permissionDate!.day, _fromTime!.hour, _fromTime!.minute);
    final DateTime toDateTime = DateTime(_permissionDate!.year, _permissionDate!.month, _permissionDate!.day, _toTime!.hour, _toTime!.minute);

    if (toDateTime.isBefore(fromDateTime) || toDateTime.isAtSameMomentAs(fromDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.timeValidationError), backgroundColor: Colors.red));
      return;
    }

    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    final String prmDateStr = DateFormat.yMd(locale).format(_permissionDate!);
    final String fromTimeStr = _formatTimeOfDay(_fromTime!, locale);
    final String toTimeStr = _formatTimeOfDay(_toTime!, locale);

    String permissionTypeName = _getPermissionTypeName(_selectedPermissionType!);
    // تعديل الملاحظات لتشمل اسم الموظف الفعلي (سواء أنا أو العامل)
    final String notes = "طلب $permissionTypeName الموظف $targetUserName عن يوم $prmDateStr من الفترة من $fromTimeStr الى $toTimeStr";

    final bool success = await hrProvider.createPermissionRequest(
      userCode: insertingUserCode, // تمرير المستخدم الحالي كـ userCode لجلب السيريال
      empCode: targetEmpCode,      // الموظف المعني (أنا أو العامل)
      compEmpCode: targetCompEmpCode, // كود شركة الموظف المعني
      insertUser: insertingUserCode, // المستخدم الذي أدخل الطلب
      trnsType: _selectedPermissionType!,
      reasonType: _selectedReasonType!,
      prmDate: _permissionDate!,
      fromTime: fromDateTime,
      toTime: toDateTime,
      permReasons: _reasonsController.text.isEmpty ? permissionTypeName : _reasonsController.text,
      notes: notes,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.permissionRequestSentSuccessfully), backgroundColor: Colors.green));
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hrProvider.error ?? l10n.actionFailed), backgroundColor: Colors.red));
      }
    }
  }

  String _getPermissionTypeName(int type) {
    return _permissionTypes[type] ?? "N/A";
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    final hrProvider = Provider.of<HrProvider>(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newPermissionRequest),
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

              _buildDropdown(
                label: l10n.permissionTypeLabel,
                value: _selectedPermissionType,
                items: _permissionTypes,
                onChanged: (value) => setState(() => _selectedPermissionType = value),
                validator: (value) => value == null ? l10n.selectPermissionTypeValidation : null,
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                label: l10n.reasonTypeLabel,
                value: _selectedReasonType,
                items: _reasonTypes,
                onChanged: (value) => setState(() => _selectedReasonType = value),
                validator: (value) => value == null ? l10n.selectReasonTypeValidation : null,
              ),
              const SizedBox(height: 16),
              _buildDatePicker(l10n.permissionDateLabel, _permissionDate, _selectDate),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTimePicker(l10n.fromTimeLabel, _fromTime, () => _selectTime(true), locale),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTimePicker(l10n.toTimeLabel, _toTime, () => _selectTime(false), locale),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(_reasonsController, l10n.reasonsLabel, Icons.notes_outlined, maxLines: 3),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: hrProvider.isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _buildDropdown({
    required String label,
    required int? value,
    required Map<int, String> items,
    required ValueChanged<int?> onChanged,
    required FormFieldValidator<int> validator,
  }) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.category_outlined),
      ),
      items: items.entries.map((entry) {
        return DropdownMenuItem<int>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
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
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.calendar_today_outlined),
      ),
      onTap: onPressed,
      controller: TextEditingController(text: text),
      validator: (value) => date == null ? l10n.selectPermissionDateValidation : null,
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay? time, VoidCallback onPressed, String locale) {
    final l10n = AppLocalizations.of(context)!;
    final text = time == null ? l10n.selectTime : _formatTimeOfDay(time, locale);

    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.access_time_outlined),
      ),
      onTap: onPressed,
      controller: TextEditingController(text: text),
      validator: (value) => time == null ? (label == l10n.fromTimeLabel ? l10n.selectFromTimeValidation : l10n.selectToTimeValidation) : null,
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
    );
  }
}
*/
// lib/features/permissions/screens/my_requests/new_permission_request_screen.dart

import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/models/worker_model.dart';

class NewPermissionRequestScreen extends StatefulWidget {
  static const String routeName = '/new-permission-request';
  const NewPermissionRequestScreen({super.key});

  @override
  State<NewPermissionRequestScreen> createState() => _NewPermissionRequestScreenState();
}

class _NewPermissionRequestScreenState extends State<NewPermissionRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedPermissionType;
  int? _selectedReasonType;
  DateTime? _permissionDate;
  DateTime? _permissionEndDate; // متغير جديد لتاريخ الانتهاء (للانتداب)

  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  final TextEditingController _reasonsController = TextEditingController();

  // ---== متغيرات العمال ==---
  bool _isForWorker = false;
  WorkerModel? _selectedWorker;

  Map<int, String> _permissionTypes = {};
  Map<int, String> _reasonTypes = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context)!;
    _permissionTypes = {
      1: l10n.permissionType1, // استئذان
      2: l10n.permissionType2, // نسيان بصمة حضور
      3: l10n.permissionType3, // نسيان بصمة انصراف
      4: l10n.permissionType4, // مهمة عمل خارجي
      5: l10n.permissionType5, // انتداب خارجي (جديد)
    };
    _reasonTypes = {
      1: l10n.reasonType1,
      2: l10n.reasonType2,
      3: l10n.reasonType3,
    };

    // التأكد من جلب العمال
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

  // اختيار التاريخ الأساسي
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _permissionDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _permissionDate) {
      setState(() {
        _permissionDate = picked;
      });
    }
  }

  // اختيار تاريخ الانتهاء (للانتداب)
  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _permissionEndDate ?? (_permissionDate ?? DateTime.now()),
      firstDate: _permissionDate ?? DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _permissionEndDate) {
      setState(() {
        _permissionEndDate = picked;
      });
    }
  }

  Future<void> _selectTime(bool isFromTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (isFromTime ? _fromTime : _toTime) ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isFromTime) {
          _fromTime = picked;
        } else {
          _toTime = picked;
        }
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay tod, String locale) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat.jm(locale).format(dt);
  }

  void _submitForm() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // التحقق من اختيار العامل
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

    // ---== تجهيز البيانات ==---
    final int targetEmpCode = _isForWorker ? _selectedWorker!.empCode : user.empCode;
    final int targetCompEmpCode = _isForWorker ? _selectedWorker!.compEmpCode : user.compEmpCode;
    final String targetUserName = _isForWorker ? _selectedWorker!.empName : user.usersName;
    final int insertingUserCode = user.usersCode;

    // التحقق من الوقت فقط في الحالات 1 و 4
    bool isTimeRequired = _selectedPermissionType == 1 || _selectedPermissionType == 4;

    DateTime fromDateTime;
    DateTime toDateTime;

    if (isTimeRequired) {
      // دمج التاريخ مع الوقت المختار
      fromDateTime = DateTime(_permissionDate!.year, _permissionDate!.month, _permissionDate!.day, _fromTime!.hour, _fromTime!.minute);
      toDateTime = DateTime(_permissionDate!.year, _permissionDate!.month, _permissionDate!.day, _toTime!.hour, _toTime!.minute);

      if (toDateTime.isBefore(fromDateTime) || toDateTime.isAtSameMomentAs(fromDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.timeValidationError), backgroundColor: Colors.red));
        return;
      }
    } else {
      // في حالة عدم وجود وقت (2, 3, 5)، نرسل التاريخ فقط مع وقت 00:00
      fromDateTime = DateTime(_permissionDate!.year, _permissionDate!.month, _permissionDate!.day, 0, 0);
      toDateTime = DateTime(_permissionDate!.year, _permissionDate!.month, _permissionDate!.day, 0, 0);
    }

    // التحقق من التاريخ الثاني في حالة الانتداب (5)
    if (_selectedPermissionType == 5) {
      if (_permissionEndDate!.isBefore(_permissionDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.endDateAfterStartDateError), backgroundColor: Colors.red));
        return;
      }
    }

    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    final String prmDateStr = DateFormat.yMd(locale).format(_permissionDate!);

    String timeStr = "";
    if (isTimeRequired) {
      final String fromTimeStr = _formatTimeOfDay(_fromTime!, locale);
      final String toTimeStr = _formatTimeOfDay(_toTime!, locale);
      timeStr = " من الفترة من $fromTimeStr الى $toTimeStr";
    }

    String permissionTypeName = _getPermissionTypeName(_selectedPermissionType!);
    final String notes = "طلب $permissionTypeName الموظف $targetUserName عن يوم $prmDateStr$timeStr";

    final bool success = await hrProvider.createPermissionRequest(
      userCode: insertingUserCode,
      empCode: targetEmpCode,
      compEmpCode: targetCompEmpCode,
      insertUser: insertingUserCode,
      trnsType: _selectedPermissionType!,
      reasonType: _selectedReasonType!,
      prmDate: _permissionDate!,
      prmToDate: _selectedPermissionType == 5 ? _permissionEndDate : null, // إرسال التاريخ الثاني فقط في حالة الانتداب
      fromTime: fromDateTime,
      toTime: toDateTime,
      permReasons: _reasonsController.text.isEmpty ? permissionTypeName : _reasonsController.text,
      notes: notes,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.permissionRequestSentSuccessfully), backgroundColor: Colors.green));
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hrProvider.error ?? l10n.actionFailed), backgroundColor: Colors.red));
      }
    }
  }

  String _getPermissionTypeName(int type) {
    return _permissionTypes[type] ?? "N/A";
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    final hrProvider = Provider.of<HrProvider>(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // تحديد هل نظهر الوقت أم لا
    bool showTimePickers = _selectedPermissionType == 1 || _selectedPermissionType == 4;
    // تحديد هل نظهر تاريخ الانتهاء أم لا (للانتداب)
    bool showEndDate = _selectedPermissionType == 5;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newPermissionRequest),
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
              // ---== كارت اختيار نوع الطلب ==---
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
              // ---== نهاية الكارت ==---

              _buildDropdown(
                label: l10n.permissionTypeLabel,
                value: _selectedPermissionType,
                items: _permissionTypes,
                onChanged: (value) => setState(() {
                  _selectedPermissionType = value;
                  // تصفير القيم عند تغيير النوع لتجنب أخطاء منطقية
                  if (!showTimePickers) {
                    _fromTime = null;
                    _toTime = null;
                  }
                  if (!showEndDate) {
                    _permissionEndDate = null;
                  }
                }),
                validator: (value) => value == null ? l10n.selectPermissionTypeValidation : null,
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: l10n.reasonTypeLabel,
                value: _selectedReasonType,
                items: _reasonTypes,
                onChanged: (value) => setState(() => _selectedReasonType = value),
                validator: (value) => value == null ? l10n.selectReasonTypeValidation : null,
              ),
              const SizedBox(height: 16),

              // التاريخ الأساسي (يظهر دائماً)
              _buildDatePicker(
                label: l10n.permissionDateLabel,
                date: _permissionDate,
                onPressed: _selectDate,
                validator: (value) => _permissionDate == null ? l10n.selectPermissionDateValidation : null,
              ),

              // ---== حالة الانتداب (نوع 5): إظهار تاريخ الانتهاء ==---
              if (showEndDate) ...[
                const SizedBox(height: 16),
                _buildDatePicker(
                  label: l10n.permissionEndDateLabel ?? "End Date", // تاريخ الانتهاء
                  date: _permissionEndDate,
                  onPressed: _selectEndDate,
                  validator: (value) => _permissionEndDate == null ? (l10n.selectPermissionEndDateValidation ?? "Select end date") : null,
                ),
              ],

              // ---== حالة الاستئذان (1) أو المهمة (4): إظهار الوقت ==---
              if (showTimePickers) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimePicker(l10n.fromTimeLabel, _fromTime, () => _selectTime(true), locale),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTimePicker(l10n.toTimeLabel, _toTime, () => _selectTime(false), locale),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 16),
              _buildTextField(_reasonsController, l10n.reasonsLabel, Icons.notes_outlined, maxLines: 3),
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

  Widget _buildDropdown({
    required String label,
    required int? value,
    required Map<int, String> items,
    required ValueChanged<int?> onChanged,
    required FormFieldValidator<int> validator,
  }) {
    return DropdownButtonFormField<int>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.category_outlined),
      ),
      items: items.entries.map((entry) {
        return DropdownMenuItem<int>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required VoidCallback onPressed,
    required FormFieldValidator<String> validator
  }) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
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

  Widget _buildTimePicker(String label, TimeOfDay? time, VoidCallback onPressed, String locale) {
    final l10n = AppLocalizations.of(context)!;
    final text = time == null ? l10n.selectTime : _formatTimeOfDay(time, locale);

    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.access_time_outlined),
      ),
      onTap: onPressed,
      controller: TextEditingController(text: text),
      validator: (value) => time == null ? (label == l10n.fromTimeLabel ? l10n.selectFromTimeValidation : l10n.selectToTimeValidation) : null,
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
    );
  }
}