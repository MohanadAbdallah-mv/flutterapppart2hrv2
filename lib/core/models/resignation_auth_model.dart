// lib/features/resignations/models/resignation_auth_model.dart

import 'dart:convert';

ResignationAuthResponse resignationAuthResponseFromJson(String str) => ResignationAuthResponse.fromJson(json.decode(str));

class ResignationAuthResponse {
  final List<ResignationAuthItem> items;
  ResignationAuthResponse({required this.items});

  factory ResignationAuthResponse.fromJson(Map<String, dynamic> json) => ResignationAuthResponse(
    items: List<ResignationAuthItem>.from(json["items"].map((x) => ResignationAuthItem.fromJson(x))),
  );
}

class ResignationAuthItem {
  final String? authDate;
  final int? authFlag;
  final int? prevSer;
  final String? usersDesc;
  final String? usersName;
  final String? usersNameE;
  final String? jobDesc;
  final String? jobDescE;

  ResignationAuthItem({
    this.authDate,
    this.authFlag,
    this.prevSer,
    this.usersDesc,
    this.usersName,
    this.usersNameE,
    this.jobDesc,
    this.jobDescE,
  });

  factory ResignationAuthItem.fromJson(Map<String, dynamic> json) => ResignationAuthItem(
    authDate: json["AuthDate"],
    authFlag: json["AuthFlag"],
    prevSer: json["PrevSer"],
    usersDesc: json["UsersDesc"],
    usersName: json["UsersName"],
    jobDesc: json["JobDesc"],
    usersNameE: json["UsersNameE"],
    jobDescE: json["JobDescE"],

  );
}