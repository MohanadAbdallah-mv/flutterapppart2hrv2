// lib/features/loans/screens/loan_requests_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/hr_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../widgets/loan_request_card.dart';
import 'loan_request_details_screen.dart';


class LoanRequestsListScreen extends StatefulWidget {
  static const String routeName = '/loan-requests-list';
  const LoanRequestsListScreen({super.key});

  @override
  State<LoanRequestsListScreen> createState() => _LoanRequestsListScreenState();
}

class _LoanRequestsListScreenState extends State<LoanRequestsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRequests());
  }

  Future<void> _loadRequests() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      await Provider.of<HrProvider>(context, listen: false)
          .loadLoanRequests(authProvider.currentUser!.usersCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.loanRequestsTitle),
        backgroundColor: AppColors.primaryColor,
        actions: const [
          LanguageSwitcherButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Consumer<HrProvider>(
        builder: (context, hrProvider, child) {
          if (hrProvider.isLoading && hrProvider.loanRequests.isEmpty) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0));
          }
          if (hrProvider.error != null && hrProvider.loanRequests.isEmpty) {
            return Center(child: Text(hrProvider.error!));
          }
          if (hrProvider.loanRequests.isEmpty) {
            return Center(child: Text(l10n.noLoanRequests));
          }

          final requests = hrProvider.loanRequests;
          return RefreshIndicator(
            onRefresh: _loadRequests,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return LoanRequestCard(
                  request: request,
                  onTap: () async {
                    hrProvider.selectLoanRequest(request);
                    final result = await Navigator.of(context).pushNamed(
                      LoanRequestDetailsScreen.routeName,
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
