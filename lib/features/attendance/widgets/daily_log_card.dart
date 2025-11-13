// features/attendance/widgets/daily_log_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../models/attendance_detail_model.dart';

class DailyLogCard extends StatelessWidget {
  final String dayKey;
  final List<AttendanceDetailItem> events;

  const DailyLogCard({super.key, required this.dayKey, required this.events});

  String _formatDay(String dayKey, String locale) {
    try {
      final date = DateTime.parse(dayKey);
      return DateFormat.yMMMMEEEEd(locale).format(date);
    } catch (e) {
      return dayKey;
    }
  }

  String _formatTime(DateTime? dateTime, String locale) {
    if (dateTime == null) return '--:--';
    return DateFormat.jm(locale).format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDay(dayKey, locale),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            if (events.isEmpty)
              Text(l10n.noRecordsForThisDay)
            else
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: events.length,
                separatorBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Divider(indent: 40, endIndent: 40, height: 1),
                ),
                itemBuilder: (context, index) {
                  final event = events[index];
                  bool isCheckIn = event.attType == 'I';
                  return Row(
                    children: [
                      Icon(
                        isCheckIn ? Icons.login_outlined : Icons.logout_outlined,
                        color: isCheckIn ? Colors.green.shade600 : Colors.red.shade600,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isCheckIn ? l10n.checkInLabel : l10n.checkOutLabel,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(event.attDate, locale),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
