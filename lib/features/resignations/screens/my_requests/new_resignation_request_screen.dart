// features/resignations/screens/my_requests/new_resignation_request_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';


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
    _formKey.currentState!.save();

    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await hrProvider.createNewResignationRequest(
      empCode: authProvider.currentUser!.empCode,
      compEmpCode: authProvider.currentUser!.compEmpCode,
      endDate: _endDate!,
      lastWorkDate: _lastWorkDate!,
      reasons: _reasonsController.text,
      usersCode: authProvider.currentUser!.usersCode,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.newResignationRequestTitle),
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
              Text(l10n.requestData, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
              const SizedBox(height: 16),
              _buildDatePicker(l10n.resignationEndDate, _endDate, () => _selectDate(context, isEndDate: true)),
              const SizedBox(height: 16),
              _buildDatePicker(l10n.lastWorkDate, _lastWorkDate, () => _selectDate(context, isEndDate: false)),
              const SizedBox(height: 16),
              _buildTextField(_reasonsController, l10n.reasonsForLeaving, Icons.notes_outlined, maxLines: 5),
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
