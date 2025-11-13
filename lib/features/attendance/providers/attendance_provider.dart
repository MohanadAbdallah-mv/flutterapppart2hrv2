// features/attendance/providers/attendance_provider.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterapppart2hr/core/models/notification_info_model.dart';
import 'package:flutterapppart2hr/features/attendance/models/checked_attendance_detail_model.dart';
import 'package:flutterapppart2hr/features/attendance/models/checked_attendance_month_model.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http show post;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/api/api_constants.dart';
import '../../../core/services/data_fetch_service.dart';
import '../models/attendance_month_model.dart';
import '../models/attendance_detail_model.dart';

class AttendanceProvider with ChangeNotifier {
  final DataFetchService _dataFetchService = DataFetchService();

  // ---== حالات الـ Provider ==---
  bool _isLoadingMonths = false;
  List<AttendanceMonthItem> _months = [];
  String? _monthsError;
  bool get isLoadingMonths => _isLoadingMonths;
  List<AttendanceMonthItem> get months => _months;
  String? get monthsError => _monthsError;

  bool _isLoadingDetails = false;
  // سيتم تخزين البيانات مجمعة حسب اليوم
  Map<String, List<AttendanceDetailItem>> _groupedDetails = {};
  String? _detailsError;
  bool get isLoadingDetails => _isLoadingDetails;
  Map<String, List<AttendanceDetailItem>> get groupedDetails => _groupedDetails;
  String? get detailsError => _detailsError;

  // ---== حالات جديدة للحضور المتحقق منه ==---
  bool _isLoadingCheckedMonths = false;
  List<CheckedAttendanceMonthItem> _checkedMonths = [];
  String? _checkedMonthsError;
  bool get isLoadingCheckedMonths => _isLoadingCheckedMonths;
  List<CheckedAttendanceMonthItem> get checkedMonths => _checkedMonths;
  String? get checkedMonthsError => _checkedMonthsError;

  bool _isLoadingCheckedDetails = false;
  List<CheckedAttendanceDetailItem> _checkedDetails = [];
  String? _checkedDetailsError;
  bool get isLoadingCheckedDetails => _isLoadingCheckedDetails;
  List<CheckedAttendanceDetailItem> get checkedDetails => _checkedDetails;
  String? get checkedDetailsError => _checkedDetailsError;

  // --- الإضافات الجديدة ---
  List<AttendanceMonthItem> _monthlyAttendance = [];
  List<AttendanceDetailItem> _dailyDetails = [];
  bool _isLoading = false;
  String? _error;

  List<AttendanceMonthItem> get monthlyAttendance => _monthlyAttendance;
  List<AttendanceDetailItem> get dailyDetails => _dailyDetails;
  bool get isLoading => _isLoading;
  String? get error => _error;
  NotificationInfo? _companyLocationInfo;
  NotificationInfo? get companyLocationInfo => _companyLocationInfo;

  bool _isActionInProgress = false;
  bool get isActionInProgress => _isActionInProgress;

  String? _actionError;
  String? get actionError => _actionError;

  // ---== دوال جلب البيانات ==---

