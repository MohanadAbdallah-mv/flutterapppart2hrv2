// lib/features/cancel_salary_confirmation/models/my_cancel_salary_confirmation_request_model.dart
import 'dart:convert';
import '../../../core/models/purchase_order_model.dart'; // Using the same Link

MyCancelSalaryConfirmationRequestList myCancelSalaryConfirmationRequestListFromJson(String str) => MyCancelSalaryConfirmationRequestList.fromJson(json.decode(str));

class MyCancelSalaryConfirmationRequestList {
  final List<MyCancelSalaryConfirmationRequestItem> items;
  MyCancelSalaryConfirmationRequestList({required this.items});

  factory MyCancelSalaryConfirmationRequestList.fromJson(Map<String, dynamic> json) => MyCancelSalaryConfirmationRequestList(
    items: List<MyCancelSalaryConfirmationRequestItem>.from(json["items"].map((x) => MyCancelSalaryConfirmationRequestItem.fromJson(x))),
  );
}

class MyCancelSalaryConfirmationRequestItem {
  final int empCode;
  final int serial;
  final int typeFlag; // Key field (will be 1)
  final int? compEmpCode;
  final String? trnsDate;
  final String? notes;
  final int? dCode;
  final int? aproveFlag;
  final String altKey;
  final int? insertUser;
  final List<Link> links;

  MyCancelSalaryConfirmationRequestItem({
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

  factory MyCancelSalaryConfirmationRequestItem.fromJson(Map<String, dynamic> json) => MyCancelSalaryConfirmationRequestItem(
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