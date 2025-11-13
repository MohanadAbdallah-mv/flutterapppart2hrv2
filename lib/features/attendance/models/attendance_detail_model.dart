/*
// features/attendance/models/attendance_detail_model.dart
import 'dart:convert';

AttendanceDetailList attendanceDetailListFromJson(String str) => AttendanceDetailList.fromJson(json.decode(str));

class AttendanceDetailList {
  final List<AttendanceDetailItem> items;
  AttendanceDetailList({ required this.items });

  factory AttendanceDetailList.fromJson(Map<String, dynamic> json) => AttendanceDetailList(
    items: List<AttendanceDetailItem>.from(json["items"].map((x) => AttendanceDetailItem.fromJson(x))),
  );
}

class AttendanceDetailItem {
  final int empCode;
  final DateTime? attDate;
  final String attType; // "I" for In, "O" for Out

  AttendanceDetailItem({
    required this.empCode,
    this.attDate,
    required this.attType,
  });

  factory AttendanceDetailItem.fromJson(Map<String, dynamic> json) => AttendanceDetailItem(
    empCode: json["EmpCode"],
    attDate: json["AttDate"] == null ? null : DateTime.parse(json["AttDate"]),
    attType: json["AttType"],
  );
}
*/


// features/attendance/models/attendance_detail_model.dart
// features/attendance/models/attendance_detail_model.dart
// features/attendance/models/attendance_detail_model.dart
// features/attendance/models/attendance_detail_model.dart
import 'dart:convert';

AttendanceDetailList attendanceDetailListFromJson(String str) => AttendanceDetailList.fromJson(json.decode(str));

class AttendanceDetailList {
  final List<AttendanceDetailItem> items;
  AttendanceDetailList({ required this.items });

  factory AttendanceDetailList.fromJson(Map<String, dynamic> json) => AttendanceDetailList(
    items: List<AttendanceDetailItem>.from(json["items"].map((x) => AttendanceDetailItem.fromJson(x))),
  );
}

class AttendanceDetailItem {
  final int empCode;
  final DateTime? attDate;
  final String attType; // "I" for In, "O" for Out

  AttendanceDetailItem({
    required this.empCode,
    this.attDate,
    required this.attType,
  });

  factory AttendanceDetailItem.fromJson(Map<String, dynamic> json) => AttendanceDetailItem(
    empCode: json["EmpCode"],
    // الحل الصحيح: استخراج التاريخ والوقت مباشرة من النص بدون تحويل timezone
    attDate: json["AttDate"] == null ? null : _parseWithoutTimezone(json["AttDate"]),
    attType: json["AttType"],
  );

  // دالة مساعدة لاستخراج التاريخ والوقت بدون تحويل timezone
  static DateTime? _parseWithoutTimezone(String dateStr) {
    if (dateStr.isEmpty) return null;

    // إزالة معرف المنطقة الزمنية من النص
    String cleanDateStr = dateStr.replaceAll(RegExp(r'[+-]\d{2}:\d{2}$'), '');

  // تحويل النص إلى DateTime محلي مباشرة
  return DateTime.parse(cleanDateStr);
}
}