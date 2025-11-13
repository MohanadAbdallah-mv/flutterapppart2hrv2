// lib/features/cancel_salary_confirmation/models/cancel_salary_confirmation_request_model.dart
import 'dart:convert';
import '../../../core/models/purchase_order_model.dart'; // Using the same Link

CancelSalaryConfirmationRequestList cancelSalaryConfirmationRequestListFromJson(String str) => CancelSalaryConfirmationRequestList.fromJson(json.decode(str));

class CancelSalaryConfirmationRequestList {
  final List<CancelSalaryConfirmationRequestItem> items;
  CancelSalaryConfirmationRequestList({required this.items});

  factory CancelSalaryConfirmationRequestList.fromJson(Map<String, dynamic> json) => CancelSalaryConfirmationRequestList(
    items: List<CancelSalaryConfirmationRequestItem>.from(json["items"].map((x) => CancelSalaryConfirmationRequestItem.fromJson(x))),
  );
}

class CancelSalaryConfirmationRequestItem {
  final int empCode;
  final int serial;
  final int? compEmpCode;
  final String? trnsDate;
  final int typeFlag; // Key field (will be 1)
  final int? aproveFlag;
  final String? notes;
  final int? insertUser;
  final String altKey;
  final int? prevSer;
  final String? empName;
  final String? empNameE;
  final int? usersCode;
  final List<Link> links;

  CancelSalaryConfirmationRequestItem({
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

  factory CancelSalaryConfirmationRequestItem.fromJson(Map<String, dynamic> json) => CancelSalaryConfirmationRequestItem(
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