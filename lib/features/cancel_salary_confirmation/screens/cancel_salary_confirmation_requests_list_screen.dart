// lib/features/cancel_salary_confirmation/screens/cancel_salary_confirmation_requests_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/hr_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../widgets/cancel_salary_confirmation_request_card.dart';
import 'cancel_salary_confirmation_request_details_screen.dart';


class CancelSalaryConfirmationRequestsListScreen extends StatefulWidget {
  static const String routeName = '/cancel-salary-confirmation-requests-list';
  const CancelSalaryConfirmationRequestsListScreen({super.key});

  @override
  State<CancelSalaryConfirmationRequestsListScreen> createState() => _CancelSalaryConfirmationRequestsListScreenState();
}

class _CancelSalaryConfirmationRequestsListScreenState extends State<CancelSalaryConfirmationRequestsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRequests());
  }

  Future<void> _loadRequests() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      await Provider.of<HrProvider>(context, listen: false)
          .fetchCancelSalaryConfirmationRequests(authProvider.currentUser!.usersCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cancelSalaryConfirmationInfo), // "طلبات إلغاء تثبيت راتب"
        actions: const [LanguageSwitcherButton()],
      ),
      body: Consumer<HrProvider>(
        builder: (context, hrProvider, child) {
          if (hrProvider.isLoading && hrProvider.cancelSalaryConfirmationRequests.isEmpty) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0));
          }

          if (hrProvider.error != null && hrProvider.cancelSalaryConfirmationRequests.isEmpty) {
            return Center(child: Text(hrProvider.error!));
          }

          if (hrProvider.cancelSalaryConfirmationRequests.isEmpty) {
            return Center(child: Text(l10n.noCancelSalaryConfirmationRequests)); // "لا توجد طلبات"
          }

          final requests = hrProvider.cancelSalaryConfirmationRequests;
          return RefreshIndicator(
            onRefresh: _loadRequests,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return CancelSalaryConfirmationRequestCard( // استخدام الكارد الجديد
                  request: request,
                  onTap: () async {
                    hrProvider.selectCancelSalaryConfirmationRequest(request); // استخدام الدالة الجديدة
                    final result = await Navigator.of(context).pushNamed(
                      CancelSalaryConfirmationRequestDetailsScreen.routeName, // الشاشة الجديدة
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