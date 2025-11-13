import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/data_fetch_service.dart';

class HomeProvider with ChangeNotifier {
  final DataFetchService _dataFetchService = DataFetchService();
  NotificationItem? _notificationInfo;
  bool _isLoadingNotifications = false;
  String? _notificationError;

  // لتتبع حالة توسيع الكروت
  Map<String, bool> _expandedCardStates = {
    'purchases': false,
    'hr': false,
    'custody': false,
    'maintenance': false,
    'about': false,
  };

  NotificationItem? get notificationInfo => _notificationInfo;
  bool get isLoadingNotifications => _isLoadingNotifications;
  String? get notificationError => _notificationError;
  Map<String, bool> get expandedCardStates => _expandedCardStates;

  Future<void> loadNotifications(int usersCode) async {
    _isLoadingNotifications = true;
    _notificationError = null;
    notifyListeners();

    try {
      _notificationInfo = await _dataFetchService.fetchUserNotifications(usersCode);
    } catch (e) {
      _notificationError = "فشل تحميل الإشعارات: ${e.toString()}";
      print("Error in HomeProvider loadNotifications: $e");
    } finally {
      _isLoadingNotifications = false;
      notifyListeners();
    }
  }

  void toggleCardExpansion(String cardKey) {
    if (_expandedCardStates.containsKey(cardKey)) {
      _expandedCardStates[cardKey] = !_expandedCardStates[cardKey]!;
      notifyListeners();
    }
  }

  int get purchaseNotificationCount {
    return _notificationInfo?.reqApprPrOrder ?? 0;
  }
}