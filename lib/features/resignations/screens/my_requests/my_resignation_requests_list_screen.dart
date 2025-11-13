// features/resignations/screens/my_requests/my_resignation_requests_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/hr_provider.dart';
import '../../../../core/utils/app_colors.dart';
import '../../widgets/my_requests/my_resignation_request_card.dart';
import 'new_resignation_request_screen.dart';
import '../../widgets/my_requests/resignation_details_bottom_sheet.dart';


class MyResignationRequestsListScreen extends StatefulWidget {
  static const String routeName = '/my-resignation-requests';
  const MyResignationRequestsListScreen({super.key});

  @override
  State<MyResignationRequestsListScreen> createState() => _MyResignationRequestsListScreenState();
}

class _MyResignationRequestsListScreenState extends State<MyResignationRequestsListScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRequests());
  }

  Future<void> _loadRequests() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      await Provider.of<HrProvider>(context, listen: false)
          .loadMyResignationRequests(authProvider.currentUser!.empCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myResignationRequestsTitle),
        backgroundColor: AppColors.primaryColor,
        actions: const [
          LanguageSwitcherButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Consumer<HrProvider>(
        builder: (context, hrProvider, child) {
          if (hrProvider.isLoading && hrProvider.myResignationRequests.isEmpty) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0));
          }
          if (hrProvider.error != null && hrProvider.myResignationRequests.isEmpty) {
            return Center(child: Text(hrProvider.error!));
          }
          if (hrProvider.myResignationRequests.isEmpty) {
            return Center(child: Text(l10n.noResignationRequests));
          }

          final requests = hrProvider.myResignationRequests;
          return RefreshIndicator(
            onRefresh: _loadRequests,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return MyResignationRequestCard(
                  request: request,
                  onTap: () {
                    hrProvider.selectMyResignationRequest(request);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (_) => ResignationDetailsBottomSheet(request: request),
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
          final result = await Navigator.of(context).pushNamed(NewResignationRequestScreen.routeName);
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
