// lib/features/car_movement/screens/car_movement_requests_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/hr_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../widgets/car_movement_request_card.dart';
import 'car_movement_request_details_screen.dart';


class CarMovementRequestsListScreen extends StatefulWidget {
  static const String routeName = '/car-movement-requests-list';
  const CarMovementRequestsListScreen({super.key});

  @override
  State<CarMovementRequestsListScreen> createState() => _CarMovementRequestsListScreenState();
}

class _CarMovementRequestsListScreenState extends State<CarMovementRequestsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRequests());
  }

  Future<void> _loadRequests() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      await Provider.of<HrProvider>(context, listen: false)
          .fetchCarMovementRequests(authProvider.currentUser!.usersCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.carMovementInfo), // "طلبات تحريك سيارة"
        actions: const [LanguageSwitcherButton()],
      ),
      body: Consumer<HrProvider>(
        builder: (context, hrProvider, child) {
          if (hrProvider.isLoading && hrProvider.carMovementRequests.isEmpty) {
            return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0));
          }

          if (hrProvider.error != null && hrProvider.carMovementRequests.isEmpty) {
            return Center(child: Text(hrProvider.error!));
          }

          if (hrProvider.carMovementRequests.isEmpty) {
            return Center(child: Text(l10n.noCarMovementRequests)); // "لا توجد طلبات"
          }

          final requests = hrProvider.carMovementRequests;
          return RefreshIndicator(
            onRefresh: _loadRequests,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return CarMovementRequestCard( // استخدام الكارد الجديد
                  request: request,
                  onTap: () async {
                    hrProvider.selectCarMovementRequest(request); // استخدام الدالة الجديدة
                    final result = await Navigator.of(context).pushNamed(
                      CarMovementRequestDetailsScreen.routeName, // الشاشة الجديدة
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