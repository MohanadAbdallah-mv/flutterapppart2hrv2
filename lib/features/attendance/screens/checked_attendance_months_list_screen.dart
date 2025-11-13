// features/attendance/screens/checked_attendance_months_list_screen.dart
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
import 'checked_attendance_details_screen.dart';


class CheckedAttendanceMonthsListScreen extends StatefulWidget {
  static const String routeName = '/checked-attendance-months';
  const CheckedAttendanceMonthsListScreen({super.key});

  @override
  State<CheckedAttendanceMonthsListScreen> createState() => _CheckedAttendanceMonthsListScreenState();
}

class _CheckedAttendanceMonthsListScreenState extends State<CheckedAttendanceMonthsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
      if (user != null) {
        Provider.of<AttendanceProvider>(context, listen: false).fetchCheckedAttendanceMonths(789);
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
        title: Text(l10n.checkedAttendanceLogTitle),
        actions: const [
          LanguageSwitcherButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Consumer<AttendanceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingCheckedMonths) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor));
          }
          if (provider.checkedMonthsError != null) {
            return Center(child: Text(provider.checkedMonthsError!));
          }
          if (provider.checkedMonths.isEmpty) {
            return Center(child: Text(l10n.noCheckedLogAvailable));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: provider.checkedMonths.length,
            separatorBuilder: (context, index) => const SizedBox(height: 5),
            itemBuilder: (context, index) {
              final month = provider.checkedMonths[index];
              final monthTitle = _formatYearMonth(month.yearMonth, locale);
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.verified_user_outlined, color: AppColors.primaryColor),
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
                          builder: (_) => CheckedAttendanceDetailsScreen(
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
