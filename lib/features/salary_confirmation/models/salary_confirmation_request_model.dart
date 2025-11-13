// lib/features/salary_confirmation/models/salary_confirmation_request_model.dart
import 'dart:convert';
import '../../../core/models/purchase_order_model.dart'; // Using the same Link

SalaryConfirmationRequestList salaryConfirmationRequestListFromJson(String str) => SalaryConfirmationRequestList.fromJson(json.decode(str));

class SalaryConfirmationRequestList {
  final List<SalaryConfirmationRequestItem> items;
  SalaryConfirmationRequestList({required this.items});

  factory SalaryConfirmationRequestList.fromJson(Map<String, dynamic> json) => SalaryConfirmationRequestList(
    items: List<SalaryConfirmationRequestItem>.from(json["items"].map((x) => SalaryConfirmationRequestItem.fromJson(x))),
  );
}

class SalaryConfirmationRequestItem {
  final int empCode;
  final int serial;
  final int? compEmpCode;
  final String? trnsDate;
  final int typeFlag; // Key field
  final int? aproveFlag;
  final String? notes;
  final int? insertUser;
  final String altKey;
  final int? prevSer;
  final String? empName;
  final String? empNameE;
  final int? usersCode;
  final List<Link> links;

  SalaryConfirmationRequestItem({
    required this.empCode,
    required this.serial,
    this.compEmpCode,
    this.trnsDate,
    required this.typeFlag,
    this.aproveFlag,
    this.notes,
    this.insertUser,
    required this.altKey,
    this.prevSer,
    this.empName,
    this.empNameE,
    this.usersCode,
    required this.links,
  });

  factory SalaryConfirmationRequestItem.fromJson(Map<String, dynamic> json) => SalaryConfirmationRequestItem(
    empCode: json["EmpCode"],
    serial: json["Serial"],
    compEmpCode: json["CompEmpCode"],
    trnsDate: json["TrnsDate"],
    typeFlag: json["TypeFlag"],
    aproveFlag: json["AproveFlag"],
    notes: json["Notes"],
    insertUser: json["InsertUser"],
    altKey: json["AltKey"],
    prevSer: json["PrevSer"],
    empName: json["EmpName"],
    empNameE: json["EmpNameE"],
    usersCode: json["UsersCode"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );
}