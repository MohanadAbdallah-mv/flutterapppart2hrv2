// features/loans/models/my_loan_request_model.dart
import 'dart:convert';

import '../../../core/models/purchase_order_model.dart';

MyLoanRequestList myLoanRequestListFromJson(String str) => MyLoanRequestList.fromJson(json.decode(str));

class MyLoanRequestList {
  final List<MyLoanRequestItem> items;
  MyLoanRequestList({required this.items});

  factory MyLoanRequestList.fromJson(Map<String, dynamic> json) => MyLoanRequestList(
    items: List<MyLoanRequestItem>.from(json["items"].map((x) => MyLoanRequestItem.fromJson(x))),
  );
}

class MyLoanRequestItem {
  final int empCode;
  final int reqSerial;
  final int? loanType;
  final String? reqLoanDate;
  final String? loanStartDate;
  final double? loanValuePys;
  final double? loanInstlPys;
  final int? authFlag;
  final String? descA;
  final String? descE;
  final int? loanNos;
  final String altKey;
  final List<Link> links;

  MyLoanRequestItem({
    required this.empCode,
    required this.reqSerial,
    this.loanType,
    this.reqLoanDate,
    this.loanStartDate,
    this.loanValuePys,
    this.loanInstlPys,
    this.authFlag,
    this.descA,
    this.descE,
    this.loanNos,
    required this.altKey,
    required this.links,
  });

  factory MyLoanRequestItem.fromJson(Map<String, dynamic> json) => MyLoanRequestItem(
    empCode: json["EmpCode"],
    reqSerial: json["ReqSerial"],
    loanType: json["LoanType"],
    reqLoanDate: json["ReqLoanDate"],
    loanStartDate: json["LoanStartDate"],
    loanValuePys: (json["LoanValuePys"] as num?)?.toDouble(),
    loanInstlPys: (json["LoanInstlPys"] as num?)?.toDouble(),
    authFlag: json["AuthFlag"],
    descA: json["DescA"],
    descE: json["DescE"],
    loanNos: json["LoanNos"],
    altKey: json["AltKey"],
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