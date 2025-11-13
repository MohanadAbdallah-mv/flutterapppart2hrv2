// features/loans/widgets/my_requests/loan_details_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../models/my_loan_request_model.dart';
import '../../../approvals/widgets/auth_timeline_widget.dart';

class LoanDetailsBottomSheet extends StatefulWidget {
  final MyLoanRequestItem request;
  const LoanDetailsBottomSheet({super.key, required this.request});

  @override
  State<LoanDetailsBottomSheet> createState() => _LoanDetailsBottomSheetState();
}

class _LoanDetailsBottomSheetState extends State<LoanDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HrProvider>(context, listen: false).loadMyLoanAuthDetails();
    });
  }

  String _formatDate(String? dateString, String locale) {
    if (dateString == null) return '';
    return DateFormat.yMd(locale).format(DateTime.parse(dateString));
  }

  String _formatCurrency(double? amount, String locale) {
    if (amount == null) return '0';
    final format = NumberFormat.currency(locale: locale, symbol: locale == 'ar_SA' ? 'ر.س' : '\$');
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hrProvider = Provider.of<HrProvider>(context);
    final isArabic = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode == 'ar';
    final loanType = hrProvider.getLoanTypeName(widget.request.loanType!, isArabic);

    return DraggableScrollableSheet(
      initialChildSize: 0.6, minChildSize: 0.4, maxChildSize: 0.9, expand: false,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 10),
              Text(l10n.requestDetails, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: [
                    _buildDetailsCard(loanType),
                    const SizedBox(height: 16),
                    _buildApprovalsSection(hrProvider),
                  ],
                ),
              ),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.close)))
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsCard(String loanType) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final locale = localeProvider.locale.toLanguageTag();
    final currencyLocale = localeProvider.locale.languageCode == 'ar' ? 'ar_SA' : 'en_US';
    final isArabic = localeProvider.locale.languageCode == 'ar';
    final description = isArabic ? widget.request.descA : (widget.request.descE ?? widget.request.descA);

    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.requestInfo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildDetailRow(l10n.loanTypeLabel, loanType),
            _buildDetailRow(l10n.repaymentDateLabel, _formatDate(widget.request.loanStartDate, locale)),
            _buildDetailRow(l10n.loanValueLabel, _formatCurrency(widget.request.loanValuePys, currencyLocale)),
            _buildDetailRow(l10n.installmentValueLabel, _formatCurrency(widget.request.loanInstlPys, currencyLocale)),
            _buildDetailRow(l10n.installmentsCountLabel, "${widget.request.loanNos ?? 0}"),
            if (description != null && description.isNotEmpty) _buildDetailRow(l10n.notesLabel, description),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalsSection(HrProvider hrProvider) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.approvals, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        hrProvider.isLoading
            ? const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 30))
            : hrProvider.myLoanAuthDetails?.items.isEmpty ?? true
            ? Center(child: Text(l10n.noRegisteredApprovals))
            : AuthTimeline(authItems: hrProvider.myLoanAuthDetails!.items),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }
}
