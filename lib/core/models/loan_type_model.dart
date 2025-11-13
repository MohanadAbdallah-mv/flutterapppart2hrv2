// lib/features/loans/models/loan_type_model.dart

import 'dart:convert';

LoanTypeList loanTypeListFromJson(String str) => LoanTypeList.fromJson(json.decode(str));

class LoanTypeList {
  final List<LoanTypeItem> items;
  LoanTypeList({required this.items});

  factory LoanTypeList.fromJson(Map<String, dynamic> json) => LoanTypeList(
    items: List<LoanTypeItem>.from(json["items"].map((x) => LoanTypeItem.fromJson(x))),
  );
}

class LoanTypeItem {
  final int loanTypeCode;
  final String? nameA;
  final String? nameE;

  LoanTypeItem({
    required this.loanTypeCode,
    this.nameA,
    this.nameE
  });

  factory LoanTypeItem.fromJson(Map<String, dynamic> json) => LoanTypeItem(
    loanTypeCode: json["LoanTypeCode"],
    nameA: json["NameA"],
    nameE: json["NameE"],

  );
}