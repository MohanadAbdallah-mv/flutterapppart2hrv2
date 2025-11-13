// lib/features/attendance/screens/attendance_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/attendance/providers/attendance_provider.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';

import '../../../core/utils/app_colors.dart';
import 'check_in_out_map_screen.dart';
import 'attendance_months_list_screen.dart';
import 'checked_attendance_months_list_screen.dart';


class AttendanceMainScreen extends StatefulWidget {
  static const String routeName = '/attendance-main';
  const AttendanceMainScreen({super.key});

  @override
  State<AttendanceMainScreen> createState() => _AttendanceMainScreenState();
}

class _AttendanceMainScreenState extends State<AttendanceMainScreen> {

  void _loadData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if(authProvider.currentUser != null){
      Provider.of<AttendanceProvider>(context, listen: false)
          .fetchCheckedAttendanceMonths(789);
      Provider.of<AttendanceProvider>(context, listen: false)
          .fetchAttendanceMonths(789);
    }
  }

  Future<void> _showCheckInOutDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: Text(l10n.newRecordDialogTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildDialogOption(
                context: context,
                icon: Icons.login,
                text: l10n.checkIn,
                color: AppColors.successColor,
                onTap: () => Navigator.of(context).pop('I'),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              _buildDialogOption(
                context: context,
                icon: Icons.logout,
                text: l10n.checkOut,
                color: AppColors.errorColor,
                onTap: () => Navigator.of(context).pop('O'),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      final refresh = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => CheckInOutMapScreen(checkType: result),
        ),
      );

      if (refresh == true) {
        _loadData();
      }
    }
  }

  Widget _buildDialogOption({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 15),
            Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.attendanceAndDeparture),
        backgroundColor: AppColors.primaryColor,
        actions: const [
          LanguageSwitcherButton(),
          SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCheckInOutDialog,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: Text(l10n.newRecord),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildServiceCard(
              context,
              icon: Icons.history_edu_outlined,
              title: l10n.attendanceLog,
              subtitle: l10n.viewMonthlyLog,
              onTap: () {
                Navigator.of(context).pushNamed(AttendanceMonthsListScreen.routeName);
              },
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              context,
              icon: Icons.checklist_rtl_outlined,
              title: l10n.checkedAttendance,
              subtitle: l10n.viewCheckedLog,
              onTap: () {
                Navigator.of(context).pushNamed(CheckedAttendanceMonthsListScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: AppColors.primaryColor),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
