// lib/features/resume_work/widgets/my_requests/resume_work_details_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../models/my_resume_work_request_model.dart';
import '../../../approvals/widgets/auth_timeline_widget.dart'; // Re-use timeline

class ResumeWorkDetailsBottomSheet extends StatefulWidget {
  final MyResumeWorkRequestItem request;
  const ResumeWorkDetailsBottomSheet({super.key, required this.request});

  @override
  State<ResumeWorkDetailsBottomSheet> createState() => _ResumeWorkDetailsBottomSheetState();
}

class _ResumeWorkDetailsBottomSheetState extends State<ResumeWorkDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HrProvider>(context, listen: false).loadMyResumeWorkAuthDetails();
    });
  }

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
    final locale = Provider.of<LocaleProvider>(context).locale.toLanguageTag();
    final status = _getStatusText(context, widget.request.aproveFlag);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.resumeWorkRequestDetails, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppColors.getStatusColor(widget.request.aproveFlag).withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                    child: Text(status, style: TextStyle(color: AppColors.getStatusColor(widget.request.aproveFlag), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Divider(height: 24),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: [
                    _buildDetailsSection(l10n, locale),
                    const SizedBox(height: 20),
                    _buildApprovalsSection(context.watch<HrProvider>()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsSection(AppLocalizations l10n, String locale) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildDetailRow(l10n.vacationStartDate, _formatDate(widget.request.fDate, locale)),
            _buildDetailRow(l10n.vacationEndDate, _formatDate(widget.request.tDate, locale)),
            _buildDetailRow(l10n.resumeWorkDate, _formatDate(widget.request.actTDate, locale)),
            _buildDetailRow(l10n.durationLabel, "${widget.request.actPeriod ?? 0} ${l10n.daysUnit}"),
            if (widget.request.lateReason != null && widget.request.lateReason!.isNotEmpty)
              _buildDetailRow(l10n.delayReason, widget.request.lateReason!),
            if (widget.request.notes != null && widget.request.notes!.isNotEmpty)
              _buildDetailRow(l10n.notesLabel, widget.request.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalsSection(HrProvider hrProvider) {
    final l10n = AppLocalizations.of(context)!;
    final authDetails = hrProvider.myResumeWorkAuthDetails;
    final authItems = authDetails?.items ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.approvals, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        hrProvider.isLoading && authDetails == null
            ? const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 30))
            : authItems.isEmpty
            ? Center(child: Text(l10n.noRegisteredApprovals))
            : AuthTimeline(authItems: authItems),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}