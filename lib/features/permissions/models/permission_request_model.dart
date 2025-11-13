// lib/features/permissions/models/permission_request_model.dart
import 'dart:convert';
// ---== تم التصحيح: استخدام نفس مصدر الإجازات ==---
import '../../../core/models/purchase_order_model.dart';

PermissionRequestList permissionRequestListFromJson(String str) => PermissionRequestList.fromJson(json.decode(str));

class PermissionRequestList {
  final List<PermissionRequestItem> items;
  PermissionRequestList({required this.items});

  factory PermissionRequestList.fromJson(Map<String, dynamic> json) => PermissionRequestList(
    items: List<PermissionRequestItem>.from(json["items"].map((x) => PermissionRequestItem.fromJson(x))),
  );
}

class PermissionRequestItem {
  final String altKey;
  final int? aproveFlag;
  final int? compEmpCode;
  final int empCode;
  final String? empName;
  final String? empNameE;
  final String? fromTime;
  final int? insertUser;
  final String? permReasons;
  final int? prevSer;
  final String? prmDate;
  final int serial;
  final String? toTime;
  final String? trnsDate;
  final int? trnsType;
  final int? usersCode;
  final List<Link> links;

  PermissionRequestItem({
    required this.altKey,
    this.aproveFlag,
    this.compEmpCode,
    required this.empCode,
    this.empName,
    this.empNameE,
    this.fromTime,
    this.insertUser,
    this.permReasons,
    this.prevSer,
    this.prmDate,
    required this.serial,
    this.toTime,
    this.trnsDate,
    this.trnsType,
    this.usersCode,
    required this.links,
  });

  factory PermissionRequestItem.fromJson(Map<String, dynamic> json) => PermissionRequestItem(
    altKey: json["AltKey"],
    aproveFlag: json["AprovalFlag"] ?? json["AproveFlag"],
    compEmpCode: json["CompEmpCode"],
    empCode: json["EmpCode"],
    empName: json["EmpName"],
    empNameE: json["EmpNameE"],
    fromTime: json["FromTime"],
    insertUser: json["InsertUser"],
    permReasons: json["PermReasons"],
    prevSer: json["PrevSer"],
    prmDate: json["PrmDate"],
    serial: json["Serial"],
    toTime: json["ToTime"],
    trnsDate: json["TrnsDate"],
    trnsType: json["TrnsType"],
    usersCode: json["UsersCode"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );
}