// lib/features/resume_work/screens/resume_work_requests_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/hr_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../widgets/resume_work_request_card.dart';
import 'resume_work_request_details_screen.dart';


class ResumeWorkRequestsListScreen extends StatefulWidget {
  static const String routeName = '/resume-work-requests-list';
  const ResumeWorkRequestsListScreen({super.key});

  @override
  State<ResumeWorkRequestsListScreen> createState() => _ResumeWorkRequestsListScreenState();
}

class _ResumeWorkRequestsListScreenState extends State<ResumeWorkRequestsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRequests());
  }

  Future<void> _loadRequests() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      await Provider.of<HrProvider>(context, listen: false)
          .fetchResumeWorkRequests(authProvider.currentUser!.usersCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resumeWorkInfo), // "طلبات مباشرة العمل"
        actions: const [LanguageSwitcherButton()],
      ),
      body: Consumer<HrProvider>(
        builder: (context, hrProvider, child) {
          if (hrProvider.isLoading && hrProvider.resumeWorkRequests.isEmpty) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0));
          }

          if (hrProvider.error != null && hrProvider.resumeWorkRequests.isEmpty) {
            return Center(child: Text(hrProvider.error!));
          }

          if (hrProvider.resumeWorkRequests.isEmpty) {
            return Center(child: Text(l10n.noResumeWorkRequests)); // "لا توجد طلبات"
          }

          final requests = hrProvider.resumeWorkRequests;
          return RefreshIndicator(
            onRefresh: _loadRequests,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return ResumeWorkRequestCard( // استخدام الكارد الجديد
                  request: request,
                  onTap: () async {
                    hrProvider.selectResumeWorkRequest(request); // استخدام الدالة الجديدة
                    final result = await Navigator.of(context).pushNamed(
                      ResumeWorkRequestDetailsScreen.routeName, // الشاشة الجديدة
                    );
                    if (result == true && mounted) {
                      _loadRequests();
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}