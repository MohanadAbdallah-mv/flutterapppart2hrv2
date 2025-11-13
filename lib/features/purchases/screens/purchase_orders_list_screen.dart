import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/purchase_provider.dart';
import '../../../core/utils/app_colors.dart';
import '../widgets/purchase_order_card.dart';
import 'purchase_order_details_screen.dart';

class PurchaseOrdersListScreen extends StatefulWidget {
  static const String routeName = '/purchase-orders';
  const PurchaseOrdersListScreen({super.key});

  @override
  State<PurchaseOrdersListScreen> createState() => _PurchaseOrdersListScreenState();
}

class _PurchaseOrdersListScreenState extends State<PurchaseOrdersListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOrders();
    });
  }

  Future<void> _loadOrders() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      await Provider.of<PurchaseProvider>(context, listen: false)
          .loadPurchaseOrders(authProvider.currentUser!.usersCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final purchaseProvider = Provider.of<PurchaseProvider>(context);
    final orders = purchaseProvider.purchaseOrders;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.purchaseOrdersTitle),
        backgroundColor: AppColors.primaryColor,
        actions: [
          LanguageSwitcherButton()
        ],
      ),
      body: purchaseProvider.isLoadingOrders && orders.isEmpty
          ? const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0))
          : purchaseProvider.ordersError != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                purchaseProvider.ordersError!,
                style: const TextStyle(color: AppColors.errorColor, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
                onPressed: _loadOrders,
              )
            ],
          ),
        ),
      )
          : orders.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: AppColors.hintColor.withOpacity(0.7)),
            const SizedBox(height: 16),
            Text(
              l10n.noPurchaseOrders,
              style: const TextStyle(fontSize: 18, color: AppColors.hintColor),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: Text(l10n.refresh),
              onPressed: _loadOrders,
            )
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadOrders,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return PurchaseOrderCard(
              order: order,
              onTap: () async {
                purchaseProvider.selectOrder(order);
                final result = await Navigator.of(context).pushNamed(
                  PurchaseOrderDetailsScreen.routeName,
                );

                if (result == true && mounted) {
                  _loadOrders();
                }
              },
            );
          },
        ),
      ),
    );
  }
}