// lib/features/salary_confirmation/models/salary_confirmation_auth_model.dart
import 'dart:convert';
import '../../../core/models/purchase_order_model.dart'; // Using the same Link

SalaryConfirmationAuthResponse salaryConfirmationAuthResponseFromJson(String str) => SalaryConfirmationAuthResponse.fromJson(json.decode(str));

class SalaryConfirmationAuthResponse {
  final List<SalaryConfirmationAuthItem> items;
  SalaryConfirmationAuthResponse({required this.items});

  factory SalaryConfirmationAuthResponse.fromJson(Map<String, dynamic> json) => SalaryConfirmationAuthResponse(
    items: List<SalaryConfirmationAuthItem>.from(json["items"].map((x) => SalaryConfirmationAuthItem.fromJson(x))),
  );
}

class SalaryConfirmationAuthItem {
  final String altKey;
  final String? authDate;
  final int? authFlag;
  final String? authPk1;
  final String? authPk2;
  final String? authPk3; // New field
  final String? authTableName;
  final int? prevSer;
  final int? usersCode;
  final String? usersDesc;
  final String? usersName;
  final String? usersNameE;
  final String? jobDesc;
  final String? jobDescE;
  final List<Link> links;

  SalaryConfirmationAuthItem({
    required this.altKey,
    this.authDate,
    this.authFlag,
    this.authPk1,
    this.authPk2,
    this.authPk3, // New field
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

  factory SalaryConfirmationAuthItem.fromJson(Map<String, dynamic> json) => SalaryConfirmationAuthItem(
    altKey: json["AltKey"],
    authDate: json["AuthDate"],
    authFlag: json["AuthFlag"],
    authPk1: json["AuthPk1"],
    authPk2: json["AuthPk2"],
    authPk3: json["AuthPk3"], // New field
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