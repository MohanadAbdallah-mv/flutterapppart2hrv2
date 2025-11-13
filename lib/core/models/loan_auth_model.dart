// lib/features/loans/models/loan_auth_model.dart

import 'dart:convert';


LoanAuthResponse loanAuthResponseFromJson(String str) => LoanAuthResponse.fromJson(json.decode(str));

class LoanAuthResponse {
  final List<LoanAuthItem> items;
  LoanAuthResponse({required this.items});

  factory LoanAuthResponse.fromJson(Map<String, dynamic> json) => LoanAuthResponse(
    items: List<LoanAuthItem>.from(json["items"].map((x) => LoanAuthItem.fromJson(x))),
  );
}

class LoanAuthItem {
  final String? authDate;
  final int? authFlag;
  final int? prevSer;
  final String? usersDesc;
  final String? usersName;
  final String? usersNameE;
  final String? jobDesc;
  final String? jobDescE;

  LoanAuthItem({
    this.authDate,
    this.authFlag,
    this.prevSer,
    this.usersDesc,
    this.usersName,
    this.jobDesc,
    this.usersNameE,
    this.jobDescE,
  });

  factory LoanAuthItem.fromJson(Map<String, dynamic> json) => LoanAuthItem(
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