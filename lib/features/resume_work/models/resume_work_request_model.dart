// lib/features/resume_work/models/resume_work_request_model.dart
import 'dart:convert';
import '../../../core/models/purchase_order_model.dart'; // Using the same Link

ResumeWorkRequestList resumeWorkRequestListFromJson(String str) => ResumeWorkRequestList.fromJson(json.decode(str));

class ResumeWorkRequestList {
  final List<ResumeWorkRequestItem> items;
  ResumeWorkRequestList({required this.items});

  factory ResumeWorkRequestList.fromJson(Map<String, dynamic> json) => ResumeWorkRequestList(
    items: List<ResumeWorkRequestItem>.from(json["items"].map((x) => ResumeWorkRequestItem.fromJson(x))),
  );
}

class ResumeWorkRequestItem {
  final int empCode;
  final int serialPyv; // Key change
  final int? compEmpCode;
  final String? fDate;
  final String? tDate;
  final String? actTDate;
  final int? actPeriod;
  final int? aproveFlag;
  final String? lateReason;
  final int? insertUser;
  final String altKey;
  final int? prevSer;
  final String? empName;
  final String? empNameE;
  final int? usersCode;
  final List<Link> links;

  ResumeWorkRequestItem({
    required this.empCode,
    required this.serialPyv,
    this.compEmpCode,
    this.fDate,
    this.tDate,
    this.actTDate,
    this.actPeriod,
    this.aproveFlag,
    this.lateReason,
    this.insertUser,
    required this.altKey,
    this.prevSer,
    this.empName,
    this.empNameE,
    this.usersCode,
    required this.links,
  });

  factory ResumeWorkRequestItem.fromJson(Map<String, dynamic> json) => ResumeWorkRequestItem(
    empCode: json["EmpCode"],
    serialPyv: json["SerialPyv"], // Key change
    compEmpCode: json["CompEmpCode"],
    fDate: json["FDate"],
    tDate: json["TDate"],
    actTDate: json["ActTDate"],
    actPeriod: json["ActPeriod"],
    aproveFlag: json["AproveFlag"],
    lateReason: json["LateReason"],
    insertUser: json["InsertUser"],
    altKey: json["AltKey"],
    prevSer: json["PrevSer"],
    empName: json["EmpName"],
    empNameE: json["EmpNameE"],
    usersCode: json["UsersCode"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );
}