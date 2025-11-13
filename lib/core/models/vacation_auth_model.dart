// lib/features/vacations/models/vacation_auth_model.dart

import 'dart:convert';
import 'package:flutterapppart2hr/core/models/purchase_order_model.dart';



VacationAuthResponse vacationAuthResponseFromJson(String str) => VacationAuthResponse.fromJson(json.decode(str));

class VacationAuthResponse {
  final List<VacationAuthItem> items;
  VacationAuthResponse({required this.items});

  factory VacationAuthResponse.fromJson(Map<String, dynamic> json) => VacationAuthResponse(
    items: List<VacationAuthItem>.from(json["items"].map((x) => VacationAuthItem.fromJson(x))),
  );
}

class VacationAuthItem {
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

  VacationAuthItem({
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

  factory VacationAuthItem.fromJson(Map<String, dynamic> json) => VacationAuthItem(
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