import 'dart:convert';

import 'package:flutterapppart2hr/core/models/purchase_order_model.dart';

VacationRequestList vacationRequestListFromJson(String str) => VacationRequestList.fromJson(json.decode(str));

class VacationRequestList {
  final List<VacationRequestItem> items;
  VacationRequestList({required this.items});

  factory VacationRequestList.fromJson(Map<String, dynamic> json) => VacationRequestList(
    items: List<VacationRequestItem>.from(json["items"].map((x) => VacationRequestItem.fromJson(x))),
  );
}

class VacationRequestItem {
  final int empCode;
  final int serialPyv;
  final String? trnsDate;
  final int? trnsType;
  final String? startDt;
  final String? endDt;
  final int? period;
  final String? notes;
  final String altKey;
  final String? empName;
  final String? empNameE;
  final List<Link> links;

  VacationRequestItem({
    required this.empCode,
    required this.serialPyv,
    this.trnsDate,
    this.trnsType,
    this.startDt,
    this.endDt,
    this.period,
    this.notes,
    required this.altKey,
    this.empName,
    this.empNameE,
    required this.links,
  });

  factory VacationRequestItem.fromJson(Map<String, dynamic> json) => VacationRequestItem(
    empCode: json["EmpCode"],
    serialPyv: json["SerialPyv"],
    trnsDate: json["TrnsDate"],
    trnsType: json["TrnsType"],
    startDt: json["StartDt"],
    endDt: json["EndDt"],
    period: json["Period"],
    notes: json["Notes"],
    altKey: json["AltKey"],
    empName: json["EmpName"],
    empNameE: json["EmpNameE"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );

  String get vacationTypeString {
    switch (trnsType) {
      case 12: return 'سنوية';
      case 1: return 'عادية';
      case 2: return 'بدون راتب';

      default: return 'لا';
    }
  }
  String get vacationTypeStringE {
    switch (trnsType) {
      case 12: return 'Annual';
      case 1: return 'Normal';
      case 2: return 'No Salary';
      default: return 'No';
    }
  }

  String? getLink(String name) {
    try {
      return links.firstWhere((link) => link.name == name).href;
    } catch (e) {
      return null;
    }
  }
}

