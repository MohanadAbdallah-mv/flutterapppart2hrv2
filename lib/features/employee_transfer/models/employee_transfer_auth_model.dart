// lib/features/employee_transfer/models/employee_transfer_auth_model.dart
import 'dart:convert';
import '../../../core/models/purchase_order_model.dart'; // Using the same Link

EmployeeTransferAuthResponse employeeTransferAuthResponseFromJson(String str) => EmployeeTransferAuthResponse.fromJson(json.decode(str));

class EmployeeTransferAuthResponse {
  final List<EmployeeTransferAuthItem> items;
  EmployeeTransferAuthResponse({required this.items});

  factory EmployeeTransferAuthResponse.fromJson(Map<String, dynamic> json) => EmployeeTransferAuthResponse(
    items: List<EmployeeTransferAuthItem>.from(json["items"].map((x) => EmployeeTransferAuthItem.fromJson(x))),
  );
}

class EmployeeTransferAuthItem {
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

  EmployeeTransferAuthItem({
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

  factory EmployeeTransferAuthItem.fromJson(Map<String, dynamic> json) => EmployeeTransferAuthItem(
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