// lib/features/purchases/widgets/purchase_order_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/models/purchase_order_model.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/utils/app_colors.dart';

class PurchaseOrderCard extends StatelessWidget {
  final PurchaseOrderItem order;
  final VoidCallback onTap;

  const PurchaseOrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  // تم تعديل الدالة لتقبل اللغة وتنسيق التاريخ بناءً عليها
  String _formatDate(String? dateString, String locale) {
    if (dateString == null || dateString.isEmpty) return '...';
    try {
      // تم استخدام DateFormat.yMd لتحسين التوافق مع اللغات المختلفة
      final DateTime dateTime = DateTime.parse(dateString);
      return DateFormat.yMd(locale).format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    // -- منطق اختيار النص بناءً على اللغة --
    // استخدام القاعدة: key للغة العربية و keyE للإنجليزية
    final String subject = isArabic ? (order.poSubject ?? '') : (order.poSubjectE ?? order.poSubject ?? '');
    final String supplier = isArabic ? (order.supplierName ?? '') : (order.supplierNameE ?? order.supplierName ?? '');

    // -- منطق تحديد حالة الطلب ولونها --
    final String statusKey = order.poStatusDesc ?? l10n.underAction;
    String statusText;
    Color statusColor;

    if (statusKey.contains('معتمد') || statusKey.toLowerCase().contains('approved')) {
      statusText = l10n.approved;
      statusColor = AppColors.successColor;
    } else if (statusKey.contains('مرفوض') || statusKey.toLowerCase().contains('rejected')) {
      statusText = l10n.rejected;
      statusColor = AppColors.errorColor;
    } else {
      statusText = l10n.underAction;
      statusColor = AppColors.hintColor;
    }

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              Text(
                subject.isEmpty ? l10n.notSpecified : subject,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                context,
                icon: Icons.business_center_outlined,
                label: "${l10n.supplierName}:",
                value: supplier.isEmpty ? l10n.notSpecified : supplier,
              ),
              _buildInfoRow(
                context,
                icon: Icons.confirmation_number_outlined,
                label: "${l10n.orderNumber}:",
                value: order.altKey,
              ),
              _buildInfoRow(
                context,
                icon: Icons.calendar_today_outlined,
                label: "${l10n.orderDate}:",
                value: _formatDate(order.prOrderDate, localeProvider.locale.toLanguageTag()),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(color: statusColor, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textColor.withOpacity(0.6), size: 20),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textColor, fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: AppColors.textColor.withOpacity(0.8)),
            ),
          ),
        ],
      ),
    );
  }
}