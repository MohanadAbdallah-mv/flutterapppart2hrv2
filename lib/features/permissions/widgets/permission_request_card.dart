// lib/features/permissions/widgets/permission_request_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../models/permission_request_model.dart';

class PermissionRequestCard extends StatelessWidget {
  final PermissionRequestItem request;
  final VoidCallback onTap;

  const PermissionRequestCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  String _formatDate(String? dateString, String locale) {
    if (dateString == null || dateString.isEmpty) return '...';
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      return DateFormat.yMd(locale).format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  String _formatTime(String? timeString, String locale) {
    if (timeString == null || timeString.isEmpty) return '...';
    try {
      final DateTime dateTime = DateTime.parse(timeString);
      return DateFormat.jm(locale).format(dateTime);
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final locale = localeProvider.locale.toLanguageTag();
    final isArabic = localeProvider.locale.languageCode == 'ar';

    final empName = isArabic ? request.empName : (request.empNameE ?? request.empName);
    final permissionType = _getPermissionTypeName(context, request.trnsType);

    // Status (AproveFlag: 0=Pending)
    final statusText = l10n.underAction;
    final statusColor = AppColors.getStatusColor(request.aproveFlag);


    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      elevation: 3.0,
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
                      empName ?? l10n.notSpecified,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      statusText,
                      style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.category_outlined, l10n.permissionTypeLabel, permissionType),
              _buildInfoRow(Icons.calendar_today_outlined, l10n.permissionDateLabel, _formatDate(request.prmDate, locale)),
              _buildInfoRow(Icons.access_time_outlined, l10n.permissionTimeLabel, '${_formatTime(request.fromTime, locale)} - ${_formatTime(request.toTime, locale)}'),
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
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 14, color: AppColors.textColor), overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}