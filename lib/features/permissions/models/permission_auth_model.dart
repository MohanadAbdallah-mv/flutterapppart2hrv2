// lib/features/permissions/models/permission_auth_model.dart
import 'dart:convert';
// ---== تم التصحيح: استخدام نفس مصدر الإجازات ==---
import '../../../core/models/purchase_order_model.dart';

PermissionAuthResponse permissionAuthResponseFromJson(String str) => PermissionAuthResponse.fromJson(json.decode(str));

class PermissionAuthResponse {
  final List<PermissionAuthItem> items;
  PermissionAuthResponse({required this.items});

  factory PermissionAuthResponse.fromJson(Map<String, dynamic> json) => PermissionAuthResponse(
    items: List<PermissionAuthItem>.from(json["items"].map((x) => PermissionAuthItem.fromJson(x))),
  );
}

class PermissionAuthItem {
  final String altKey;
  final String? authDate;
  final int? authFlag;
  final String? authPk1;
  final String? authPk2;
  final String? authTableName;
  final int? prevSer;
  final int? usersCode;
  final String? usersDesc;
  final String? usersName;
  final String? usersNameE;
  final String? jobDesc;
  final String? jobDescE;
  final List<Link> links;

  PermissionAuthItem({
    required this.altKey,
    this.authDate,
    this.authFlag,
    this.authPk1,
    this.authPk2,
    this.authTableName,
    this.prevSer,
    this.usersCode,
    this.usersDesc,
    this.usersName,
    this.usersNameE,
    this.jobDesc,
    this.jobDescE,
    required this.links,
  });

  factory PermissionAuthItem.fromJson(Map<String, dynamic> json) => PermissionAuthItem(
    altKey: json["AltKey"],
    authDate: json["AuthDate"],
    authFlag: json["AuthFlag"],
    authPk1: json["AuthPk1"],
    authPk2: json["AuthPk2"],
    authTableName: json["AuthTableName"],
    prevSer: json["PrevSer"],
    usersCode: json["UsersCode"],
    usersDesc: json["UsersDesc"],
    usersName: json["UsersName"],
    usersNameE: json["UsersNameE"],
    jobDesc: json["JobDesc"],
    jobDescE: json["JobDescE"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );
}