// features/attendance/models/checked_attendance_detail_model.dart
/*
import 'dart:convert';

CheckedAttendanceDetailList checkedAttendanceDetailListFromJson(String str) => CheckedAttendanceDetailList.fromJson(json.decode(str));

class CheckedAttendanceDetailList {
  final List<CheckedAttendanceDetailItem> items;
  CheckedAttendanceDetailList({ required this.items });

  factory CheckedAttendanceDetailList.fromJson(Map<String, dynamic> json) => CheckedAttendanceDetailList(
    items: List<CheckedAttendanceDetailItem>.from(json["items"].map((x) => CheckedAttendanceDetailItem.fromJson(x))),
  );
}

class CheckedAttendanceDetailItem {
  final DateTime? taDate;
  final String? taDay;
  final DateTime? revIn;
  final DateTime? revOut;
  final int vcncFlag;
  final int abscFlag;
  final int weekendFlag;
  final num taLateMins;
  final num taOvtmMins;

  CheckedAttendanceDetailItem({
    this.taDate,
    this.taDay,
    this.revIn,
    this.revOut,
    required this.vcncFlag,
    required this.abscFlag,
    required this.weekendFlag,
    required this.taLateMins,
    required this.taOvtmMins,
  });

  factory CheckedAttendanceDetailItem.fromJson(Map<String, dynamic> json) => CheckedAttendanceDetailItem(
    taDate: json["TaDate"] == null ? null : DateTime.parse(json["TaDate"]),
    taDay: json["TaDay"],
    revIn: json["RevIn"] == null ? null : DateTime.parse(json["RevIn"]),
    revOut: json["RevOut"] == null ? null : DateTime.parse(json["RevOut"]),
    vcncFlag: json["VcncFlag"],
    abscFlag: json["AbscFlag"],
    weekendFlag: json["WeekendFlag"],
    taLateMins: json["TaLateMins"] as num,
    taOvtmMins: json["TaOvtmMins"] as num,
  );
}*/
// features/attendance/models/checked_attendance_detail_model.dart
// features/attendance/models/checked_attendance_detail_model.dart
import 'dart:convert';

CheckedAttendanceDetailList checkedAttendanceDetailListFromJson(String str) => CheckedAttendanceDetailList.fromJson(json.decode(str));

class CheckedAttendanceDetailList {
  final List<CheckedAttendanceDetailItem> items;
  CheckedAttendanceDetailList({ required this.items });

  factory CheckedAttendanceDetailList.fromJson(Map<String, dynamic> json) => CheckedAttendanceDetailList(
    items: List<CheckedAttendanceDetailItem>.from(json["items"].map((x) => CheckedAttendanceDetailItem.fromJson(x))),
  );
}

class CheckedAttendanceDetailItem {
  final DateTime? taDate;
  final String? taDay;
  final DateTime? revIn;
  final DateTime? revOut;
  final int vcncFlag;
  final int abscFlag;
  final int weekendFlag;
  final num taLateMins;
  final num taOvtmMins;

  CheckedAttendanceDetailItem({
    this.taDate,
    this.taDay,
    this.revIn,
    this.revOut,
    required this.vcncFlag,
    required this.abscFlag,
    required this.weekendFlag,
    required this.taLateMins,
    required this.taOvtmMins,
  });

  factory CheckedAttendanceDetailItem.fromJson(Map<String, dynamic> json) => CheckedAttendanceDetailItem(
    // الحل الصحيح: استخراج جميع التواريخ والأوقات بدون تحويل timezone
    taDate: json["TaDate"] == null ? null : _parseWithoutTimezone(json["TaDate"]),
    taDay: json["TaDay"],
    revIn: json["RevIn"] == null ? null : _parseWithoutTimezone(json["RevIn"]),
    revOut: json["RevOut"] == null ? null : _parseWithoutTimezone(json["RevOut"]),
    vcncFlag: json["VcncFlag"],
    abscFlag: json["AbscFlag"],
    weekendFlag: json["WeekendFlag"],
    taLateMins: json["TaLateMins"] as num,
    taOvtmMins: json["TaOvtmMins"] as num,
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