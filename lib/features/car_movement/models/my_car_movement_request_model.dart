// lib/features/car_movement/models/my_car_movement_request_model.dart
import 'dart:convert';
import '../../../core/models/purchase_order_model.dart'; // Using the same Link

MyCarMovementRequestList myCarMovementRequestListFromJson(String str) => MyCarMovementRequestList.fromJson(json.decode(str));

class MyCarMovementRequestList {
  final List<MyCarMovementRequestItem> items;
  MyCarMovementRequestList({required this.items});

  factory MyCarMovementRequestList.fromJson(Map<String, dynamic> json) => MyCarMovementRequestList(
    items: List<MyCarMovementRequestItem>.from(json["items"].map((x) => MyCarMovementRequestItem.fromJson(x))),
  );
}

class MyCarMovementRequestItem {
  final int empCode;
  final int serial;
  final String? carNo; // New field
  final int? compEmpCode;
  final String? trnsDate;
  final int? trnsType;
  final String? prmDate;
  final String? fromTime;
  final String? toTime;
  final int? aproveFlag;
  final int? reasonType;
  final String? permReasons;
  final String? notes;
  final int? insertUser;
  final String altKey;
  final List<Link> links;

  MyCarMovementRequestItem({
    required this.empCode,
    required this.serial,
    this.carNo,
    this.compEmpCode,
    this.trnsDate,
    this.trnsType,
    this.prmDate,
    this.fromTime,
    this.toTime,
    this.aproveFlag,
    this.reasonType,
    this.permReasons,
    this.notes,
    this.insertUser,
    required this.altKey,
    required this.links,
  });

  factory MyCarMovementRequestItem.fromJson(Map<String, dynamic> json) => MyCarMovementRequestItem(
    empCode: json["EmpCode"],
    serial: json["Serial"],
    carNo: json["CarNo"], // New field
    compEmpCode: json["CompEmpCode"],
    trnsDate: json["TrnsDate"],
    trnsType: json["TrnsType"],
    prmDate: json["PrmDate"],
    fromTime: json["FromTime"],
    toTime: json["ToTime"],
    aproveFlag: json["AproveFlag"],
    reasonType: json["ReasonType"],
    permReasons: json["PermReasons"],
    notes: json["Notes"],
    insertUser: json["InsertUser"],
    altKey: json["AltKey"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );
}