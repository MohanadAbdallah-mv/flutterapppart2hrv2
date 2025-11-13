// lib/features/car_movement/models/car_movement_request_model.dart
import 'dart:convert';
import '../../../core/models/purchase_order_model.dart'; // Using the same Link

CarMovementRequestList carMovementRequestListFromJson(String str) => CarMovementRequestList.fromJson(json.decode(str));

class CarMovementRequestList {
  final List<CarMovementRequestItem> items;
  CarMovementRequestList({required this.items});

  factory CarMovementRequestList.fromJson(Map<String, dynamic> json) => CarMovementRequestList(
    items: List<CarMovementRequestItem>.from(json["items"].map((x) => CarMovementRequestItem.fromJson(x))),
  );
}

class CarMovementRequestItem {
  final int empCode;
  final int serial;
  final int? compEmpCode;
  final String? trnsDate;
  final int? trnsType;
  final String? prmDate;
  final String? fromTime;
  final String? toTime;
  final int? aproveFlag;
  final String? permReasons;
  final int? insertUser;
  final String altKey;
  final String? notes;
  final String? carNo; // New field
  final int? prevSer;
  final String? empName;
  final String? empNameE;
  final int? usersCode;
  final List<Link> links;

  CarMovementRequestItem({
    required this.empCode,
    required this.serial,
    this.compEmpCode,
    this.trnsDate,
    this.trnsType,
    this.prmDate,
    this.fromTime,
    this.toTime,
    this.aproveFlag,
    this.permReasons,
    this.insertUser,
    required this.altKey,
    this.notes,
    this.carNo,
    this.prevSer,
    this.empName,
    this.empNameE,
    this.usersCode,
    required this.links,
  });

  factory CarMovementRequestItem.fromJson(Map<String, dynamic> json) => CarMovementRequestItem(
    empCode: json["EmpCode"],
    serial: json["Serial"],
    compEmpCode: json["CompEmpCode"],
    trnsDate: json["TrnsDate"],
    trnsType: json["TrnsType"],
    prmDate: json["PrmDate"],
    fromTime: json["FromTime"],
    toTime: json["ToTime"],
    aproveFlag: json["AproveFlag"],
    permReasons: json["PermReasons"],
    insertUser: json["InsertUser"],
    altKey: json["AltKey"],
    notes: json["Notes"],
    carNo: json["CarNo"], // New field
    prevSer: json["PrevSer"],
    empName: json["EmpName"],
    empNameE: json["EmpNameE"],
    usersCode: json["UsersCode"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );
}