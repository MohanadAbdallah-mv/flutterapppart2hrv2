// features/attendance/screens/attendance_months_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../providers/attendance_provider.dart';
import 'attendance_daily_log_screen.dart';


class AttendanceMonthsListScreen extends StatefulWidget {
  static const String routeName = '/attendance-months';
  const AttendanceMonthsListScreen({super.key});

  @override
  State<AttendanceMonthsListScreen> createState() => _AttendanceMonthsListScreenState();
}

class _AttendanceMonthsListScreenState extends State<AttendanceMonthsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
      if (user != null) {
        Provider.of<AttendanceProvider>(context, listen: false).fetchAttendanceMonths(789);
      }
    });
  }

  String _formatYearMonth(String yearMonth, String locale) {
    try {
      final date = DateFormat('yyyy-MM').parse(yearMonth);
      return DateFormat.yMMMM(locale).format(date);
    } catch (e) {
      return yearMonth;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.attendanceLogTitle),
        actions: const [
          LanguageSwitcherButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingMonths) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor));
          }
          if (provider.monthsError != null) {
            return Center(child: Text(provider.monthsError!));
          }
          if (provider.months.isEmpty) {
            return Center(child: Text(l10n.noAttendanceLogAvailable));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: provider.months.length,
            separatorBuilder: (context, index) => const SizedBox(height: 5),
            itemBuilder: (context, index) {
              final month = provider.months[index];
              final monthTitle = _formatYearMonth(month.yearMonth, locale);
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.calendar_month_outlined, color: AppColors.primaryColor),
                  title: Text(
                    monthTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    final detailUrl = month.getDetailLink();
                    if (detailUrl != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AttendanceDailyLogScreen(
                            monthUrl: detailUrl,
                            monthTitle: monthTitle,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.detailsLinkNotAvailable)),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
