// lib/features/permissions/models/my_permission_request_model.dart
import 'dart:convert';
// ---== تم التصحيح: استخدام نفس مصدر الإجازات ==---
import '../../../core/models/purchase_order_model.dart';

MyPermissionRequestList myPermissionRequestListFromJson(String str) => MyPermissionRequestList.fromJson(json.decode(str));

class MyPermissionRequestList {
  final List<MyPermissionRequestItem> items;
  MyPermissionRequestList({required this.items});

  factory MyPermissionRequestList.fromJson(Map<String, dynamic> json) => MyPermissionRequestList(
    items: List<MyPermissionRequestItem>.from(json["items"].map((x) => MyPermissionRequestItem.fromJson(x))),
  );
}

class MyPermissionRequestItem {
  final int empCode;
  final int serial;
  final String? trnsDate;
  final int? trnsType;
  final String? prmDate;
  final String? fromTime;
  final String? toTime;
  final int? aproveFlag;
  final int? reasonType;
  final String? permReasons;
  final String? notes;
  final int? dCode;
  final int? insertUser;
  final int? dayType;
  final String altKey;
  final List<Link> links;

  MyPermissionRequestItem({
    required this.empCode,
    required this.serial,
    this.trnsDate,
    this.trnsType,
    this.prmDate,
    this.fromTime,
    this.toTime,
    this.aproveFlag,
    this.reasonType,
    this.permReasons,
    this.notes,
    this.dCode,
    this.insertUser,
    this.dayType,
    required this.altKey,
    required this.links,
  });

  factory MyPermissionRequestItem.fromJson(Map<String, dynamic> json) => MyPermissionRequestItem(
    empCode: json["EmpCode"],
    serial: json["Serial"],
    trnsDate: json["TrnsDate"],
    trnsType: json["TrnsType"],
    prmDate: json["PrmDate"],
    fromTime: json["FromTime"],
    toTime: json["ToTime"],
    aproveFlag: json["AproveFlag"],
    reasonType: json["ReasonType"],
    permReasons: json["PermReasons"],
    notes: json["Notes"],
    dCode: json["DCode"],
    insertUser: json["InsertUser"],
    dayType: json["DayType"],
    altKey: json["AltKey"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );
}