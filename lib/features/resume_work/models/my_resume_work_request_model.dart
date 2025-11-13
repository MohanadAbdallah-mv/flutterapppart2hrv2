// lib/features/resume_work/models/my_resume_work_request_model.dart
import 'dart:convert';
import '../../../core/models/purchase_order_model.dart'; // Using the same Link as permissions/vacations

MyResumeWorkRequestList myResumeWorkRequestListFromJson(String str) => MyResumeWorkRequestList.fromJson(json.decode(str));

class MyResumeWorkRequestList {
  final List<MyResumeWorkRequestItem> items;
  MyResumeWorkRequestList({required this.items});

  factory MyResumeWorkRequestList.fromJson(Map<String, dynamic> json) => MyResumeWorkRequestList(
    items: List<MyResumeWorkRequestItem>.from(json["items"].map((x) => MyResumeWorkRequestItem.fromJson(x))),
  );
}

class MyResumeWorkRequestItem {
  final int empCode;
  final int serialPyv; // Key change
  final int? compEmpCode;
  final String? fDate;
  final String? tDate;
  final String? actTDate;
  final int? actPeriod;
  final String? lateReason;
  final int? aproveFlag;
  final int? insertUser;
  final int? companyCode;
  final int? dCode;
  final String? notes;
  final String altKey;
  final List<Link> links;

  MyResumeWorkRequestItem({
    required this.empCode,
    required this.serialPyv,
    this.compEmpCode,
    this.fDate,
    this.tDate,
    this.actTDate,
    this.actPeriod,
    this.lateReason,
    this.aproveFlag,
    this.insertUser,
    this.companyCode,
    this.dCode,
    this.notes,
    required this.altKey,
    required this.links,
  });

  factory MyResumeWorkRequestItem.fromJson(Map<String, dynamic> json) => MyResumeWorkRequestItem(
    empCode: json["EmpCode"],
    serialPyv: json["SerialPyv"], // Key change
    compEmpCode: json["CompEmpCode"],
    fDate: json["FDate"],
    tDate: json["TDate"],
    actTDate: json["ActTDate"],
    actPeriod: json["ActPeriod"],
    lateReason: json["LateReason"],
    aproveFlag: json["AproveFlag"],
    insertUser: json["InsertUser"],
    companyCode: json["CompanyCode"],
    dCode: json["DCode"],
    notes: json["Notes"],
    altKey: json["AltKey"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );
}