// lib/features/salary_confirmation/screens/my_requests/new_salary_confirmation_request_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';

class NewSalaryConfirmationRequestScreen extends StatefulWidget {
  static const String routeName = '/new-salary-confirmation-request';
  const NewSalaryConfirmationRequestScreen({super.key});

  @override
  State<NewSalaryConfirmationRequestScreen> createState() => _NewSalaryConfirmationRequestScreenState();
}

class _NewSalaryConfirmationRequestScreenState extends State<NewSalaryConfirmationRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _trnsDate; // تاريخ الطلب
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _dCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _trnsDate = DateTime.now(); // تعيين التاريخ الحالي كافتراضي
  }

  @override
  void dispose() {
    _notesController.dispose();
    _dCodeController.dispose();
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user == null) return;

    final int? dCode = int.tryParse(_dCodeController.text);
    if (dCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.numericFieldsError), backgroundColor: Colors.red));
      return;
    }

    final bool success = await hrProvider.createSalaryConfirmationRequest(
      empCode: user.empCode,
      userCode: user.usersCode,
      insertUser: user.usersCode,
      compEmpCode: user.compEmpCode,
      trnsDate: _trnsDate!,
      notes: _notesController.text,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.salaryConfirmationRequestSentSuccessfully), backgroundColor: Colors.green));
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newSalaryConfirmationRequest),
        actions: const [LanguageSwitcherButton()],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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