// features/attendance/screens/attendance_daily_log_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/attendance_provider.dart';
import '../widgets/daily_log_card.dart';


class AttendanceDailyLogScreen extends StatefulWidget {
  static const String routeName = '/attendance-daily-log';
  final String monthUrl;
  final String monthTitle;

  const AttendanceDailyLogScreen({
    super.key,
    required this.monthUrl,
    required this.monthTitle,
  });

  @override
  State<AttendanceDailyLogScreen> createState() => _AttendanceDailyLogScreenState();
}

class _AttendanceDailyLogScreenState extends State<AttendanceDailyLogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceProvider>(context, listen: false).fetchMonthDetails(widget.monthUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.monthTitle),
        actions: const [
          LanguageSwitcherButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingDetails) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor));
          }
          if (provider.detailsError != null) {
            return Center(child: Text(provider.detailsError!));
          }
          if (provider.groupedDetails.isEmpty) {
            return Center(child: Text(l10n.noDataForThisMonth));
          }

          final sortedDays = provider.groupedDetails.keys.toList()..sort();

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: sortedDays.length,
            itemBuilder: (context, index) {
              final dayKey = sortedDays[index];
              final dayEvents = provider.groupedDetails[dayKey]!;
              return DailyLogCard(dayKey: dayKey, events: dayEvents);
            },
          );
        },
      ),
    );
  }
}
