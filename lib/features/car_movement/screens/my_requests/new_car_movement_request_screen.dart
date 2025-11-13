// lib/features/car_movement/screens/my_requests/new_car_movement_request_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';

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
  DateTime? _movementDate; // التاريخ اللي هيحصل فيه التحرك
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  final TextEditingController _reasonsController = TextEditingController();
  final TextEditingController _carNoController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  Map<int, String> _permissionTypes = {};
  Map<int, String> _reasonTypes = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Populate maps from l10n
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user == null) return;

    // دمج التاريخ مع الوقت زي ما الـ API عاوز
    final DateTime fromDateTime = DateTime(_movementDate!.year, _movementDate!.month, _movementDate!.day, _fromTime!.hour, _fromTime!.minute);
    final DateTime toDateTime = DateTime(_movementDate!.year, _movementDate!.month, _movementDate!.day, _toTime!.hour, _toTime!.minute);

    if (toDateTime.isBefore(fromDateTime) || toDateTime.isAtSameMomentAs(fromDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.timeValidationError), backgroundColor: Colors.red));
      return;
    }

    final bool success = await hrProvider.createCarMovementRequest(
      empCode: user.empCode,
      userCode: user.usersCode,
      insertUser: user.usersCode,
      compEmpCode: user.compEmpCode,
      trnsType: _selectedPermissionType!,
      reasonType: _selectedReasonType!,
      prmDate: _movementDate!, // PrmDate بياخد التاريخ
      fromTime: fromDateTime, // FromTime بياخد التاريخ + وقت البدء
      toTime: toDateTime,   // ToTime بياخد التاريخ + وقت الانتهاء
      carNo: _carNoController.text,
      permReasons: _reasonsController.text,
      notes: _notesController.text,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.carMovementRequestSentSuccessfully), backgroundColor: Colors.green));
        Navigator.of(context).pop(true); // Pop with success
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newCarMovementRequest),
        actions: const [LanguageSwitcherButton()],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                label: l10n.carMovementDateLabel, // <-- تم استخدام الليبل الجديد
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