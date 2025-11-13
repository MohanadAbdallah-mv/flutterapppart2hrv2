// lib/features/permissions/widgets/my_requests/my_permission_request_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../models/my_permission_request_model.dart';

class MyPermissionRequestCard extends StatelessWidget {
  final MyPermissionRequestItem request;
  final VoidCallback onTap;

  const MyPermissionRequestCard({super.key, required this.request, required this.onTap});

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
    final permissionType = _getPermissionTypeName(context, request.trnsType);
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
                      permissionType,
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
              _buildInfoRow(Icons.calendar_today_outlined, l10n.permissionDateLabel, _formatDate(request.prmDate, locale)),
              _buildInfoRow(Icons.access_time_outlined, l10n.permissionTimeLabel, '${_formatTime(request.fromTime, locale)} - ${_formatTime(request.toTime, locale)}'),
              if (request.permReasons != null && request.permReasons!.isNotEmpty)
                _buildInfoRow(Icons.notes_outlined, l10n.reasonsLabel, request.permReasons!),
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