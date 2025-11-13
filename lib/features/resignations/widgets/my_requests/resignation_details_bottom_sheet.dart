// features/resignations/widgets/my_requests/resignation_details_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../models/my_resignation_request_model.dart';
import '../../../approvals/widgets/auth_timeline_widget.dart';

class ResignationDetailsBottomSheet extends StatefulWidget {
  final MyResignationRequestItem request;
  const ResignationDetailsBottomSheet({super.key, required this.request});

  @override
  State<ResignationDetailsBottomSheet> createState() => _ResignationDetailsBottomSheetState();
}

class _ResignationDetailsBottomSheetState extends State<ResignationDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HrProvider>(context, listen: false).loadMyResignationAuthDetails();
    });
  }

  String _formatDate(String? dateString, String locale) {
    if (dateString == null) return '';
    return DateFormat.yMd(locale).format(DateTime.parse(dateString));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hrProvider = Provider.of<HrProvider>(context);

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
                    _buildDetailsCard(),
                    const SizedBox(height: 16),
                    Text(l10n.approvals, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    hrProvider.isLoading
                        ? const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 30))
                        : hrProvider.myResignationAuthDetails?.items.isEmpty ?? true
                        ? Center(child: Text(l10n.noRegisteredApprovals))
                        : AuthTimeline(authItems: hrProvider.myResignationAuthDetails!.items),
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

  Widget _buildDetailsCard() {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    final isArabic = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode == 'ar';
    final reasons = isArabic ? widget.request.endReasons : (widget.request.endReasons ?? widget.request.endReasons);

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
            _buildDetailRow(l10n.requestDateLabel, _formatDate(widget.request.trnsDate, locale)),
            _buildDetailRow(l10n.resignationDateLabel, _formatDate(widget.request.endDate, locale)),
            _buildDetailRow(l10n.lastWorkDayLabel, _formatDate(widget.request.lastWorkDt, locale)),
            if (reasons != null && reasons.isNotEmpty) _buildDetailRow(l10n.reasonsLabel, reasons),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}