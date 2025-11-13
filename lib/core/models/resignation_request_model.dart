// lib/features/resignations/models/resignation_request_model.dart

import 'dart:convert';
import 'package:flutterapppart2hr/core/models/purchase_order_model.dart';



ResignationRequestList resignationRequestListFromJson(String str) => ResignationRequestList.fromJson(json.decode(str));

class ResignationRequestList {
  final List<ResignationRequestItem> items;
  ResignationRequestList({required this.items});

  factory ResignationRequestList.fromJson(Map<String, dynamic> json) => ResignationRequestList(
    items: List<ResignationRequestItem>.from(json["items"].map((x) => ResignationRequestItem.fromJson(x))),
  );
}

class ResignationRequestItem {
  final int empCode;
  final int serial;
  final String? trnsDate;
  final String? endDate;
  final String? lastWorkDt;
  final String? endReasons;
  final String altKey;
  final String? empName;
  final String? empNameE;
  final List<Link> links;

  ResignationRequestItem({
    required this.empCode,
    required this.serial,
    this.trnsDate,
    this.endDate,
    this.lastWorkDt,
    this.endReasons,
    required this.altKey,
    this.empName,
    this.empNameE,
    required this.links,
  });

  factory ResignationRequestItem.fromJson(Map<String, dynamic> json) => ResignationRequestItem(
    empCode: json["EmpCode"],
    serial: json["Serial"],
    trnsDate: json["TrnsDate"],
    endDate: json["EndDate"],
    lastWorkDt: json["LastWorkDt"],
    endReasons: json["EndReasons"],
    altKey: json["AltKey"],
    empName: json["EmpName"],
    empNameE: json["EmpNameE"],
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