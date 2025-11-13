// lib/features/loans/models/loan_request_model.dart

import 'dart:convert';

import 'package:flutterapppart2hr/core/models/purchase_order_model.dart';


LoanRequestList loanRequestListFromJson(String str) => LoanRequestList.fromJson(json.decode(str));

class LoanRequestList {
  final List<LoanRequestItem> items;
  LoanRequestList({required this.items});

  factory LoanRequestList.fromJson(Map<String, dynamic> json) => LoanRequestList(
    items: List<LoanRequestItem>.from(json["items"].map((x) => LoanRequestItem.fromJson(x))),
  );
}

class LoanRequestItem {
  final int empCode;
  final int reqSerial;
  final String? reqLoanDate;
  final int? loanType;
  final String? loanStartDate;
  final String? descA;
  final String? descE;
  final String altKey;
  final String? empName;
  final String? empNameE;
  final List<Link> links;

  LoanRequestItem({
    required this.empCode,
    required this.reqSerial,
    this.reqLoanDate,
    this.loanType,
    this.loanStartDate,
    this.descA,
    this.descE,
    required this.altKey,
    this.empName,
    this.empNameE,
    required this.links,
  });

  factory LoanRequestItem.fromJson(Map<String, dynamic> json) => LoanRequestItem(
    empCode: json["EmpCode"],
    reqSerial: json["ReqSerial"],
    reqLoanDate: json["ReqLoanDate"],
    loanType: json["LoanType"],
    loanStartDate: json["LoanStartDate"],
    descA: json["DescA"],
    descE: json["DescE"],
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