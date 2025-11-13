
/*

import 'package:flutter/material.dart';
import '../models/purchase_order_model.dart';
import '../services/data_fetch_service.dart';
// سنضيف نماذج التفاصيل لاحقًا
import '../models/pr_order_auth_model.dart';
import '../models/pr_order_srvc_model.dart';
import '../models/pr_order_det_model.dart';


class PurchaseProvider with ChangeNotifier {
  final DataFetchService _dataFetchService = DataFetchService();

  // لقائمة أوامر الشراء
  List<PurchaseOrderItem> _purchaseOrders = [];
  bool _isLoadingOrders = false;
  String? _ordersError;

  List<PurchaseOrderItem> get purchaseOrders => _purchaseOrders;
  bool get isLoadingOrders => _isLoadingOrders;
  String? get ordersError => _ordersError;

  // لتفاصيل أمر الشراء المحدد
  PurchaseOrderItem? _selectedOrder;
  PrOrderAuthResponse? _authDetails; // نموذج لـ PrOrderAuthVO
  PrOrderSrvcResponse? _srvcDetails; // نموذج لـ PrOrderSrvcVRO
  PrOrderDetResponse? _itemDetails;   // نموذج لـ PrOrderDetVRO

  bool _isLoadingOrderDetails = false;
  String? _orderDetailsError;


  PurchaseOrderItem? get selectedOrder => _selectedOrder;
  PrOrderAuthResponse? get authDetails => _authDetails;
  PrOrderSrvcResponse? get srvcDetails => _srvcDetails;
  PrOrderDetResponse? get itemDetails => _itemDetails;
  bool get isLoadingOrderDetails => _isLoadingOrderDetails;
  String? get orderDetailsError => _orderDetailsError;


  Future<void> loadPurchaseOrders(int usersCode) async {
    _isLoadingOrders = true;
    _ordersError = null;
    _purchaseOrders = []; // مسح القائمة القديمة
    notifyListeners();

    try {
      _purchaseOrders = await _dataFetchService.fetchPurchaseOrders(usersCode);
      if (_purchaseOrders.isEmpty) {
        // يمكنك وضع رسالة هنا إذا أردت، مثل "لا توجد أوامر شراء حاليًا"
      }
    } catch (e) {
      _ordersError = "فشل تحميل أوامر الشراء: ${e.toString()}";
      print("Error in PurchaseProvider loadPurchaseOrders: $e");
    } finally {
      _isLoadingOrders = false;
      notifyListeners();
    }
  }

  void selectOrder(PurchaseOrderItem order) {
    _selectedOrder = order;
    // مسح التفاصيل القديمة عند اختيار أمر جديد
    _authDetails = null;
    _srvcDetails = null;
    _itemDetails = null;
    _orderDetailsError = null;
    notifyListeners();
    // لا تقم بتحميل التفاصيل هنا تلقائيًا، بل عند الحاجة في شاشة التفاصيل
  }


  Future<void> loadOrderAuthDetails(String url) async {
    _isLoadingOrderDetails = true;
    notifyListeners();
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        _authDetails = PrOrderAuthResponse.fromJson(data);
      } else {
        _orderDetailsError = "فشل تحميل تفاصيل الاعتماد.";
      }
    } catch (e) {
      _orderDetailsError = "خطأ: ${e.toString()}";
    } finally {
      _isLoadingOrderDetails = false;
      notifyListeners();
    }
  }

  Future<void> loadOrderSrvcDetails(String url) async {
    _isLoadingOrderDetails = true;
    notifyListeners();
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        _srvcDetails = PrOrderSrvcResponse.fromJson(data);
      } else {
        _orderDetailsError = "فشل تحميل تفاصيل الخدمات.";
      }
    } catch (e) {
      _orderDetailsError = "خطأ: ${e.toString()}";
    } finally {
      _isLoadingOrderDetails = false;
      notifyListeners();
    }
  }

  Future<void> loadOrderItemDetails(String url) async {
    _isLoadingOrderDetails = true;
    notifyListeners();
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        _itemDetails = PrOrderDetResponse.fromJson(data);
      } else {
        _orderDetailsError = "فشل تحميل تفاصيل الأصناف.";
      }
    } catch (e) {
      _orderDetailsError = "خطأ: ${e.toString()}";
    } finally {
      _isLoadingOrderDetails = false;
      notifyListeners();
    }
  }

  // لمسح البيانات عند الخروج من شاشة التفاصيل أو القائمة
  void clearPurchaseData() {
    _purchaseOrders = [];
    _selectedOrder = null;
    _authDetails = null;
    _srvcDetails = null;
    _itemDetails = null;
    _ordersError = null;
    _orderDetailsError = null;
    // notifyListeners(); // حسب الحاجة
  }
}


*/

