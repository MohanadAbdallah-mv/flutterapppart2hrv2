// lib/features/salary_confirmation/widgets/my_requests/my_salary_confirmation_request_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../models/my_salary_confirmation_request_model.dart';

class MySalaryConfirmationRequestCard extends StatelessWidget {
  final MySalaryConfirmationRequestItem request;
  final VoidCallback onTap;

  const MySalaryConfirmationRequestCard({super.key, required this.request, required this.onTap});

  String _formatDate(String? dateString, String locale) {
    if (dateString == null) return '';
    try {
      return DateFormat.yMd(locale).format(DateTime.parse(dateString));
    } catch (e) {
      return dateString;
    }
  }

  String _getStatusText(BuildContext context, int? flag) {
    final l10n = AppLocalizations.of(context)!;
    switch (flag) {
      case 1: return l10n.approved;
      case -1: return l10n.rejected;
      case 0: return l10n.underAction;
      default: return l10n.notSpecified;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    final status = _getStatusText(context, request.aproveFlag);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      l10n.salaryConfirmationRequestDetails, // "تفاصيل طلب تثبيت راتب"
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.getStatusColor(request.aproveFlag).withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                    child: Text(status, style: TextStyle(color: AppColors.getStatusColor(request.aproveFlag), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Divider(height: 20),
              _buildInfoRow(Icons.calendar_today_outlined, l10n.requestDateLabel, _formatDate(request.trnsDate, locale)),
              if (request.notes != null && request.notes!.isNotEmpty)
                _buildInfoRow(Icons.notes_outlined, l10n.notesLabel, request.notes!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 5),
          Expanded(child: Text(value, style: TextStyle(color: Colors.grey.shade800))),
        ],
      ),
    );
  }
}