// lib/features/salary_confirmation/screens/my_requests/my_salary_confirmation_requests_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../widgets/my_requests/my_salary_confirmation_request_card.dart';
import 'new_salary_confirmation_request_screen.dart';
import '../../widgets/my_requests/salary_confirmation_details_bottom_sheet.dart';

class MySalaryConfirmationRequestsListScreen extends StatefulWidget {
  static const String routeName = '/my-salary-confirmation-requests';
  const MySalaryConfirmationRequestsListScreen({super.key});

  @override
  State<MySalaryConfirmationRequestsListScreen> createState() => _MySalaryConfirmationRequestsListScreenState();
}

class _MySalaryConfirmationRequestsListScreenState extends State<MySalaryConfirmationRequestsListScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRequests());
  }

  Future<void> _loadRequests() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      await Provider.of<HrProvider>(context, listen: false)
          .fetchMySalaryConfirmationRequests(authProvider.currentUser!.empCode);
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
          if (hrProvider.isLoading && hrProvider.mySalaryConfirmationRequests.isEmpty) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0));
          }

          if (hrProvider.error != null && hrProvider.mySalaryConfirmationRequests.isEmpty) {
            return Center(child: Text(hrProvider.error!));
          }

          if (hrProvider.mySalaryConfirmationRequests.isEmpty) {
            return Center(child: Text(l10n.noSalaryConfirmationRequests));
          }

          final requests = hrProvider.mySalaryConfirmationRequests;
          return RefreshIndicator(
            onRefresh: _loadRequests,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return MySalaryConfirmationRequestCard( // الكارد الجديد
                  request: request,
                  onTap: () {
                    hrProvider.selectMySalaryConfirmationRequest(request); // الدالة الجديدة
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (_) => SalaryConfirmationDetailsBottomSheet(request: request), // البوتوم شيت الجديد
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed(NewSalaryConfirmationRequestScreen.routeName); // شاشة الطلب الجديد
          if (result == true && mounted) {
            _loadRequests();
          }
        },
        label: Text(l10n.newSalaryConfirmationRequest), // "طلب تثبيت راتب جديد"
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.accentColor,
      ),
    );
  }
}