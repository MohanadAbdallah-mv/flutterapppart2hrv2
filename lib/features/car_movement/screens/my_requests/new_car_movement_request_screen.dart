// lib/features/car_movement/screens/my_requests/new_car_movement_request_screen.dart

import 'package:flutter/material.dart';
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

class NewCarMovementRequestScreen extends StatefulWidget {
  static const String routeName = '/new-car-movement-request';
  const NewCarMovementRequestScreen({super.key});

  @override
  State<NewCarMovementRequestScreen> createState() => _NewCarMovementRequestScreenState();
}

class _NewCarMovementRequestScreenState extends State<NewCarMovementRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _selectedPermissionType;
  int? _selectedReasonType;
  DateTime? _movementDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  final TextEditingController _reasonsController = TextEditingController();
  final TextEditingController _carNoController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

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

    // جلب العمال
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    if (hrProvider.workersList.isEmpty && authProvider.currentUser != null) {
      hrProvider.fetchWorkersList(authProvider.currentUser!.usersCode);
    }
  }

  @override
  void dispose() {
    _reasonsController.dispose();
    _carNoController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _movementDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _movementDate) {
      setState(() {
        _movementDate = picked;
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
    final String targetUserName = _isForWorker ? _selectedWorker!.empName : user.usersName;
    final int insertingUserCode = user.usersCode;

    final DateTime fromDateTime = DateTime(_movementDate!.year, _movementDate!.month, _movementDate!.day, _fromTime!.hour, _fromTime!.minute);
    final DateTime toDateTime = DateTime(_movementDate!.year, _movementDate!.month, _movementDate!.day, _toTime!.hour, _toTime!.minute);

    if (toDateTime.isBefore(fromDateTime) || toDateTime.isAtSameMomentAs(fromDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.timeValidationError), backgroundColor: Colors.red));
      return;
    }

    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    final String prmDateStr = DateFormat.yMd(locale).format(_movementDate!);
    final String fromTimeStr = _formatTimeOfDay(_fromTime!, locale);
    final String toTimeStr = _formatTimeOfDay(_toTime!, locale);

    String permissionTypeName = _permissionTypes[_selectedPermissionType] ?? "N/A";
    // ملاحظات بالاسم الصحيح
    final String notes = "طلب $permissionTypeName الموظف $targetUserName عن يوم $prmDateStr من الفترة من $fromTimeStr الى $toTimeStr";

    final bool success = await hrProvider.createCarMovementRequest(
      userCode: insertingUserCode,
      empCode: targetEmpCode,
      compEmpCode: targetCompEmpCode,
      insertUser: insertingUserCode,
      trnsType: _selectedPermissionType!,
      reasonType: _selectedReasonType!,
      prmDate: _movementDate!,
      fromTime: fromDateTime,
      toTime: toDateTime,
      carNo: _carNoController.text,
      permReasons: _reasonsController.text,
      notes: notes,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.carMovementRequestSentSuccessfully), backgroundColor: Colors.green));
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hrProvider.error ?? l10n.actionFailed), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    final hrProvider = Provider.of<HrProvider>(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newCarMovementRequest),
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

              _buildDatePicker(
                label: l10n.carMovementDateLabel,
                date: _movementDate,
                onPressed: _selectDate,
                validator: (value) => _movementDate == null ? l10n.selectCarMovementDateValidation : null,
              ),

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
              _buildTextField(
                _carNoController,
                l10n.carNoLabel,
                Icons.directions_car_filled_outlined,
                validator: (value) => value == null || value.isEmpty ? l10n.selectCarNoValidation : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(_reasonsController, l10n.reasonsLabel, Icons.notes_outlined, maxLines: 2),
              const SizedBox(height: 16),
              _buildTextField(_notesController, l10n.notesLabel, Icons.article_outlined, maxLines: 3),
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

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon,
      {int maxLines = 1, FormFieldValidator<String>? validator}
      ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      maxLines: maxLines,
      validator: validator,
    );
  }
}