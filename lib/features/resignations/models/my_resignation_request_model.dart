// features/resignations/models/my_resignation_request_model.dart
import 'dart:convert';

import '../../../core/models/purchase_order_model.dart';

MyResignationRequestList myResignationRequestListFromJson(String str) => MyResignationRequestList.fromJson(json.decode(str));

class MyResignationRequestList {
  final List<MyResignationRequestItem> items;
  MyResignationRequestList({required this.items});

  factory MyResignationRequestList.fromJson(Map<String, dynamic> json) => MyResignationRequestList(
    items: List<MyResignationRequestItem>.from(json["items"].map((x) => MyResignationRequestItem.fromJson(x))),
  );
}

class MyResignationRequestItem {
  final String altKey;
  final int? aproveFlag;
  final int empCode;
  final String? endReasons;
  final String? lastWorkDt;
  final String? endDate;
  final String? trnsDate;
  final int serial;
  final List<Link> links;

  MyResignationRequestItem({
    required this.altKey,
    this.aproveFlag,
    required this.empCode,
    this.endReasons,
    this.lastWorkDt,
    this.endDate,
    this.trnsDate,
    required this.serial,
    required this.links,
  });

  factory MyResignationRequestItem.fromJson(Map<String, dynamic> json) => MyResignationRequestItem(
    altKey: json["AltKey"],
    aproveFlag: json["AproveFlag"],
    empCode: json["EmpCode"],
    endReasons: json["EndReasons"],
    lastWorkDt: json["LastWorkDt"],
    endDate: json["EndDate"],
    trnsDate: json["TrnsDate"],
    serial: json["Serial"],
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