// lib/features/employee_transfer/screens/employee_transfer_requests_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/hr_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../widgets/employee_transfer_request_card.dart';
import 'employee_transfer_request_details_screen.dart';


class EmployeeTransferRequestsListScreen extends StatefulWidget {
  static const String routeName = '/employee-transfer-requests-list';
  const EmployeeTransferRequestsListScreen({super.key});

  @override
  State<EmployeeTransferRequestsListScreen> createState() => _EmployeeTransferRequestsListScreenState();
}

class _EmployeeTransferRequestsListScreenState extends State<EmployeeTransferRequestsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRequests());
  }

  Future<void> _loadRequests() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      await Provider.of<HrProvider>(context, listen: false)
          .fetchEmployeeTransferRequests(authProvider.currentUser!.usersCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.employeeTransferInfo), // "طلبات نقل موظف"
        actions: const [LanguageSwitcherButton()],
      ),
      body: Consumer<HrProvider>(
        builder: (context, hrProvider, child) {
          if (hrProvider.isLoading && hrProvider.employeeTransferRequests.isEmpty) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0));
          }

          if (hrProvider.error != null && hrProvider.employeeTransferRequests.isEmpty) {
            return Center(child: Text(hrProvider.error!));
          }

          if (hrProvider.employeeTransferRequests.isEmpty) {
            return Center(child: Text(l10n.noEmployeeTransferRequests)); // "لا توجد طلبات"
          }

          final requests = hrProvider.employeeTransferRequests;
          return RefreshIndicator(
            onRefresh: _loadRequests,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return EmployeeTransferRequestCard( // استخدام الكارد الجديد
                  request: request,
                  onTap: () async {
                    hrProvider.selectEmployeeTransferRequest(request); // استخدام الدالة الجديدة
                    final result = await Navigator.of(context).pushNamed(
                      EmployeeTransferRequestDetailsScreen.routeName, // الشاشة الجديدة
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