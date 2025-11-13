// lib/features/employee_transfer/models/department_model.dart
import 'dart:convert';

DepartmentList departmentListFromJson(String str) => DepartmentList.fromJson(json.decode(str));

class DepartmentList {
  final List<DepartmentItem> items;
  DepartmentList({required this.items});

  factory DepartmentList.fromJson(Map<String, dynamic> json) => DepartmentList(
    items: List<DepartmentItem>.from(json["items"].map((x) => DepartmentItem.fromJson(x))),
  );
}

class DepartmentItem {
  final int companyCode;
  final int dCode;
  final String? dName;
  final String? dNameE;

  DepartmentItem({
    required this.companyCode,
    required this.dCode,
    this.dName,
    this.dNameE,
  });

  factory DepartmentItem.fromJson(Map<String, dynamic> json) => DepartmentItem(
    companyCode: json["CompanyCode"],
    dCode: json["DCode"],
    dName: json["DName"],
    dNameE: json["DNameE"],
  );
}