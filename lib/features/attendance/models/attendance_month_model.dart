// features/attendance/models/attendance_month_model.dart

import 'dart:convert';

import '../../../core/models/purchase_order_model.dart';

AttendanceMonthList attendanceMonthListFromJson(String str) => AttendanceMonthList.fromJson(json.decode(str));

class AttendanceMonthList {
  final List<AttendanceMonthItem> items;
  AttendanceMonthList({ required this.items });

  factory AttendanceMonthList.fromJson(Map<String, dynamic> json) => AttendanceMonthList(
    items: List<AttendanceMonthItem>.from(json["items"].map((x) => AttendanceMonthItem.fromJson(x))),
  );
}

class AttendanceMonthItem {
  final int empCode;
  final String yearMonth;
  final String altKey;
  final List<Link> links;

  AttendanceMonthItem({
    required this.empCode,
    required this.yearMonth,
    required this.altKey,
    required this.links,
  });

  factory AttendanceMonthItem.fromJson(Map<String, dynamic> json) => AttendanceMonthItem(
    empCode: json["EmpCode"],
    yearMonth: json["YearMonth"],
    altKey: json["AltKey"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );

  // دالة مساعدة لجلب الرابط المطلوب
  String? getDetailLink() {
    try {
      return links.firstWhere((link) => link.name == "TaEmpSheetDummyDetVRO").href;
    } catch (e) {
      return null;
    }
  }
}




