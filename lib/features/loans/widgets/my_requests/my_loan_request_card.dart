// lib/features/loans/widgets/my_requests/my_loan_request_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../models/my_loan_request_model.dart';

class MyLoanRequestCard extends StatelessWidget {
  final MyLoanRequestItem request;
  final VoidCallback onTap;

  const MyLoanRequestCard({super.key, required this.request, required this.onTap});

  String _formatDate(String? dateString, String locale) {
    if (dateString == null) return '';
    return DateFormat.yMd(locale).format(DateTime.parse(dateString));
  }

  String _formatCurrency(double? amount, String locale) {
    if (amount == null) return '0';
    final format = NumberFormat.currency(locale: locale, symbol: locale == 'ar_SA' ? 'ر.س' : '\$');
    return format.format(amount);
  }

  String _getRequestStatusName(BuildContext context, int? flag) {
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
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';
    final locale = localeProvider.locale.toLanguageTag();
    final currencyLocale = isArabic ? 'ar_SA' : 'en_US';

    final hrProvider = Provider.of<HrProvider>(context, listen: false);
    final loanType = hrProvider.getLoanTypeName(request.loanType!, isArabic);
    final status = _getRequestStatusName(context, request.authFlag);

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      loanType,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.getStatusColor(request.authFlag).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(color: AppColors.getStatusColor(request.authFlag), fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.date_range_outlined, l10n.requestDateLabel, _formatDate(request.reqLoanDate, locale)),
              _buildInfoRow(Icons.attach_money_outlined, l10n.loanValueLabel, _formatCurrency(request.loanValuePys, currencyLocale)),
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
        children: [
          Icon(icon, color: AppColors.textColor.withOpacity(0.6), size: 20),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textColor, fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          Expanded(child: Text(value, style: TextStyle(fontSize: 14, color: AppColors.textColor.withOpacity(0.8)))),
        ],
      ),
    );
  }
}
