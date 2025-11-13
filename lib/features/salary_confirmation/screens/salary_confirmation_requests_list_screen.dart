// lib/features/salary_confirmation/screens/salary_confirmation_requests_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/hr_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../widgets/salary_confirmation_request_card.dart';
import 'salary_confirmation_request_details_screen.dart';


class SalaryConfirmationRequestsListScreen extends StatefulWidget {
  static const String routeName = '/salary-confirmation-requests-list';
  const SalaryConfirmationRequestsListScreen({super.key});

  @override
  State<SalaryConfirmationRequestsListScreen> createState() => _SalaryConfirmationRequestsListScreenState();
}

class _SalaryConfirmationRequestsListScreenState extends State<SalaryConfirmationRequestsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRequests());
  }

  Future<void> _loadRequests() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      await Provider.of<HrProvider>(context, listen: false)
          .fetchSalaryConfirmationRequests(authProvider.currentUser!.usersCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.salaryConfirmationInfo), // "طلبات تثبيت راتب"
        actions: const [LanguageSwitcherButton()],
      ),
      body: Consumer<HrProvider>(
        builder: (context, hrProvider, child) {
          if (hrProvider.isLoading && hrProvider.salaryConfirmationRequests.isEmpty) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0));
          }

          if (hrProvider.error != null && hrProvider.salaryConfirmationRequests.isEmpty) {
            return Center(child: Text(hrProvider.error!));
          }

          if (hrProvider.salaryConfirmationRequests.isEmpty) {
            return Center(child: Text(l10n.noSalaryConfirmationRequests)); // "لا توجد طلبات"
          }

          final requests = hrProvider.salaryConfirmationRequests;
          return RefreshIndicator(
            onRefresh: _loadRequests,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return SalaryConfirmationRequestCard( // استخدام الكارد الجديد
                  request: request,
                  onTap: () async {
                    hrProvider.selectSalaryConfirmationRequest(request); // استخدام الدالة الجديدة
                    final result = await Navigator.of(context).pushNamed(
                      SalaryConfirmationRequestDetailsScreen.routeName, // الشاشة الجديدة
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