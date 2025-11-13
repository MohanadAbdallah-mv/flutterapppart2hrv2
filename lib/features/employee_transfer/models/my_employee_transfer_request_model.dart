// lib/features/employee_transfer/models/my_employee_transfer_request_model.dart
import 'dart:convert';
import '../../../core/models/purchase_order_model.dart'; // Using the same Link

MyEmployeeTransferRequestList myEmployeeTransferRequestListFromJson(String str) => MyEmployeeTransferRequestList.fromJson(json.decode(str));

class MyEmployeeTransferRequestList {
  final List<MyEmployeeTransferRequestItem> items;
  MyEmployeeTransferRequestList({required this.items});

  factory MyEmployeeTransferRequestList.fromJson(Map<String, dynamic> json) => MyEmployeeTransferRequestList(
    items: List<MyEmployeeTransferRequestItem>.from(json["items"].map((x) => MyEmployeeTransferRequestItem.fromJson(x))),
  );
}

class MyEmployeeTransferRequestItem {
  final int serialPym; // Key change
  final int empCode;
  final int? companyCodeNew;
  final int? dCodeNew;
  final int? compEmpCodeNew;
  final String? movingDate;
  final int? month;
  final int? year;
  final String? movingNote;
  final String? movingNoteE;
  final int? agreeFlag; // Key change
  final String? altKey;
  final int? insertUser;
  final List<Link> links;

  MyEmployeeTransferRequestItem({
    required this.serialPym,
    required this.empCode,
    this.companyCodeNew,
    this.dCodeNew,
    this.compEmpCodeNew,
    this.movingDate,
    this.month,
    this.year,
    this.movingNote,
    this.movingNoteE,
    this.agreeFlag,
    this.altKey,
    this.insertUser,
    required this.links,
  });

  factory MyEmployeeTransferRequestItem.fromJson(Map<String, dynamic> json) => MyEmployeeTransferRequestItem(
    serialPym: json["SerialPym"],
    empCode: json["EmpCode"],
    companyCodeNew: json["CompanyCodeNew"],
    dCodeNew: json["DCodeNew"],
    compEmpCodeNew: json["CompEmpCodeNew"],
    movingDate: json["MovingDate"],
    month: json["Month"],
    year: json["Year"],
    movingNote: json["MovingNote"],
    movingNoteE: json["MovingNoteE"],
    agreeFlag: json["AgreeFlag"],
    altKey: json["AltKey"],
    insertUser: json["InsertUser"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );
}