// lib/features/resume_work/models/resume_work_auth_model.dart
import 'dart:convert';
import '../../../core/models/purchase_order_model.dart'; // Using the same Link

ResumeWorkAuthResponse resumeWorkAuthResponseFromJson(String str) => ResumeWorkAuthResponse.fromJson(json.decode(str));

class ResumeWorkAuthResponse {
  final List<ResumeWorkAuthItem> items;
  ResumeWorkAuthResponse({required this.items});

  factory ResumeWorkAuthResponse.fromJson(Map<String, dynamic> json) => ResumeWorkAuthResponse(
    items: List<ResumeWorkAuthItem>.from(json["items"].map((x) => ResumeWorkAuthItem.fromJson(x))),
  );
}

class ResumeWorkAuthItem {
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

  ResumeWorkAuthItem({
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

  factory ResumeWorkAuthItem.fromJson(Map<String, dynamic> json) => ResumeWorkAuthItem(
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