// lib/core/providers/purchase_provider.dart

// lib/core/providers/purchase_provider.dart

// lib/core/providers/purchase_provider.dart
// lib/core/providers/purchase_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/api_constants.dart';
import '../models/purchase_order_model.dart';
import '../services/data_fetch_service.dart';
import '../models/pr_order_auth_model.dart';
import '../models/pr_order_srvc_model.dart';
import '../models/pr_order_det_model.dart';

class PurchaseProvider with ChangeNotifier {
  final DataFetchService _dataFetchService = DataFetchService();

  List<PurchaseOrderItem> _purchaseOrders = [];
  bool _isLoadingOrders = false;
  String? _ordersError;

  PurchaseOrderItem? _selectedOrder;
  PrOrderAuthResponse? _authDetails;
  PrOrderSrvcResponse? _srvcDetails;
  PrOrderDetResponse? _itemDetails;
  bool _isLoadingOrderDetails = false;
  String? _orderDetailsError;

  bool _isSubmittingAction = false;
  String? _actionError;

  List<PurchaseOrderItem> get purchaseOrders => _purchaseOrders;
  bool get isLoadingOrders => _isLoadingOrders;
  String? get ordersError => _ordersError;

  PurchaseOrderItem? get selectedOrder => _selectedOrder;
  PrOrderAuthResponse? get authDetails => _authDetails;
  PrOrderSrvcResponse? get srvcDetails => _srvcDetails;
  PrOrderDetResponse? get itemDetails => _itemDetails;
  bool get isLoadingOrderDetails => _isLoadingOrderDetails;
  String? get orderDetailsError => _orderDetailsError;
  bool get isSubmittingAction => _isSubmittingAction;
  String? get actionError => _actionError;

