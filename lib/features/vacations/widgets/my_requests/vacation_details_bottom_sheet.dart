// features/vacations/widgets/my_requests/vacation_details_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../models/my_vacation_request_model.dart';
import '../../../approvals/widgets/auth_timeline_widget.dart'; // Assuming this widget is generic enough

class VacationDetailsBottomSheet extends StatefulWidget {
  final MyVacationRequestItem request;
  const VacationDetailsBottomSheet({super.key, required this.request});

  @override
  State<VacationDetailsBottomSheet> createState() => _VacationDetailsBottomSheetState();
}

class _VacationDetailsBottomSheetState extends State<VacationDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HrProvider>(context, listen: false).loadMyVacationAuthDetails();
    });
  }

  String _formatDate(String? dateString, String locale) {
    if (dateString == null) return '';
    return DateFormat.yMd(locale).format(DateTime.parse(dateString));
  }

  String _getVacationTypeName(BuildContext context, int? type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case 1:
        return l10n.vacationTypeRegular;
      case 12:
        return l10n.vacationTypeAnnual;
      case 2:
        return l10n.vacationTypeUnpaid;
      default: return l10n.notSpecified;
    }

  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hrProvider = Provider.of<HrProvider>(context);
    final vacationType = _getVacationTypeName(context, widget.request.trnsType);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
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
                    _buildDetailsCard(vacationType),
                    const SizedBox(height: 16),
                    _buildApprovalsSection(hrProvider),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.close),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsCard(String vacationType) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
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
            _buildDetailRow(l10n.vacationTypeLabel, vacationType),
            _buildDetailRow(l10n.fromDate, _formatDate(widget.request.startDt, locale)),
            _buildDetailRow(l10n.toDate, _formatDate(widget.request.endDt, locale)),
            _buildDetailRow(l10n.durationLabel, "${widget.request.period ?? 0} ${l10n.daysUnit}"),
            if (widget.request.notes != null && widget.request.notes!.isNotEmpty) _buildDetailRow(l10n.notesLabel, widget.request.notes!),
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
            : hrProvider.myVacationAuthDetails?.items.isEmpty ?? true
            ? Center(child: Text(l10n.noRegisteredApprovals))
            : AuthTimeline(authItems: hrProvider.myVacationAuthDetails!.items),
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
