// lib/features/employee_transfer/models/company_model.dart
import 'dart:convert';

CompanyList companyListFromJson(String str) => CompanyList.fromJson(json.decode(str));

class CompanyList {
  final List<CompanyItem> items;
  CompanyList({required this.items});

  factory CompanyList.fromJson(Map<String, dynamic> json) => CompanyList(
    items: List<CompanyItem>.from(json["items"].map((x) => CompanyItem.fromJson(x))),
  );
}

class CompanyItem {
  final int companyCode;
  final String? companyDesc;
  final String? companyDescE;

  CompanyItem({
    required this.companyCode,
    this.companyDesc,
    this.companyDescE,
  });

  factory CompanyItem.fromJson(Map<String, dynamic> json) => CompanyItem(
    companyCode: json["CompanyCode"],
    companyDesc: json["CompanyDesc"],
    companyDescE: json["CompanyDescE"],
  );
}