// features/attendance/screens/checked_attendance_details_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../models/checked_attendance_detail_model.dart';
import '../providers/attendance_provider.dart';


class CheckedAttendanceDetailsScreen extends StatefulWidget {
  final String monthUrl;
  final String monthTitle;

  const CheckedAttendanceDetailsScreen({
    super.key,
    required this.monthUrl,
    required this.monthTitle,
  });

  @override
  State<CheckedAttendanceDetailsScreen> createState() => _CheckedAttendanceDetailsScreenState();
}

class _CheckedAttendanceDetailsScreenState extends State<CheckedAttendanceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceProvider>(context, listen: false).fetchCheckedMonthDetails(widget.monthUrl);
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
          if (provider.isLoadingCheckedDetails) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor));
          }
          if (provider.checkedDetailsError != null) {
            return Center(child: Text(provider.checkedDetailsError!));
          }
          if (provider.checkedDetails.isEmpty) {
            return Center(child: Text(l10n.noDetailsForThisSheet));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DataTable(
                  columnSpacing: 25.0,
                  headingRowColor: MaterialStateProperty.all(AppColors.primaryColor.withOpacity(0.1)),
                  border: TableBorder.all(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  columns: [
                    DataColumn(label: Text(l10n.date, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text(l10n.day, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text(l10n.entry, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text(l10n.exit, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text(l10n.delayInMinutes, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text(l10n.status, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text(l10n.weekend, style: const TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: provider.checkedDetails.map((day) => _buildDataRow(day)).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  DataRow _buildDataRow(CheckedAttendanceDetailItem day) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale.toLanguageTag();
    final isArabic = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode == 'ar';

    final bool isWeekend = day.weekendFlag == 1;
    final bool isAbsence = day.abscFlag == 1;
    final bool isVacation = day.vcncFlag == 1;
    final bool isSpecialDay = isWeekend || isAbsence || isVacation;

    final Color rowColor = isSpecialDay ? Colors.blue.shade100.withOpacity(0.4) : Colors.transparent;

    String formatTime(DateTime? dt) {
      if (dt == null) return '-';
      return DateFormat.jm(locale).format(dt);
    }

    Widget buildStatusWidget() {
      if (isAbsence) {
        return Text(l10n.absence, style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold));
      }
      if (isVacation) {
        return Text(l10n.vacation, style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold));
      }
      return const Text('-');
    }

    final dayName = isArabic ? day.taDay : day.taDay;

    return DataRow(
      color: MaterialStateProperty.all(rowColor),
      cells: [
        DataCell(Text(day.taDate != null ? DateFormat('MM/dd').format(day.taDate!) : '-')),
        DataCell(Text(dayName ?? '-')),
        DataCell(Text(formatTime(day.revIn), style: const TextStyle(color: AppColors.successColor, fontWeight: FontWeight.w600))),
        DataCell(Text(formatTime(day.revOut), style: const TextStyle(color: AppColors.errorColor, fontWeight: FontWeight.w600))),
        DataCell(Text(isSpecialDay ? '-' : day.taLateMins.toString())),
        DataCell(buildStatusWidget()),
        DataCell(
          isWeekend
              ? const Center(child: Icon(Icons.check_circle, color: Colors.green, size: 20))
              : const Center(child: Text('-')),
        ),
      ],
    );
  }
}
