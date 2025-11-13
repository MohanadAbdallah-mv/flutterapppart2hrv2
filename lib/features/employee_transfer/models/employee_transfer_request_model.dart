// lib/features/employee_transfer/models/employee_transfer_request_model.dart
import 'dart:convert';
import '../../../core/models/purchase_order_model.dart'; // Using the same Link

EmployeeTransferRequestList employeeTransferRequestListFromJson(String str) => EmployeeTransferRequestList.fromJson(json.decode(str));

class EmployeeTransferRequestList {
  final List<EmployeeTransferRequestItem> items;
  EmployeeTransferRequestList({required this.items});

  factory EmployeeTransferRequestList.fromJson(Map<String, dynamic> json) => EmployeeTransferRequestList(
    items: List<EmployeeTransferRequestItem>.from(json["items"].map((x) => EmployeeTransferRequestItem.fromJson(x))),
  );
}

class EmployeeTransferRequestItem {
  final int empCode;
  final int serialPym; // Key change
  final int? compEmpCodeNew;
  final String? movingDate;
  final int? companyCodeNew;
  final int? dCodeNew;
  final int? month;
  final int? year;
  final int? agreeFlag; // Key change
  final String? movingNote;
  final int? insertUser;
  final String altKey;
  final int? prevSer;
  final String? empName;
  final String? empNameE;
  final int? usersCode;
  final List<Link> links;

  EmployeeTransferRequestItem({
    required this.empCode,
    required this.serialPym,
    this.compEmpCodeNew,
    this.movingDate,
    this.companyCodeNew,
    this.dCodeNew,
    this.month,
    this.year,
    this.agreeFlag,
    this.movingNote,
    this.insertUser,
    required this.altKey,
    this.prevSer,
    this.empName,
    this.empNameE,
    this.usersCode,
    required this.links,
  });

  factory EmployeeTransferRequestItem.fromJson(Map<String, dynamic> json) => EmployeeTransferRequestItem(
    empCode: json["EmpCode"],
    serialPym: json["SerialPym"],
    compEmpCodeNew: json["CompEmpCodeNew"],
    movingDate: json["MovingDate"],
    companyCodeNew: json["CompanyCodeNew"],
    dCodeNew: json["DCodeNew"],
    month: json["Month"],
    year: json["Year"],
    agreeFlag: json["AgreeFlag"],
    movingNote: json["MovingNote"],
    insertUser: json["InsertUser"],
    altKey: json["AltKey"],
    prevSer: json["PrevSer"],
    empName: json["EmpName"],
    empNameE: json["EmpNameE"],
    usersCode: json["UsersCode"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );
}