// features/attendance/models/checked_attendance_month_model.dart
import 'dart:convert';

import '../../../core/models/purchase_order_model.dart';

CheckedAttendanceMonthList checkedAttendanceMonthListFromJson(String str) => CheckedAttendanceMonthList.fromJson(json.decode(str));

class CheckedAttendanceMonthList {
  final List<CheckedAttendanceMonthItem> items;
  CheckedAttendanceMonthList({ required this.items });

  factory CheckedAttendanceMonthList.fromJson(Map<String, dynamic> json) => CheckedAttendanceMonthList(
    items: List<CheckedAttendanceMonthItem>.from(json["items"].map((x) => CheckedAttendanceMonthItem.fromJson(x))),
  );
}

class CheckedAttendanceMonthItem {
  final int empCode;
  final String yearMonth;
  final String altKey;
  final List<Link> links;

  CheckedAttendanceMonthItem({
    required this.empCode,
    required this.yearMonth,
    required this.altKey,
    required this.links,
  });

  factory CheckedAttendanceMonthItem.fromJson(Map<String, dynamic> json) => CheckedAttendanceMonthItem(
    empCode: json["EmpCode"],
    yearMonth: json["YearMonth"],
    altKey: json["AltKey"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );

  String? getDetailLink() {
    try {
      return links.firstWhere((link) => link.name == "TaEmpSheetDetVRO").href;
    } catch (e) {
      return null;
    }
  }
}