// lib/features/employee_transfer/screens/my_requests/my_employee_transfer_requests_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../widgets/my_requests/my_employee_transfer_request_card.dart';
import 'new_employee_transfer_request_screen.dart';
import '../../widgets/my_requests/employee_transfer_details_bottom_sheet.dart';

class MyEmployeeTransferRequestsListScreen extends StatefulWidget {
  static const String routeName = '/my-employee-transfer-requests';
  const MyEmployeeTransferRequestsListScreen({super.key});

  @override
  State<MyEmployeeTransferRequestsListScreen> createState() => _MyEmployeeTransferRequestsListScreenState();
}

class _MyEmployeeTransferRequestsListScreenState extends State<MyEmployeeTransferRequestsListScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRequests());
  }

  Future<void> _loadRequests() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      await Provider.of<HrProvider>(context, listen: false)
          .fetchMyEmployeeTransferRequests(authProvider.currentUser!.empCode);
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
          if (hrProvider.isLoading && hrProvider.myEmployeeTransferRequests.isEmpty) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0));
          }

          if (hrProvider.error != null && hrProvider.myEmployeeTransferRequests.isEmpty) {
            return Center(child: Text(hrProvider.error!));
          }

          if (hrProvider.myEmployeeTransferRequests.isEmpty) {
            return Center(child: Text(l10n.noEmployeeTransferRequests));
          }

          final requests = hrProvider.myEmployeeTransferRequests;
          return RefreshIndicator(
            onRefresh: _loadRequests,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return MyEmployeeTransferRequestCard( // الكارد الجديد
                  request: request,
                  onTap: () {
                    hrProvider.selectMyEmployeeTransferRequest(request); // الدالة الجديدة
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (_) => EmployeeTransferDetailsBottomSheet(request: request), // البوتوم شيت الجديد
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
          final result = await Navigator.of(context).pushNamed(NewEmployeeTransferRequestScreen.routeName); // شاشة الطلب الجديد
          if (result == true && mounted) {
            _loadRequests();
          }
        },
        label: Text(l10n.newEmployeeTransferRequest), // "طلب نقل جديد"
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.accentColor,
      ),
    );
  }
}