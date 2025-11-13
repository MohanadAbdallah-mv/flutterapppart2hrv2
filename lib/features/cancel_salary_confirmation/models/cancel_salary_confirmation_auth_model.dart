// lib/features/cancel_salary_confirmation/models/cancel_salary_confirmation_auth_model.dart
import 'dart:convert';
import '../../../core/models/purchase_order_model.dart'; // Using the same Link

CancelSalaryConfirmationAuthResponse cancelSalaryConfirmationAuthResponseFromJson(String str) => CancelSalaryConfirmationAuthResponse.fromJson(json.decode(str));

class CancelSalaryConfirmationAuthResponse {
  final List<CancelSalaryConfirmationAuthItem> items;
  CancelSalaryConfirmationAuthResponse({required this.items});

  factory CancelSalaryConfirmationAuthResponse.fromJson(Map<String, dynamic> json) => CancelSalaryConfirmationAuthResponse(
    items: List<CancelSalaryConfirmationAuthItem>.from(json["items"].map((x) => CancelSalaryConfirmationAuthItem.fromJson(x))),
  );
}

class CancelSalaryConfirmationAuthItem {
  final String altKey;
  final String? authDate;
  final int? authFlag;
  final String? authPk1;
  final String? authPk2;
  final String? authPk3; // Key field (will be 1)
  final String? authTableName;
  final int? prevSer;
  final int? usersCode;
  final String? usersDesc;
  final String? usersName;
  final String? usersNameE;
  final String? jobDesc;
  final String? jobDescE;
  final List<Link> links;

  CancelSalaryConfirmationAuthItem({
    required this.altKey,
    this.authDate,
    this.authFlag,
    this.authPk1,
    this.authPk2,
    this.authPk3,
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

  factory CancelSalaryConfirmationAuthItem.fromJson(Map<String, dynamic> json) => CancelSalaryConfirmationAuthItem(
    altKey: json["AltKey"],
    authDate: json["AuthDate"],
    authFlag: json["AuthFlag"],
    authPk1: json["AuthPk1"],
    authPk2: json["AuthPk2"],
    authPk3: json["AuthPk3"],
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