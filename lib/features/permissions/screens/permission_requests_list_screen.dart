// lib/features/permissions/screens/permission_requests_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/hr_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../widgets/permission_request_card.dart';
import 'permission_request_details_screen.dart';


class PermissionRequestsListScreen extends StatefulWidget {
  static const String routeName = '/permission-requests-list';
  const PermissionRequestsListScreen({super.key});

  @override
  State<PermissionRequestsListScreen> createState() => _PermissionRequestsListScreenState();
}

class _PermissionRequestsListScreenState extends State<PermissionRequestsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRequests());
  }

  Future<void> _loadRequests() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      await Provider.of<HrProvider>(context, listen: false)
          .fetchPermissionRequests(authProvider.currentUser!.usersCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.permissionInfo),
        actions: const [LanguageSwitcherButton()],
      ),
      body: Consumer<HrProvider>(
        builder: (context, hrProvider, child) {
          if (hrProvider.isLoading && hrProvider.permissionRequests.isEmpty) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0));
          }

          if (hrProvider.error != null && hrProvider.permissionRequests.isEmpty) {
            return Center(child: Text(hrProvider.error!));
          }

          if (hrProvider.permissionRequests.isEmpty) {
            return Center(child: Text(l10n.noPermissionRequests));
          }

          final requests = hrProvider.permissionRequests;
          return RefreshIndicator(
            onRefresh: _loadRequests,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return PermissionRequestCard(
                  request: request,
                  onTap: () async {
                    hrProvider.selectPermissionRequest(request);
                    final result = await Navigator.of(context).pushNamed(
                      PermissionRequestDetailsScreen.routeName,
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