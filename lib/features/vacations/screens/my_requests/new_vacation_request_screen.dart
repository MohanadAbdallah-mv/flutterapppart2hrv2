// features/vacations/screens/my_requests/new_permission_request_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';


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

  // This map will be populated from l10n in didChangeDependencies
  Map<int, String> _vacationTypes = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Populate the vacation types from localization files
    final l10n = AppLocalizations.of(context)!;
    _vacationTypes = {
      1: l10n.vacationTypeRegular,
      2: l10n.vacationTypeUnpaid,
      12: l10n.vacationTypeAnnual,

    };
  }

  void _calculateDuration() {
    if (_startDate != null && _endDate != null) {
      if (_endDate!.isAfter(_startDate!) || _endDate!.isAtSameMomentAs(_startDate!)) {
        final duration = _endDate!.difference(_startDate!).inDays + 1;
        _durationController.text = duration.toString();
      } else {
        _durationController.text = '';
      }
    }
  }

  Future<void> _selectDate(BuildContext context, {required bool isStart}) async {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: locale,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _calculateDuration();
      });
    }
  }

  Future<void> _saveForm() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await hrProvider.createNewVacationRequest(
      empCode: authProvider.currentUser!.empCode,
      compEmpCode:authProvider.currentUser!.compEmpCode ,
      userCode: authProvider.currentUser!.usersCode,
      vacationType: _selectedVacationType!,
      startDate: _startDate!,
      endDate: _endDate!,
      period: int.tryParse(_durationController.text) ?? 0,
      notes: _notesController.text,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.requestSentSuccessfully), backgroundColor: AppColors.successColor));
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hrProvider.error ?? l10n.unexpectedError), backgroundColor: AppColors.errorColor));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newVacationRequestTitle),
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
              _buildSectionTitle(l10n.requestData),
              const SizedBox(height: 16),
              _buildDropdown(),
              const SizedBox(height: 16),
              _buildDatePicker(l10n.vacationStartDate, _startDate, () => _selectDate(context, isStart: true)),
              const SizedBox(height: 16),
              _buildDatePicker(l10n.vacationEndDate, _endDate, () => _selectDate(context, isStart: false)),
              const SizedBox(height: 16),
              _buildTextField(_durationController, l10n.durationInDays, Icons.timer_outlined, isNumber: true, isEnabled: false),
              const SizedBox(height: 16),
              _buildTextField(_notesController, l10n.notes, Icons.notes_outlined, maxLines: 4),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor));
  }

  Widget _buildDropdown() {
    final l10n = AppLocalizations.of(context)!;
    return DropdownButtonFormField<int>(
      value: _selectedVacationType,
      decoration: InputDecoration(labelText: l10n.vacationType, prefixIcon: const Icon(Icons.category_outlined)),
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
        prefixIcon: const Icon(Icons.calendar_today_outlined),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      onTap: onPressed,
      controller: TextEditingController(text: text),
      validator: (value) => date == null ? l10n.selectDateValidation : null,
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false, int maxLines = 1, bool isEnabled = true}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      keyboardType: isNumber ? TextInputType.number : TextInputType.multiline,
      maxLines: maxLines,
      enabled: isEnabled,
    );
  }
}
