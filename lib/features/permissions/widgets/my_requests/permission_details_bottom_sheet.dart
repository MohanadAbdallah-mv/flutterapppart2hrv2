// lib/features/permissions/widgets/my_requests/permission_details_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../models/my_permission_request_model.dart';
// ---== تأكد أن المسار ده صحيح ==---
import '../../../approvals/widgets/auth_timeline_widget.dart'; // Re-use timeline

class PermissionDetailsBottomSheet extends StatefulWidget {
  final MyPermissionRequestItem request;
  const PermissionDetailsBottomSheet({super.key, required this.request});

  @override
  State<PermissionDetailsBottomSheet> createState() => _PermissionDetailsBottomSheetState();
}

class _PermissionDetailsBottomSheetState extends State<PermissionDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HrProvider>(context, listen: false).loadMyPermissionAuthDetails();
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

  String _formatTime(String? timeString, String locale) {
    if (timeString == null) return '';
    try {
      return DateFormat.jm(locale).format(DateTime.parse(timeString));
    } catch (e) {
      return timeString;
    }
  }

  String _getPermissionTypeName(BuildContext context, int? type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case 1: return l10n.permissionType1;
      case 2: return l10n.permissionType2;
      case 3: return l10n.permissionType3;
      case 4: return l10n.permissionType4;
      default: return l10n.notSpecified;
    }
  }

  String _getReasonTypeName(BuildContext context, int? type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case 1: return l10n.reasonType1;
      case 2: return l10n.reasonType2;
      case 3: return l10n.reasonType3;
      default: return l10n.notSpecified;
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
    final permissionType = _getPermissionTypeName(context, widget.request.trnsType);
    final reasonType = _getReasonTypeName(context, widget.request.reasonType);

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
                  Text(l10n.permissionRequestDetails, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                    _buildDetailsSection(l10n, locale, permissionType, reasonType),
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

  Widget _buildDetailsSection(AppLocalizations l10n, String locale, String permissionType, String reasonType) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _buildDetailRow(l10n.permissionTypeLabel, permissionType),
            _buildDetailRow(l10n.reasonTypeLabel, reasonType),
            _buildDetailRow(l10n.requestDateLabel, _formatDate(widget.request.trnsDate, locale)),
            _buildDetailRow(l10n.permissionDateLabel, _formatDate(widget.request.prmDate, locale)),
            _buildDetailRow(l10n.fromTimeLabel, _formatTime(widget.request.fromTime, locale)),
            _buildDetailRow(l10n.toTimeLabel, _formatTime(widget.request.toTime, locale)),
            if (widget.request.permReasons != null && widget.request.permReasons!.isNotEmpty)
              _buildDetailRow(l10n.reasonsLabel, widget.request.permReasons!),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalsSection(HrProvider hrProvider) {
    final l10n = AppLocalizations.of(context)!;
    final authDetails = hrProvider.myPermissionAuthDetails;

    // ---== تم التصحيح: إزالة `AuthTimelineItem` ==---
    // هنبعت القائمة زي ما هي
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
            : AuthTimeline(authItems: authItems), // Re-use generic timeline
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