import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';
import '../services/data_fetch_service.dart';

class UserProvider with ChangeNotifier {
  final DataFetchService _dataFetchService = DataFetchService();
  UserProfileData? _userProfileData;
  bool _isLoadingProfile = false;
  String? _profileError;

  UserProfileData? get userProfileData => _userProfileData;
  bool get isLoadingProfile => _isLoadingProfile;
  String? get profileError => _profileError;

  Future<void> loadUserProfile(int compEmpCode) async {
    _isLoadingProfile = true;
    _profileError = null;
    _userProfileData = null; // مسح البيانات القديمة عند البدء بالتحميل
    notifyListeners();

    try {
      _userProfileData = await _dataFetchService.fetchUserProfile(compEmpCode);
      if (_userProfileData == null) {
        _profileError = "لم يتم العثور على بيانات للمستخدم.";
      }
    } catch (e) {
      _profileError = "فشل تحميل بيانات المستخدم: ${e.toString()}";
      print("Error in UserProvider loadUserProfile: $e");
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }

  // دالة لمسح البيانات عند الخروج من الصفحة (اختياري)
  void clearProfileData() {
    _userProfileData = null;
    _profileError = null;
    // لا تستدعي notifyListeners إذا كنت لا تريد إعادة بناء الواجهة فورًا
  }
}