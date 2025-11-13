// features/vacations/screens/my_requests/my_vacation_requests_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../widgets/my_requests/my_vacation_request_card.dart';
import 'new_vacation_request_screen.dart';
import '../../widgets/my_requests/vacation_details_bottom_sheet.dart';


class MyVacationRequestsListScreen extends StatefulWidget {
  static const String routeName = '/my-vacation-requests';
  const MyVacationRequestsListScreen({super.key});

  @override
  State<MyVacationRequestsListScreen> createState() => _MyVacationRequestsListScreenState();
}

class _MyVacationRequestsListScreenState extends State<MyVacationRequestsListScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRequests());
  }

  Future<void> _loadRequests() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      await Provider.of<HrProvider>(context, listen: false)
          .loadMyVacationRequests(authProvider.currentUser!.empCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myVacationRequestsTitle),
        backgroundColor: AppColors.primaryColor,
        actions: const [
          LanguageSwitcherButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Consumer<HrProvider>(
        builder: (context, hrProvider, child) {
          if (hrProvider.isLoading && hrProvider.myVacationRequests.isEmpty) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0));
          }
          if (hrProvider.error != null && hrProvider.myVacationRequests.isEmpty) {
            return Center(child: Text(hrProvider.error!));
          }

          if (hrProvider.myVacationRequests.isEmpty) {
            return Center(child: Text(l10n.noVacationRequests));
          }

          final requests = hrProvider.myVacationRequests;
          return RefreshIndicator(
            onRefresh: _loadRequests,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 80), // Keep space for FAB
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return MyVacationRequestCard(
                  request: request,
                  onTap: () {
                    hrProvider.selectMyVacationRequest(request);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (_) => VacationDetailsBottomSheet(request: request),
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
          final result = await Navigator.of(context).pushNamed(NewVacationRequestScreen.routeName);
          if (result == true && mounted) {
            _loadRequests();
          }
        },
        label: Text(l10n.newRequest),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.accentColor,
      ),
    );
  }
}
