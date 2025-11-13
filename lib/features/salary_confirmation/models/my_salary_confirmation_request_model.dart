// lib/features/salary_confirmation/models/my_salary_confirmation_request_model.dart
import 'dart:convert';
import '../../../core/models/purchase_order_model.dart'; // Using the same Link

MySalaryConfirmationRequestList mySalaryConfirmationRequestListFromJson(String str) => MySalaryConfirmationRequestList.fromJson(json.decode(str));

class MySalaryConfirmationRequestList {
  final List<MySalaryConfirmationRequestItem> items;
  MySalaryConfirmationRequestList({required this.items});

  factory MySalaryConfirmationRequestList.fromJson(Map<String, dynamic> json) => MySalaryConfirmationRequestList(
    items: List<MySalaryConfirmationRequestItem>.from(json["items"].map((x) => MySalaryConfirmationRequestItem.fromJson(x))),
  );
}

class MySalaryConfirmationRequestItem {
  final int empCode;
  final int serial;
  final int typeFlag; // Key field
  final int? compEmpCode;
  final String? trnsDate;
  final String? notes;
  final int? dCode;
  final int? aproveFlag;
  final String altKey;
  final int? insertUser;
  final List<Link> links;

  MySalaryConfirmationRequestItem({
    required this.empCode,
    required this.serial,
    required this.typeFlag,
    this.compEmpCode,
    this.trnsDate,
    this.notes,
    this.dCode,
    this.aproveFlag,
    required this.altKey,
    this.insertUser,
    required this.links,
  });

  factory MySalaryConfirmationRequestItem.fromJson(Map<String, dynamic> json) => MySalaryConfirmationRequestItem(
    empCode: json["EmpCode"],
    serial: json["Serial"],
    typeFlag: json["TypeFlag"],
    compEmpCode: json["CompEmpCode"],
    trnsDate: json["TrnsDate"],
    notes: json["Notes"],
    dCode: json["DCode"],
    aproveFlag: json["AproveFlag"],
    altKey: json["AltKey"],
    insertUser: json["InsertUser"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );
}