  // جلب قائمة الشهور
  Future<void> fetchAttendanceMonths(int empCode) async {
    _isLoadingMonths = true;
    _monthsError = null;
    notifyListeners();
    try {
      final url = "${ApiConstants.baseUrl}${ApiConstants.attendanceMonthsEndpoint}?q=EmpCode=$empCode";
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        final monthList = AttendanceMonthList.fromJson(data);
        _months = monthList.items;
      } else {
        _months = [];
      }
    } catch (e) {
      _monthsError = "فشل تحميل الشهور: ${e.toString()}";
    } finally {
      _isLoadingMonths = false;
      notifyListeners();
    }
  }

  // جلب تفاصيل شهر معين ومعالجتها
  Future<void> fetchMonthDetails(String url) async {
    _isLoadingDetails = true;
    _detailsError = null;
    _groupedDetails = {}; // تفريغ البيانات القديمة
    notifyListeners();
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        final detailList = AttendanceDetailList.fromJson(data);
        // ---== هنا المنطق الأهم: تجميع البيانات حسب اليوم ==---
        _processAndGroupDetails(detailList.items);
      }
    } catch (e) {
      _detailsError = "فشل تحميل تفاصيل الحضور: ${e.toString()}";
    } finally {
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  void _processAndGroupDetails(List<AttendanceDetailItem> details) {
    final Map<String, List<AttendanceDetailItem>> tempGroup = {};
    for (var detail in details) {
      if (detail.attDate == null) continue;
      // استخدام التاريخ "yyyy-MM-dd" كمفتاح للتجميع
      final dayKey = DateFormat('yyyy-MM-dd').format(detail.attDate!);
      if (tempGroup[dayKey] == null) {
        tempGroup[dayKey] = [];
      }
      tempGroup[dayKey]!.add(detail);
    }
    // ترتيب الإدخالات داخل كل يوم حسب الوقت
    tempGroup.forEach((day, dayDetails) {
      dayDetails.sort((a, b) => a.attDate!.compareTo(b.attDate!));
    });
    _groupedDetails = tempGroup;
  }

  // ---== دوال جديدة ==---

  Future<void> fetchCheckedAttendanceMonths(int empCode) async {
    _isLoadingCheckedMonths = true;
    _checkedMonthsError = null;
    notifyListeners();
    try {
      final url = "${ApiConstants.baseUrl}${ApiConstants.checkedAttendanceMonthsEndpoint}?q=EmpCode=$empCode";
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        _checkedMonths = CheckedAttendanceMonthList.fromJson(data).items;
      } else {
        _checkedMonths = [];
      }
    } catch (e) {
      _checkedMonthsError = "فشل تحميل الشهور المعتمدة: ${e.toString()}";
    } finally {
      _isLoadingCheckedMonths = false;
      notifyListeners();
    }
  }

  Future<void> fetchCheckedMonthDetails(String url) async {
    _isLoadingCheckedDetails = true;
    _checkedDetailsError = null;
    _checkedDetails = [];
    notifyListeners();
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null) {
        final detailList = CheckedAttendanceDetailList.fromJson(data);
        // البيانات هنا لا تحتاج تجميع، فقط ترتيب حسب التاريخ
        detailList.items.sort((a, b) => a.taDate!.compareTo(b.taDate!));
        _checkedDetails = detailList.items;
      }
    } catch (e) {
      _checkedDetailsError = "فشل تحميل تفاصيل الحضور المعتمدة: ${e.toString()}";
    } finally {
      _isLoadingCheckedDetails = false;
      notifyListeners();
    }
  }

  // جلب موقع الشركة
  Future<void> fetchCompanyLocation(int usersCode) async {
    final url = "${ApiConstants.baseUrl}${ApiConstants.userTransactionsInfoEndpoint}?q=UsersCode=$usersCode";
    try {
      final data = await _dataFetchService.fetchDataFromUrl(url);
      if (data != null && data['items'] != null && (data['items'] as List).isNotEmpty) {
        final firstItem = data['items'][0];
        if (firstItem['Lat'] != null && firstItem['Lon'] != null) {
          _companyLocationInfo = NotificationInfo.fromJson(firstItem);
        } else {
          _companyLocationInfo = null;
        }
        notifyListeners();
      }
    } catch (e) {
      _error = "فشل تحميل موقع الشركة: $e";
      notifyListeners();
    }
  }

  // الدالة الرئيسية لتسجيل الحضور والانصراف
  Future<bool> performCheckInOut({
    required String attType,
    required int empCode,
    required int compEmpCode,
  }) async {
    _isActionInProgress = true;
    _actionError = null;
    notifyListeners();

    try {
      Position currentUserPosition = await getCurrentLocationWithPermissions();

      if (_companyLocationInfo != null && _companyLocationInfo!.lat != null && _companyLocationInfo!.lon != null) {
        LatLng companyLatLng = LatLng(_companyLocationInfo!.lat!, _companyLocationInfo!.lon!);
        LatLng userLatLng = LatLng(currentUserPosition.latitude, currentUserPosition.longitude);

        Geodesy geodesy = Geodesy();
        num distance = geodesy.distanceBetweenTwoGeoPoints(userLatLng, companyLatLng);
// انا مغير العلامة هنا
        if (distance < 50) {
          throw Exception("أنت خارج النطاق المسموح به (المسافة: ${distance.round()} متر)");
        }
      }

      DateTime now = DateTime.now();
      String altKey = "$empCode-${DateFormat('ddMMyyyyHHmm').format(now)}";
      String formattedDate = "${DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(now)}+03:00";

      final Map<String, dynamic> requestBody = {
        "EmpCode": 789,
        "CompEmpCode": 789,
        "AttDate": formattedDate,
        "AttType": attType,
        "AttMachine": 1,
        "AttTime": formattedDate,
        "AttDatetime": formattedDate,
        "AltKey": altKey,
        "Lat": currentUserPosition.latitude,
        "Lon": currentUserPosition.longitude,
      };

      final response = await http.post(
        Uri.parse(ApiConstants.checkInOutEndpoint),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        throw Exception("فشل الإجراء. رمز الحالة: ${response.statusCode}");
      }

    } catch (e) {
      _actionError = e.toString().replaceFirst("Exception: ", "");
      return false;
    } finally {
      _isActionInProgress = false;
      notifyListeners();
    }
  }

  // تم تغيير الدالة من private إلى public بإزالة الـ underscore
  Future<Position> getCurrentLocationWithPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('خدمات الموقع الجغرافي معطلة.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('تم رفض إذن الوصول للموقع.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('تم رفض إذن الوصول للموقع بشكل دائم.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}