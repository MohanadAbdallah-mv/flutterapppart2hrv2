// lib/features/cancel_salary_confirmation/screens/my_requests/my_cancel_salary_confirmation_requests_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../widgets/my_requests/my_cancel_salary_confirmation_request_card.dart';
import 'new_cancel_salary_confirmation_request_screen.dart';
import '../../widgets/my_requests/cancel_salary_confirmation_details_bottom_sheet.dart';

class MyCancelSalaryConfirmationRequestsListScreen extends StatefulWidget {
  static const String routeName = '/my-cancel-salary-confirmation-requests';
  const MyCancelSalaryConfirmationRequestsListScreen({super.key});

  @override
  State<MyCancelSalaryConfirmationRequestsListScreen> createState() => _MyCancelSalaryConfirmationRequestsListScreenState();
}

class _MyCancelSalaryConfirmationRequestsListScreenState extends State<MyCancelSalaryConfirmationRequestsListScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRequests());
  }

  Future<void> _loadRequests() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      await Provider.of<HrProvider>(context, listen: false)
          .fetchMyCancelSalaryConfirmationRequests(authProvider.currentUser!.empCode);
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
          if (hrProvider.isLoading && hrProvider.myCancelSalaryConfirmationRequests.isEmpty) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0));
          }

          if (hrProvider.error != null && hrProvider.myCancelSalaryConfirmationRequests.isEmpty) {
            return Center(child: Text(hrProvider.error!));
          }

          if (hrProvider.myCancelSalaryConfirmationRequests.isEmpty) {
            return Center(child: Text(l10n.noCancelSalaryConfirmationRequests));
          }

          final requests = hrProvider.myCancelSalaryConfirmationRequests;
          return RefreshIndicator(
            onRefresh: _loadRequests,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return MyCancelSalaryConfirmationRequestCard( // الكارد الجديد
                  request: request,
                  onTap: () {
                    hrProvider.selectMyCancelSalaryConfirmationRequest(request); // الدالة الجديدة
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (_) => CancelSalaryConfirmationDetailsBottomSheet(request: request), // البوتوم شيت الجديد
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
          final result = await Navigator.of(context).pushNamed(NewCancelSalaryConfirmationRequestScreen.routeName); // الشاشة الجديدة
          if (result == true && mounted) {
            _loadRequests();
          }
        },
        label: Text(l10n.newCancelSalaryConfirmationRequest), // "طلب إلغاء تثبيت راتب جديد"
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.accentColor,
      ),
    );
  }
}