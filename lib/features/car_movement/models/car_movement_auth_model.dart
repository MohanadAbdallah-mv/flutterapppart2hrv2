// lib/features/car_movement/models/car_movement_auth_model.dart
import 'dart:convert';
import '../../../core/models/purchase_order_model.dart'; // Using the same Link

CarMovementAuthResponse carMovementAuthResponseFromJson(String str) => CarMovementAuthResponse.fromJson(json.decode(str));

class CarMovementAuthResponse {
  final List<CarMovementAuthItem> items;
  CarMovementAuthResponse({required this.items});

  factory CarMovementAuthResponse.fromJson(Map<String, dynamic> json) => CarMovementAuthResponse(
    items: List<CarMovementAuthItem>.from(json["items"].map((x) => CarMovementAuthItem.fromJson(x))),
  );
}

class CarMovementAuthItem {
  final String altKey;
  final String? authDate;
  final int? authFlag;
  final String? authPk1;
  final String? authPk2;
  final String? authTableName;
  final int? prevSer;
  final int? usersCode;
  final String? usersDesc;
  final String? usersName;
  final String? usersNameE;
  final String? jobDesc;
  final String? jobDescE;
  final List<Link> links;

  CarMovementAuthItem({
    required this.altKey,
    this.authDate,
    this.authFlag,
    this.authPk1,
    this.authPk2,
    this.authTableName,
    this.prevSer,
    this.usersCode,
    this.usersDesc,
    this.usersName,
    this.usersNameE,
    this.jobDesc,
    this.jobDescE,
    required this.links,
  });

  factory CarMovementAuthItem.fromJson(Map<String, dynamic> json) => CarMovementAuthItem(
    altKey: json["AltKey"],
    authDate: json["AuthDate"],
    authFlag: json["AuthFlag"],
    authPk1: json["AuthPk1"],
    authPk2: json["AuthPk2"],
    authTableName: json["AuthTableName"],
    prevSer: json["PrevSer"],
    usersCode: json["UsersCode"],
    usersDesc: json["UsersDesc"],
    usersName: json["UsersName"],
    usersNameE: json["UsersNameE"],
    jobDesc: json["JobDesc"],
    jobDescE: json["JobDescE"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );
}