  Future<void> loadPurchaseOrders(int usersCode) async {
    _isLoadingOrders = true;
    _ordersError = null;
    notifyListeners();
    try {
      final url = "${ApiConstants.baseUrl}${ApiConstants.purchaseOrdersEndpoint}?q=UsersCode=$usersCode";
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        _purchaseOrders = PurchaseOrderList.fromJson(data).items;
      } else {
        _ordersError = "فشل تحميل قائمة أوامر الشراء.";
      }
    } catch (e) {
      _ordersError = "خطأ: ${e.toString()}";
    } finally {
      _isLoadingOrders = false;
      notifyListeners();
    }
  }

  void selectOrder(PurchaseOrderItem order) {
    if (_selectedOrder?.altKey != order.altKey) {
      _selectedOrder = order;
      _authDetails = null; _srvcDetails = null; _itemDetails = null;
      _orderDetailsError = null;
      notifyListeners();
    }
  }

  Future<void> loadOrderAuthDetails(String url) async {
    _isLoadingOrderDetails = true;
    notifyListeners();
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      _authDetails = (data != null) ? PrOrderAuthResponse.fromJson(data) : null;
      if (data == null) _orderDetailsError = "فشل تحميل تفاصيل الاعتماد.";
    } catch (e) { _orderDetailsError = "خطأ: ${e.toString()}";
    } finally { _isLoadingOrderDetails = false; notifyListeners(); }
  }

  Future<void> loadOrderSrvcDetails(String url) async {
    _isLoadingOrderDetails = true;
    notifyListeners();
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      _srvcDetails = (data != null) ? PrOrderSrvcResponse.fromJson(data) : null;
      if (data == null) _orderDetailsError = "فشل تحميل تفاصيل الخدمات.";
    } catch (e) { _orderDetailsError = "خطأ: ${e.toString()}";
    } finally { _isLoadingOrderDetails = false; notifyListeners(); }
  }

  Future<void> loadOrderItemDetails(String url) async {
    _isLoadingOrderDetails = true;
    notifyListeners();
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      _itemDetails = (data != null) ? PrOrderDetResponse.fromJson(data) : null;
      if (data == null) _orderDetailsError = "فشل تحميل تفاصيل الأصناف.";
    } catch (e) { _orderDetailsError = "خطأ: ${e.toString()}";
    } finally { _isLoadingOrderDetails = false; notifyListeners(); }
  }

  Future<bool> submitPurchaseOrderAction({
    required PurchaseOrderItem order,
    required List<PrOrderAuthItem> authChain,
    required int currentUserCode,
    required String usersDesc,
    required int authFlag,
  }) async {
    _isSubmittingAction = true;
    _actionError = null;
    notifyListeners();

    try {
      final int? authPk1 = order.trnsTypeCode;
      final int? authPk2 = order.trnsSerial;

      if (authPk1 == null || authPk2 == null) {
        throw Exception("بيانات تعريف الأمر (TrnsTypeCode/TrnsSerial) مفقودة.");
      }

      int calculatedPrevSer;
      if (authChain.isEmpty) {
        calculatedPrevSer = 1;
      } else {
        final lastStep = authChain.last;
        if (lastStep.prevSer == null || lastStep.prevSer == 0) {
          calculatedPrevSer = 1;
        } else {
          calculatedPrevSer = int.parse("${lastStep.prevSer}1");
        }
      }

      const String authTableName = "PR_ORDER";
      final String altKey = "$authTableName-$authPk1-$authPk2-$calculatedPrevSer";
      final String authDate = DateTime.now().toIso8601String();

      final Map<String, dynamic> requestBody = {
        "AltKey": altKey, "AuthDate": authDate, "AuthFlag": authFlag,
        "AuthPk1": authPk1.toString(), "AuthPk2": authPk2.toString(), "AuthPk3": null,
        "AuthPk4": null, "AuthPk5": null, "AuthTableName": authTableName,
        "FileSerial": 1, "PrevSer": calculatedPrevSer, "SystemNumber": 30,
        "UsersCode": currentUserCode,
        "UsersDesc": usersDesc.isEmpty ? (authFlag == 1 ? "تم الاعتماد" : "تم الرفض") : usersDesc,
        "MobileAuth": 1,
      };

      // --== تمت إضافة الطباعة هنا للمساعدة في تتبع الأخطاء ==--
      debugPrint("--- Sending Purchase Order Action ---");
      debugPrint("URL: http://37.27.112.187:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/SeUsersAuthVO1");
      debugPrint("Request Body: ${json.encode(requestBody)}");
      // --==============================================--

      const String submitUrl = "http://37.27.112.187:7013/TdpSelfServiceWebSrvc-RESTWebService-context-root/rest/V1/SeUsersAuthVO1";

      final response = await http.post(
        Uri.parse(submitUrl),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode(requestBody),
      );

      // --== تمت إضافة الطباعة هنا للمساعدة في تتبع الأخطاء ==--
      debugPrint("--- Response Received ---");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${utf8.decode(response.bodyBytes)}");
      // --==============================================--

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        String serverErrorMsg = "فشل الإجراء.";
        try {
          final errorData = json.decode(utf8.decode(response.bodyBytes));
          serverErrorMsg = errorData["title"] ?? errorData["detail"] ?? errorData["message"] ?? serverErrorMsg;
        } catch(_){}
        throw Exception("خطأ ${response.statusCode}: $serverErrorMsg");
      }
    } catch (e) {
      _actionError = e.toString().replaceFirst("Exception: ", "");
      return false;
    } finally {
      _isSubmittingAction = false;
      notifyListeners();
    }
  }
}