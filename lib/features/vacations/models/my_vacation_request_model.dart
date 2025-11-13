// features/vacations/models/my_permissions_request_model.dart
import 'dart:convert';

import '../../../core/models/purchase_order_model.dart';

MyVacationRequestList myVacationRequestListFromJson(String str) => MyVacationRequestList.fromJson(json.decode(str));

class MyVacationRequestList {
  final List<MyVacationRequestItem> items;
  MyVacationRequestList({required this.items});

  factory MyVacationRequestList.fromJson(Map<String, dynamic> json) => MyVacationRequestList(
    items: List<MyVacationRequestItem>.from(json["items"].map((x) => MyVacationRequestItem.fromJson(x))),
  );
}

class MyVacationRequestItem {
  final int empCode;
  final int serialPyv;
  final String? trnsDate;
  final int? trnsType;
  final String? startDt;
  final String? endDt;
  final int? period;
  final int? agreeFlag;
  final String? notes;
  final String altKey;
  final List<Link> links;

  MyVacationRequestItem({
    required this.empCode,
    required this.serialPyv,
    this.trnsDate,
    this.trnsType,
    this.startDt,
    this.endDt,
    this.period,
    this.agreeFlag,
    this.notes,
    required this.altKey,
    required this.links,
  });

  factory MyVacationRequestItem.fromJson(Map<String, dynamic> json) => MyVacationRequestItem(
    empCode: json["EmpCode"],
    serialPyv: json["SerialPyv"],
    trnsDate: json["TrnsDate"],
    trnsType: json["TrnsType"],
    startDt: json["StartDt"],
    endDt: json["EndDt"],
    period: json["Period"],
    agreeFlag: json["AgreeFlag"],
    notes: json["Notes"],
    altKey: json["AltKey"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );

  String? getLink(String name) {
    try {
      return links.firstWhere((link) => link.name == name).href;
    } catch (e) {
      return null;
    }
  }
}