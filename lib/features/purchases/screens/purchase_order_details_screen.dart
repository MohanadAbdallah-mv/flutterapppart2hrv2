/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/purchase_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/purchase_order_model.dart';
import '../../../core/models/pr_order_auth_model.dart';
import '../../../core/models/pr_order_srvc_model.dart';
import '../../../core/models/pr_order_det_model.dart';
import '../../../core/utils/app_colors.dart';

class PurchaseOrderDetailsScreen extends StatefulWidget {
  static const String routeName = '/purchase-order-details';

  const PurchaseOrderDetailsScreen({super.key});

  @override
  State<PurchaseOrderDetailsScreen> createState() => _PurchaseOrderDetailsScreenState();
}

class _PurchaseOrderDetailsScreenState extends State<PurchaseOrderDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _statementController = TextEditingController();
  final Set<int> _loadedTabs = {};
  int _activeAuthStep = 0;

  double _totalServicesAmount = 0.0;
  double _totalItemsAmount = 0.0;
  bool _areTotalsBeingCalculated = true;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);
      final selectedOrder = purchaseProvider.selectedOrder;

      if (selectedOrder == null && mounted) {
        Navigator.of(context).pop();
        return;
      }

      _loadTabData(0, purchaseProvider).then((_) {
        if (mounted) {
          _loadServicesAndItemsForTotal(purchaseProvider);
        }
      });
    });
  }

  void _showActionDialog() {
    final purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final order = purchaseProvider.selectedOrder;
    final authDetails = purchaseProvider.authDetails;
    final currentUser = authProvider.currentUser;

    if (order == null || currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('خطأ: لا يمكن اتخاذ إجراء، البيانات غير مكتملة.'), backgroundColor: Colors.red),
      );
      return;
    }

    if (purchaseProvider.isLoadingOrderDetails && authDetails == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء الانتظار حتى يتم تحميل تفاصيل الاعتماد...')),
      );
      return;
    }

    _statementController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer<PurchaseProvider>(
          builder: (context, provider, child) {
            final isProcessing = provider.isSubmittingAction;

            return AlertDialog(
              title: const Text('اتخاذ قرار بشأن أمر الشراء'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isProcessing)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text("جاري إرسال الإجراء..."),
                        ],
                      ),
                    )
                  else
                    TextFormField(
                      controller: _statementController,
                      decoration: InputDecoration(
                        labelText: 'البيان (ملاحظات للإجراء الحالي)',
                        hintText: 'أدخل ملاحظاتك هنا (اختياري)...',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      maxLines: 3,
                      minLines: 1,
                    ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              // --== الحل النهائي لمشكلة الأزرار المكدسة ==--
              actions: <Widget>[
                if (isProcessing)
                  const SizedBox(height: 52) // حاوية فارغة بنفس ارتفاع الأزرار للحفاظ على حجم الدايالوج
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextButton(
                        child: const Text('إلغاء'),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                      const Spacer(), // لدفع الأزرار التالية إلى اليمين
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorColor),
                        onPressed: () => _submitAction(-1, dialogContext),
                        child: const Text('رفض', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.successColor),
                        onPressed: () => _submitAction(1, dialogContext),
                        child: const Text('اعتماد', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _submitAction(int authFlag, BuildContext dialogContext) async {
    final purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final order = purchaseProvider.selectedOrder!;
    final authDetails = purchaseProvider.authDetails;
    final currentUser = authProvider.currentUser!;

    final success = await purchaseProvider.submitPurchaseOrderAction(
      order: order,
      authChain: authDetails?.items ?? [],
      currentUserCode: currentUser.usersCode,
      usersDesc: _statementController.text,
      authFlag: authFlag,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(dialogContext).pop();
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authFlag == 1 ? 'تم الاعتماد بنجاح.' : 'تم تسجيل الرفض بنجاح.'),
          backgroundColor: AppColors.successColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(purchaseProvider.actionError ?? 'حدث خطأ غير متوقع.'),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }


  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _statementController.dispose();
    super.dispose();
  }

  Future<void> _loadServicesAndItemsForTotal(PurchaseProvider purchaseProvider) async {
    if (!mounted) return;
    setState(() {
      _areTotalsBeingCalculated = true;
    });

    final selectedOrder = purchaseProvider.selectedOrder;
    if (selectedOrder == null) {
      if (mounted) setState(() => _areTotalsBeingCalculated = false);
      return;
    }

    String? srvcUrl = selectedOrder.getLink("PrOrderSrvcVRO");
    if (srvcUrl != null && (!_loadedTabs.contains(1) || purchaseProvider.srvcDetails == null)) {
      try {
        await purchaseProvider.loadOrderSrvcDetails(srvcUrl);
        if (mounted && purchaseProvider.srvcDetails != null) {
          _totalServicesAmount = purchaseProvider.srvcDetails!.items
              .fold(0.0, (sum, item) => sum + (item.totalAmountWithTax ?? 0.0));
          _loadedTabs.add(1);
        }
      } catch (e) { /* Error handling is inside provider */ }
    } else if (purchaseProvider.srvcDetails != null) {
      _totalServicesAmount = purchaseProvider.srvcDetails!.items
          .fold(0.0, (sum, item) => sum + (item.totalAmountWithTax ?? 0.0));
    }

    String? itemUrl = selectedOrder.getLink("PrOrderDetVRO");
    if (itemUrl != null && (!_loadedTabs.contains(2) || purchaseProvider.itemDetails == null)) {
      try {
        await purchaseProvider.loadOrderItemDetails(itemUrl);
        if (mounted && purchaseProvider.itemDetails != null) {
          _totalItemsAmount = purchaseProvider.itemDetails!.items
              .fold(0.0, (sum, item) => sum + (item.totalAmountWithTax ?? 0.0));
          _loadedTabs.add(2);
        }
      } catch (e) { /* Error handling is inside provider */ }
    } else if (purchaseProvider.itemDetails != null) {
      _totalItemsAmount = purchaseProvider.itemDetails!.items
          .fold(0.0, (sum, item) => sum + (item.totalAmountWithTax ?? 0.0));
    }

    if (mounted) {
      setState(() {
        _areTotalsBeingCalculated = false;
      });
    }
  }

  void _handleTabSelection() {
    final purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);
    if (!_loadedTabs.contains(_tabController.index) && mounted) {
      _loadTabData(_tabController.index, purchaseProvider);
    }
  }

  Future<void> _loadTabData(int tabIndex, PurchaseProvider purchaseProvider) async {
    final selectedOrder = purchaseProvider.selectedOrder;
    if (selectedOrder == null || (_loadedTabs.contains(tabIndex) && _dataForTabIsNotNull(tabIndex, purchaseProvider))) {
      return;
    }

    String? url;
    Future<void>? loadFuture;

    switch (tabIndex) {
      case 0:
        url = selectedOrder.getLink("PrOrderAuthVO");
        if (url != null) loadFuture = purchaseProvider.loadOrderAuthDetails(url);
        break;
      case 1:
        url = selectedOrder.getLink("PrOrderSrvcVRO");
        if (url != null) loadFuture = purchaseProvider.loadOrderSrvcDetails(url);
        break;
      case 2:
        url = selectedOrder.getLink("PrOrderDetVRO");
        if (url != null) loadFuture = purchaseProvider.loadOrderItemDetails(url);
        break;
    }

    if (loadFuture != null) {
      try {
        await loadFuture;
        if (mounted) {
          setState(() {
            _loadedTabs.add(tabIndex);
          });
        }
      } catch (error) {
        if(mounted) setState(() => _loadedTabs.add(tabIndex));
      }
    } else if (mounted) {
      setState(() => _loadedTabs.add(tabIndex));
    }
  }

  bool _dataForTabIsNotNull(int tabIndex, PurchaseProvider provider) {
    switch (tabIndex) {
      case 0: return provider.authDetails != null;
      case 1: return provider.srvcDetails != null;
      case 2: return provider.itemDetails != null;
      default: return false;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'غير محدد';
    try {
      final inputFormat = DateFormat("dd-MM-yyyy hh:mm a", "en_US");
      final dateTime = inputFormat.parse(dateString);
      return DateFormat('yyyy/MM/dd hh:mm a', 'ar_SA').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  final currencyFormat = NumberFormat.currency(locale: 'ar_SA', symbol: 'ر.س');

  @override
  Widget build(BuildContext context) {
    final purchaseProvider = Provider.of<PurchaseProvider>(context);
    final order = purchaseProvider.selectedOrder;

    if (order == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(mounted) Navigator.of(context).pop();
      });
      return Scaffold(appBar: AppBar(title: const Text('خطأ')), body: const Center(child: Text('خطأ في تحميل تفاصيل الأمر.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الأمر: ${order.altKey}'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          _buildHeaderCard(order),
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.hintColor,
            indicatorColor: AppColors.accentColor,
            tabs: const [
              Tab(text: 'الاعتمادات', icon: Icon(Icons.playlist_add_check_circle_rounded)),
              Tab(text: 'الخدمات', icon: Icon(Icons.design_services_outlined)),
              Tab(text: 'الأصناف', icon: Icon(Icons.inventory_2_outlined)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAuthDetailsTab(purchaseProvider),
                _buildSrvcDetailsTab(purchaseProvider),
                _buildItemDetailsTab(purchaseProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(PurchaseOrderItem order) {
    String displaySubject = order.poSubject ?? "";
    if (order.poSubjectE != null && order.poSubjectE!.isNotEmpty) {
      displaySubject = displaySubject.isEmpty ? order.poSubjectE! : '$displaySubject\n${order.poSubjectE}';
    }
    double grandTotal = _totalServicesAmount + _totalItemsAmount;

    return Card(
      margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (displaySubject.isNotEmpty) ...[
              Text(order.trnsDesc!, style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold, color: AppColors.primaryColor, height: 1.4), textAlign: TextAlign.start),
              Text(displaySubject, style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold, color: AppColors.primaryColor, height: 1.4), textAlign: TextAlign.start),
              const SizedBox(height: 10),
            ],
            _buildDetailRowForHeader('رقم الأمر:', order.altKey),
            _buildDetailRowForHeader('تاريخ الأمر:', _formatDate(order.prOrderDate)),
            _buildDetailRowForHeader('اسم المورد:', order.supplierName ?? 'غير محدد'),
            const SizedBox(height: 6),
            if (_areTotalsBeingCalculated)
              Row(children: [
                Text('الإجمالي الكلي للأمر: ', style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: AppColors.textColor)),
                const SizedBox(width: 8),
                SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryColor.withOpacity(0.7))),
              ])
            else
              _buildDetailRowForHeader(
                  'الإجمالي الكلي للأمر:',
                  currencyFormat.format(grandTotal),
                  valueColor: AppColors.successColor,
                  isBoldValue: true
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.gavel_rounded),
                label: const Text('اتخاذ قرار', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: _showActionDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRowForHeader(String label, String value, {Color? valueColor, bool isBoldValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: AppColors.textColor.withOpacity(0.9))),
          Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14.5,
                  color: valueColor ?? AppColors.textColor.withOpacity(0.75),
                  fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.start,
              )
          ),
        ],
      ),
    );
  }

  String _getAuthStatusText(int? authFlag) {
    switch (authFlag) {
      case 0: return 'قيد الإجراء';
      case 1: return 'معتمد';
      case 2: return 'مرفوض';
      default: return 'غير محددة';
    }
  }

  Widget _buildAuthDetailsTab(PurchaseProvider provider) {
    if (provider.authDetails == null) {
      if (provider.isLoadingOrderDetails && _tabController.index == 0) {
        return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 40.0));
      }
      if (provider.orderDetailsError != null && _tabController.index == 0) {
        return Center(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('خطأ تحميل الاعتمادات: ${provider.orderDetailsError}', style: const TextStyle(color: AppColors.errorColor), textAlign: TextAlign.center),
        ));
      }
      if (_loadedTabs.contains(0)) {
        return const Center(child: Text('لا توجد بيانات اعتماد لهذا الأمر.', style: TextStyle(fontSize: 16, color: AppColors.hintColor)));
      }
      return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 40.0));
    }

    final authItems = provider.authDetails!.items;
    if (authItems.isEmpty) {
      return const Center(child: Text('لا توجد اعتمادات مسجلة لهذا الأمر.', style: TextStyle(fontSize: 16, color: AppColors.hintColor)));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 70.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "سلسلة الاعتمادات:",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 14),
          _buildAuthTimeline(authItems),
        ],
      ),
    );
  }

  Widget _buildAuthTimeline(List<PrOrderAuthItem> authItems) {
    return Column(
      children: List.generate(authItems.length, (index) {
        final item = authItems[index];
        final bool isActiveStep = (index == _activeAuthStep);

        bool isCompleted = item.authFlag == 1;
        bool isRejected = item.authFlag == 2;
        IconData stepIconData;
        Color stepColor;

        Color precedingLineColor = AppColors.hintColor.withOpacity(0.4);
        if (index > 0) {
          if (authItems[index-1].authFlag == 1) precedingLineColor = AppColors.successColor;
          else if (authItems[index-1].authFlag == 2) precedingLineColor = AppColors.errorColor;
        }

        Color succeedingLineColor = AppColors.hintColor.withOpacity(0.4);
        if (isCompleted) {
          stepIconData = Icons.check_circle_rounded;
          stepColor = AppColors.successColor;
          succeedingLineColor = AppColors.successColor;
        } else if (isRejected) {
          stepIconData = Icons.cancel_rounded;
          stepColor = AppColors.errorColor;
          succeedingLineColor = AppColors.errorColor;
        } else {
          stepIconData = Icons.pending_actions_rounded;
          stepColor = isActiveStep ? AppColors.primaryColor : AppColors.hintColor.withOpacity(0.8);
        }

        // --== الحل النهائي لمشكلة الخط المعوج ==--
        return InkWell(
          onTap: () { if (mounted) setState(() => _activeAuthStep = index); },
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    if (index > 0) Expanded(child: Container(width: 2.5, color: precedingLineColor)),
                    // استخدام حاوية بحجم ثابت لتثبيت مكان الأيقونة
                    Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      child: Icon(stepIconData, color: stepColor, size: isActiveStep ? 28 : 24),
                    ),
                    if (index < authItems.length - 1) Expanded(child: Container(width: 2.5, color: succeedingLineColor)),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: index < authItems.length -1 ? 10 : 0, top: 5),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: isActiveStep ? AppColors.primaryColor.withOpacity(0.05) : Colors.grey.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: isActiveStep ? AppColors.primaryColor.withOpacity(0.5) : Colors.grey.withOpacity(0.3),
                            width: isActiveStep ? 1.0 : 0.7
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.usersName ?? 'غير معروف', style: TextStyle(fontSize: 15, fontWeight: isActiveStep ? FontWeight.bold : FontWeight.w500, color: isActiveStep ? AppColors.primaryColor : AppColors.textColor)),
                        if (item.jobDesc != null && item.jobDesc!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(item.jobDesc!, style: TextStyle(fontSize: 12, color: AppColors.textColor.withOpacity(0.75))),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('التاريخ: ${_formatDate(item.authDate)}', style: TextStyle(fontSize: 11.5, color: AppColors.textColor.withOpacity(0.65))),
                            Text(_getAuthStatusText(item.authFlag), style: TextStyle(fontSize: 11.5, color: isCompleted ? AppColors.successColor : (isRejected ? AppColors.errorColor : AppColors.hintColor), fontWeight: FontWeight.bold)),
                          ],
                        ),
                        if (item.usersDesc != null && item.usersDesc!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: (isActiveStep ? AppColors.primaryColor : Colors.blueGrey).withOpacity(0.04),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: (isActiveStep ? AppColors.primaryColor : Colors.blueGrey).withOpacity(0.1))
                            ),
                            child: Text('الملاحظات: ${item.usersDesc}', style: TextStyle(fontSize: 12, color: AppColors.textColor.withOpacity(0.85), fontStyle: FontStyle.italic)),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSrvcDetailsTab(PurchaseProvider provider) {
    if (provider.srvcDetails == null) {
      if (provider.isLoadingOrderDetails && _tabController.index == 1) {
        return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 40.0));
      }
      if (provider.orderDetailsError != null && _tabController.index == 1) {
        return Center(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('خطأ تحميل الخدمات: ${provider.orderDetailsError}', style: const TextStyle(color: AppColors.errorColor), textAlign: TextAlign.center),
        ));
      }
      if (_loadedTabs.contains(1)) {
        return const Center(child: Text('لا توجد خدمات لهذا الأمر.', style: TextStyle(fontSize: 16, color: AppColors.hintColor)));
      }
      return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 40.0));
    }

    final services = provider.srvcDetails!.items;
    if (services.isEmpty) {
      return const Center(child: Text('لا توجد خدمات مسجلة لهذا الأمر.', style: TextStyle(fontSize: 16, color: AppColors.hintColor)));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: DataTable(
            columnSpacing: 18.0,
            headingRowColor: MaterialStateColor.resolveWith((states) => AppColors.primaryColor.withOpacity(0.08)),
            border: TableBorder.all(color: AppColors.hintColor.withOpacity(0.25), borderRadius: BorderRadius.circular(8)),
            columns: const [
              DataColumn(label: Text('الخدمة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5))),
              DataColumn(label: Text('الوحدة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5))),
              DataColumn(label: Text('كمية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
              DataColumn(label: Text('تكلفة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
              DataColumn(label: Text('ضريبة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
              DataColumn(label: Text('إجمالي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
            ],
            rows: services.map((service) {
              return DataRow(cells: [
                DataCell(SizedBox(width: 180, child: Text(service.srvcName ?? '', overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(fontSize: 13)))),
                DataCell(Text(service.unitName ?? '', style: const TextStyle(fontSize: 13))),
                DataCell(Text(service.quantity?.toStringAsFixed(2) ?? '0', style: const TextStyle(fontSize: 13))),
                DataCell(Text(currencyFormat.format(service.unitCost ?? 0), style: const TextStyle(fontSize: 13))),
                DataCell(Text(currencyFormat.format(service.taxValue1 ?? 0), style: const TextStyle(fontSize: 13))),
                DataCell(Text(currencyFormat.format(service.totalAmountWithTax), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13))),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildItemDetailsTab(PurchaseProvider provider) {
    if (provider.itemDetails == null) {
      if (provider.isLoadingOrderDetails && _tabController.index == 2) {
        return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 40.0));
      }
      if (provider.orderDetailsError != null && _tabController.index == 2) {
        return Center(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('خطأ تحميل الأصناف: ${provider.orderDetailsError}', style: const TextStyle(color: AppColors.errorColor), textAlign: TextAlign.center),
        ));
      }
      if (_loadedTabs.contains(2)) {
        return const Center(child: Text('لا توجد أصناف لهذا الأمر.', style: TextStyle(fontSize: 16, color: AppColors.hintColor)));
      }
      return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 40.0));
    }

    final items = provider.itemDetails!.items;
    if (items.isEmpty) {
      return const Center(child: Text('لا توجد أصناف مسجلة لهذا الأمر.', style: TextStyle(fontSize: 16, color: AppColors.hintColor)));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: DataTable(
            columnSpacing: 16.0,
            headingRowColor: MaterialStateColor.resolveWith((states) => AppColors.primaryColor.withOpacity(0.08)),
            border: TableBorder.all(color: AppColors.hintColor.withOpacity(0.25), borderRadius: BorderRadius.circular(8)),
            columns: const [
              DataColumn(label: Text('الصنف', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5))),
              DataColumn(label: Text('الوصف', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5))),
              DataColumn(label: Text('وحدة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5))),
              DataColumn(label: Text('كمية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
              DataColumn(label: Text('سعر', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
              DataColumn(label: Text('ضريبة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
              DataColumn(label: Text('إجمالي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
            ],
            rows: items.map((item) {
              return DataRow(cells: [
                DataCell(SizedBox(width: 160, child: Text(item.itemName ?? '', overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(fontSize: 13)))),
                DataCell(SizedBox(width: 160, child: Text(item.itemName ?? '', overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(fontSize: 13)))),
                DataCell(Text(item.unitNameD ?? '', style: const TextStyle(fontSize: 13))),
                DataCell(Text(item.qty?.toStringAsFixed(2) ?? '0', style: const TextStyle(fontSize: 13))),
                DataCell(Text(currencyFormat.format(item.unitPrice ?? 0), style: const TextStyle(fontSize: 13))),
                DataCell(Text(currencyFormat.format(item.taxValue ?? 0), style: const TextStyle(fontSize: 13))),
                DataCell(Text(currencyFormat.format(item.totalAmountWithTax), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13))),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

*/


import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/features/purchases/widgets/language_switcher_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/purchase_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/models/purchase_order_model.dart';
import '../../../core/models/pr_order_auth_model.dart';
import '../../../core/models/pr_order_srvc_model.dart';
import '../../../core/models/pr_order_det_model.dart';
import '../../../core/utils/app_colors.dart';

class PurchaseOrderDetailsScreen extends StatefulWidget {
  static const String routeName = '/purchase-order-details';

  const PurchaseOrderDetailsScreen({super.key});

  @override
  State<PurchaseOrderDetailsScreen> createState() => _PurchaseOrderDetailsScreenState();
}

class _PurchaseOrderDetailsScreenState extends State<PurchaseOrderDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _statementController = TextEditingController();
  final Set<int> _loadedTabs = {};
  int _activeAuthStep = 0;

  double _totalServicesAmount = 0.0;
  double _totalItemsAmount = 0.0;
  bool _areTotalsBeingCalculated = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);
      final selectedOrder = purchaseProvider.selectedOrder;

      if (selectedOrder == null && mounted) {
        Navigator.of(context).pop();
        return;
      }

      _loadTabData(0, purchaseProvider).then((_) {
        if (mounted) {
          _loadServicesAndItemsForTotal(purchaseProvider);
        }
      });
    });
  }

  void _showActionDialog() {
    final l10n = AppLocalizations.of(context)!;
    final purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final order = purchaseProvider.selectedOrder;
    final authDetails = purchaseProvider.authDetails;
    final currentUser = authProvider.currentUser;

    if (order == null || currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.actionErrorIncompleteData), backgroundColor: Colors.red),
      );
      return;
    }

    if (purchaseProvider.isLoadingOrderDetails && authDetails == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.waitForAuthDetails)),
      );
      return;
    }

    _statementController.clear();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Consumer<PurchaseProvider>(
          builder: (context, provider, child) {
            final isProcessing = provider.isSubmittingAction;

            return AlertDialog(
              title: Text(l10n.actionDialogTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isProcessing)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(l10n.submittingAction),
                        ],
                      ),
                    )
                  else
                    TextFormField(
                      controller: _statementController,
                      decoration: InputDecoration(
                        labelText: l10n.statementLabel,
                        hintText: l10n.statementHint,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      maxLines: 3,
                      minLines: 1,
                    ),
                ],
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              actions: <Widget>[
                if (isProcessing)
                  const SizedBox(height: 52)
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextButton(
                        child: Text(l10n.cancel),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorColor),
                        onPressed: () => _submitAction(-1, dialogContext),
                        child: Text(l10n.reject, style: const TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.successColor),
                        onPressed: () => _submitAction(1, dialogContext),
                        child: Text(l10n.approve, style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _submitAction(int authFlag, BuildContext dialogContext) async {
    final l10n = AppLocalizations.of(context)!;
    final purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final order = purchaseProvider.selectedOrder!;
    final authDetails = purchaseProvider.authDetails;
    final currentUser = authProvider.currentUser!;

    final success = await purchaseProvider.submitPurchaseOrderAction(
      order: order,
      authChain: authDetails?.items ?? [],
      currentUserCode: currentUser.usersCode,
      usersDesc: _statementController.text,
      authFlag: authFlag,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(dialogContext).pop();
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authFlag == 1 ? l10n.approvalSuccess : l10n.rejectionSuccess),
          backgroundColor: AppColors.successColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(purchaseProvider.actionError ?? l10n.unexpectedError),
          backgroundColor: AppColors.errorColor,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _statementController.dispose();
    super.dispose();
  }

  Future<void> _loadServicesAndItemsForTotal(PurchaseProvider purchaseProvider) async {
    // ... (الكود الداخلي لا يتغير لأنه لا يحتوي على نصوص)
    if (!mounted) return;
    setState(() {
      _areTotalsBeingCalculated = true;
    });

    final selectedOrder = purchaseProvider.selectedOrder;
    if (selectedOrder == null) {
      if (mounted) setState(() => _areTotalsBeingCalculated = false);
      return;
    }

    String? srvcUrl = selectedOrder.getLink("PrOrderSrvcVRO");
    if (srvcUrl != null && (!_loadedTabs.contains(1) || purchaseProvider.srvcDetails == null)) {
      try {
        await purchaseProvider.loadOrderSrvcDetails(srvcUrl);
        if (mounted && purchaseProvider.srvcDetails != null) {
          _totalServicesAmount = purchaseProvider.srvcDetails!.items
              .fold(0.0, (sum, item) => sum + (item.totalAmountWithTax ?? 0.0));
          _loadedTabs.add(1);
        }
      } catch (e) { /* Error handling is inside provider */ }
    } else if (purchaseProvider.srvcDetails != null) {
      _totalServicesAmount = purchaseProvider.srvcDetails!.items
          .fold(0.0, (sum, item) => sum + (item.totalAmountWithTax ?? 0.0));
    }

    String? itemUrl = selectedOrder.getLink("PrOrderDetVRO");
    if (itemUrl != null && (!_loadedTabs.contains(2) || purchaseProvider.itemDetails == null)) {
      try {
        await purchaseProvider.loadOrderItemDetails(itemUrl);
        if (mounted && purchaseProvider.itemDetails != null) {
          _totalItemsAmount = purchaseProvider.itemDetails!.items
              .fold(0.0, (sum, item) => sum + (item.totalAmountWithTax ?? 0.0));
          _loadedTabs.add(2);
        }
      } catch (e) { /* Error handling is inside provider */ }
    } else if (purchaseProvider.itemDetails != null) {
      _totalItemsAmount = purchaseProvider.itemDetails!.items
          .fold(0.0, (sum, item) => sum + (item.totalAmountWithTax ?? 0.0));
    }

    if (mounted) {
      setState(() {
        _areTotalsBeingCalculated = false;
      });
    }
  }

  void _handleTabSelection() {
    final purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);
    if (!_loadedTabs.contains(_tabController.index) && mounted) {
      _loadTabData(_tabController.index, purchaseProvider);
    }
  }

  Future<void> _loadTabData(int tabIndex, PurchaseProvider purchaseProvider) async {
    // ... (الكود الداخلي لا يتغير لأنه لا يحتوي على نصوص)
    final selectedOrder = purchaseProvider.selectedOrder;
    if (selectedOrder == null || (_loadedTabs.contains(tabIndex) && _dataForTabIsNotNull(tabIndex, purchaseProvider))) {
      return;
    }

    String? url;
    Future<void>? loadFuture;

    switch (tabIndex) {
      case 0:
        url = selectedOrder.getLink("PrOrderAuthVO");
        if (url != null) loadFuture = purchaseProvider.loadOrderAuthDetails(url);
        break;
      case 1:
        url = selectedOrder.getLink("PrOrderSrvcVRO");
        if (url != null) loadFuture = purchaseProvider.loadOrderSrvcDetails(url);
        break;
      case 2:
        url = selectedOrder.getLink("PrOrderDetVRO");
        if (url != null) loadFuture = purchaseProvider.loadOrderItemDetails(url);
        break;
    }

    if (loadFuture != null) {
      try {
        await loadFuture;
        if (mounted) {
          setState(() {
            _loadedTabs.add(tabIndex);
          });
        }
      } catch (error) {
        if(mounted) setState(() => _loadedTabs.add(tabIndex));
      }
    } else if (mounted) {
      setState(() => _loadedTabs.add(tabIndex));
    }
  }

  bool _dataForTabIsNotNull(int tabIndex, PurchaseProvider provider) {
    switch (tabIndex) {
      case 0: return provider.authDetails != null;
      case 1: return provider.srvcDetails != null;
      case 2: return provider.itemDetails != null;
      default: return false;
    }
  }

  String _formatDate(String? dateString, String locale) {
    final l10n = AppLocalizations.of(context)!;
    if (dateString == null || dateString.isEmpty) return l10n.notSpecified;
    try {
      final inputFormat = DateFormat("dd-MM-yyyy hh:mm a", "en_US");
      final dateTime = inputFormat.parse(dateString);
      return DateFormat('yyyy/MM/dd hh:mm a', locale).format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  NumberFormat _getCurrencyFormat(String locale) {
    if (locale == 'ar') {
      return NumberFormat.currency(locale: 'ar_SA', symbol: 'ر.س');
    } else {
      return NumberFormat.currency(locale: 'en_US', symbol: 'SAR');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final purchaseProvider = Provider.of<PurchaseProvider>(context);
    final order = purchaseProvider.selectedOrder;

    if (order == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop();
      });
      return Scaffold(appBar: AppBar(title: Text(l10n.orderDetailsTitle)), body: Center(child: Text(l10n.errorLoadingOrder)));
    }

    return Scaffold(
      appBar: AppBar(

        title: Text('${l10n.orderDetailsTitle} ${order.altKey}'),
        backgroundColor: AppColors.primaryColor,
        actions: [
          LanguageSwitcherButton()
        ],
      ),
      body: Column(
        children: [
          _buildHeaderCard(order),
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.hintColor,
            indicatorColor: AppColors.accentColor,
            tabs: [
              Tab(text: l10n.approvals, icon: const Icon(Icons.playlist_add_check_circle_rounded)),
              Tab(text: l10n.services, icon: const Icon(Icons.design_services_outlined)),
              Tab(text: l10n.items, icon: const Icon(Icons.inventory_2_outlined)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAuthDetailsTab(purchaseProvider),
                _buildSrvcDetailsTab(purchaseProvider),
                _buildItemDetailsTab(purchaseProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(PurchaseOrderItem order) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';
    final currencyFormat = _getCurrencyFormat(localeProvider.locale.languageCode);

    final String displaySubject = isArabic
        ? (order.poSubject ?? l10n.notSpecified)
        : (order.poSubjectE ?? order.poSubject ?? l10n.notSpecified);

    final String trnsDesc = isArabic
        ? (order.trnsDesc ?? '')
        : (order.trnsDescE ?? order.trnsDesc ?? '');

    final String supplierName = isArabic
        ? (order.supplierName ?? l10n.notSpecified)
        : (order.supplierNameE ?? order.supplierName ?? l10n.notSpecified);

    double grandTotal = _totalServicesAmount + _totalItemsAmount;

    return Card(
      margin: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (trnsDesc.isNotEmpty) ...[
              Text(trnsDesc, style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold, color: AppColors.primaryColor, height: 1.4), textAlign: TextAlign.start),
              const SizedBox(height: 4),
            ],
            if (displaySubject.isNotEmpty) ...[
              Text(displaySubject, style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textColor, height: 1.4), textAlign: TextAlign.start),
              const SizedBox(height: 10),
            ],
            _buildDetailRowForHeader(l10n.orderNumberLabel, order.altKey),
            _buildDetailRowForHeader(l10n.orderDateLabel, _formatDate(order.prOrderDate, localeProvider.locale.toLanguageTag())),
            _buildDetailRowForHeader(l10n.supplierNameLabel, supplierName),
            const SizedBox(height: 6),
            if (_areTotalsBeingCalculated)
              Row(children: [
                Text(l10n.calculatingTotal, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: AppColors.textColor)),
                const SizedBox(width: 8),
                SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryColor.withOpacity(0.7))),
              ])
            else
              _buildDetailRowForHeader(
                  l10n.totalOrderAmount,
                  currencyFormat.format(grandTotal),
                  valueColor: AppColors.successColor,
                  isBoldValue: true
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.gavel_rounded),
                label: Text(l10n.takeAction, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: _showActionDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRowForHeader(String label, String value, {Color? valueColor, bool isBoldValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: AppColors.textColor.withOpacity(0.9))),
          Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14.5,
                  color: valueColor ?? AppColors.textColor.withOpacity(0.75),
                  fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.start,
              )
          ),
        ],
      ),
    );
  }

  String _getAuthStatusText(int? authFlag) {
    final l10n = AppLocalizations.of(context)!;
    switch (authFlag) {
      case 0: return l10n.authStatusPending;
      case 1: return l10n.authStatusApproved;
      case 2: return l10n.authStatusRejected;
      default: return l10n.authStatusUndefined;
    }
  }

  Widget _buildAuthDetailsTab(PurchaseProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    if (provider.authDetails == null) {
      if (provider.isLoadingOrderDetails && _tabController.index == 0) {
        return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 40.0));
      }
      if (provider.orderDetailsError != null && _tabController.index == 0) {
        return Center(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('${l10n.errorLoadingApprovals} ${provider.orderDetailsError}', style: const TextStyle(color: AppColors.errorColor), textAlign: TextAlign.center),
        ));
      }
      if (_loadedTabs.contains(0)) {
        return Center(child: Text(l10n.noApprovalData, style: const TextStyle(fontSize: 16, color: AppColors.hintColor)));
      }
      return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 40.0));
    }

    final authItems = provider.authDetails!.items;
    if (authItems.isEmpty) {
      return Center(child: Text(l10n.noRegisteredApprovals, style: const TextStyle(fontSize: 16, color: AppColors.hintColor)));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 70.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.approvalChain,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 14),
          _buildAuthTimeline(authItems),
        ],
      ),
    );
  }

  Widget _buildAuthTimeline(List<PrOrderAuthItem> authItems) {
    // ... (الكود الداخلي لا يتغير بشكل كبير لأنه يعتمد على المتغيرات)
    // ... (سأقوم بترجمة النصوص فقط)
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';

    return Column(
      children: List.generate(authItems.length, (index) {
        final item = authItems[index];
        final bool isActiveStep = (index == _activeAuthStep);

        bool isCompleted = item.authFlag == 1;
        bool isRejected = item.authFlag == 2;
        IconData stepIconData;
        Color stepColor;

        Color precedingLineColor = AppColors.hintColor.withOpacity(0.4);
        if (index > 0) {
          if (authItems[index-1].authFlag == 1) precedingLineColor = AppColors.successColor;
          else if (authItems[index-1].authFlag == 2) precedingLineColor = AppColors.errorColor;
        }

        Color succeedingLineColor = AppColors.hintColor.withOpacity(0.4);
        if (isCompleted) {
          stepIconData = Icons.check_circle_rounded;
          stepColor = AppColors.successColor;
          succeedingLineColor = AppColors.successColor;
        } else if (isRejected) {
          stepIconData = Icons.cancel_rounded;
          stepColor = AppColors.errorColor;
          succeedingLineColor = AppColors.errorColor;
        } else {
          stepIconData = Icons.pending_actions_rounded;
          stepColor = isActiveStep ? AppColors.primaryColor : AppColors.hintColor.withOpacity(0.8);
        }

        final String usersName = isArabic ? (item.usersName ?? l10n.unknownUser) : (item.usersNameE ?? item.usersName ?? l10n.unknownUser);
        final String jobDesc = isArabic ? (item.jobDesc ?? '') : (item.jobDescE ?? item.jobDesc ?? '');

        return InkWell(
          onTap: () { if (mounted) setState(() => _activeAuthStep = index); },
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    if (index > 0) Expanded(child: Container(width: 2.5, color: precedingLineColor)),
                    Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      child: Icon(stepIconData, color: stepColor, size: isActiveStep ? 28 : 24),
                    ),
                    if (index < authItems.length - 1) Expanded(child: Container(width: 2.5, color: succeedingLineColor)),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: index < authItems.length -1 ? 10 : 0, top: 5),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: isActiveStep ? AppColors.primaryColor.withOpacity(0.05) : Colors.grey.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                            color: isActiveStep ? AppColors.primaryColor.withOpacity(0.5) : Colors.grey.withOpacity(0.3),
                            width: isActiveStep ? 1.0 : 0.7
                        )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(usersName, style: TextStyle(fontSize: 15, fontWeight: isActiveStep ? FontWeight.bold : FontWeight.w500, color: isActiveStep ? AppColors.primaryColor : AppColors.textColor)),
                        if (jobDesc.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(jobDesc, style: TextStyle(fontSize: 12, color: AppColors.textColor.withOpacity(0.75))),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${l10n.dateLabel} ${_formatDate(item.authDate, localeProvider.locale.toLanguageTag())}', style: TextStyle(fontSize: 11.5, color: AppColors.textColor.withOpacity(0.65))),
                            Text(_getAuthStatusText(item.authFlag), style: TextStyle(fontSize: 11.5, color: isCompleted ? AppColors.successColor : (isRejected ? AppColors.errorColor : AppColors.hintColor), fontWeight: FontWeight.bold)),
                          ],
                        ),
                        if (item.usersDesc != null && item.usersDesc!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: (isActiveStep ? AppColors.primaryColor : Colors.blueGrey).withOpacity(0.04),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: (isActiveStep ? AppColors.primaryColor : Colors.blueGrey).withOpacity(0.1))
                            ),
                            child: Text('${l10n.notesLabel} ${item.usersDesc}', style: TextStyle(fontSize: 12, color: AppColors.textColor.withOpacity(0.85), fontStyle: FontStyle.italic)),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSrvcDetailsTab(PurchaseProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';
    final currencyFormat = _getCurrencyFormat(localeProvider.locale.languageCode);

    if (provider.srvcDetails == null) {
      if (provider.isLoadingOrderDetails && _tabController.index == 1) {
        return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 40.0));
      }
      if (provider.orderDetailsError != null && _tabController.index == 1) {
        return Center(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('${l10n.errorLoadingServices} ${provider.orderDetailsError}', style: const TextStyle(color: AppColors.errorColor), textAlign: TextAlign.center),
        ));
      }
      if (_loadedTabs.contains(1)) {
        return Center(child: Text(l10n.noServiceData, style: const TextStyle(fontSize: 16, color: AppColors.hintColor)));
      }
      return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 40.0));
    }

    final services = provider.srvcDetails!.items;
    if (services.isEmpty) {
      return Center(child: Text(l10n.noRegisteredServices, style: const TextStyle(fontSize: 16, color: AppColors.hintColor)));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: DataTable(
            columnSpacing: 18.0,
            headingRowColor: MaterialStateColor.resolveWith((states) => AppColors.primaryColor.withOpacity(0.08)),
            border: TableBorder.all(color: AppColors.hintColor.withOpacity(0.25), borderRadius: BorderRadius.circular(8)),
            columns: [
              DataColumn(label: Text(l10n.service, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5))),
              DataColumn(label: Text(l10n.unit, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5))),
              DataColumn(label: Text(l10n.quantity, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
              DataColumn(label: Text(l10n.cost, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
              DataColumn(label: Text(l10n.tax, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
              DataColumn(label: Text(l10n.total, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
            ],
            rows: services.map((service) {
              final srvcName = isArabic ? (service.srvcName ?? '') : (service.srvcNameE ?? service.srvcName ?? '');
              final unitName = isArabic ? (service.unitName ?? '') : (service.unitNameE ?? service.unitName ?? '');
              return DataRow(cells: [
                DataCell(SizedBox(width: 180, child: Text(srvcName, overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(fontSize: 13)))),
                DataCell(Text(unitName, style: const TextStyle(fontSize: 13))),
                DataCell(Text(service.quantity?.toStringAsFixed(2) ?? '0', style: const TextStyle(fontSize: 13))),
                DataCell(Text(currencyFormat.format(service.unitCost ?? 0), style: const TextStyle(fontSize: 13))),
                DataCell(Text(currencyFormat.format(service.taxValue1 ?? 0), style: const TextStyle(fontSize: 13))),
                DataCell(Text(currencyFormat.format(service.totalAmountWithTax), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13))),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildItemDetailsTab(PurchaseProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final isArabic = localeProvider.locale.languageCode == 'ar';
    final currencyFormat = _getCurrencyFormat(localeProvider.locale.languageCode);

    if (provider.itemDetails == null) {
      if (provider.isLoadingOrderDetails && _tabController.index == 2) {
        return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 40.0));
      }
      if (provider.orderDetailsError != null && _tabController.index == 2) {
        return Center(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('${l10n.errorLoadingItems} ${provider.orderDetailsError}', style: const TextStyle(color: AppColors.errorColor), textAlign: TextAlign.center),
        ));
      }
      if (_loadedTabs.contains(2)) {
        return Center(child: Text(l10n.noItemData, style: const TextStyle(fontSize: 16, color: AppColors.hintColor)));
      }
      return const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 40.0));
    }

    final items = provider.itemDetails!.items;
    if (items.isEmpty) {
      return Center(child: Text(l10n.noRegisteredItems, style: const TextStyle(fontSize: 16, color: AppColors.hintColor)));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: DataTable(
            columnSpacing: 16.0,
            headingRowColor: MaterialStateColor.resolveWith((states) => AppColors.primaryColor.withOpacity(0.08)),
            border: TableBorder.all(color: AppColors.hintColor.withOpacity(0.25), borderRadius: BorderRadius.circular(8)),
            columns: [
              DataColumn(label: Text(l10n.item, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5))),
             // DataColumn(label: Text(l10n.description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5))),
              DataColumn(label: Text(l10n.unit, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5))),
              DataColumn(label: Text(l10n.quantity, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
              DataColumn(label: Text(l10n.price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
              DataColumn(label: Text(l10n.tax, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
              DataColumn(label: Text(l10n.total, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)), numeric: true),
            ],
            rows: items.map((item) {
              final itemName = isArabic ? (item.itemName ?? '') : (item.itemNameE ?? item.itemName ?? '');
              final itemDesc = isArabic ? (item.itemDesc ?? '') : (item.itemDesc ?? item.itemDesc ?? '');
              final unitName = isArabic ? (item.unitNameD ?? '') : (item.unitNameDE ?? item.unitNameD ?? '');

              return DataRow(cells: [
                DataCell(SizedBox(width: 160, child: Text(itemName, overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(fontSize: 13)))),
              //  DataCell(SizedBox(width: 160, child: Text(itemDesc, overflow: TextOverflow.ellipsis, maxLines: 2, style: const TextStyle(fontSize: 13)))),
                DataCell(Text(unitName, style: const TextStyle(fontSize: 13))),
                DataCell(Text(item.qty?.toStringAsFixed(2) ?? '0', style: const TextStyle(fontSize: 13))),
                DataCell(Text(currencyFormat.format(item.unitPrice ?? 0), style: const TextStyle(fontSize: 13))),
                DataCell(Text(currencyFormat.format(item.taxValue ?? 0), style: const TextStyle(fontSize: 13))),
                DataCell(Text(currencyFormat.format(item.totalAmountWithTax), style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13))),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}