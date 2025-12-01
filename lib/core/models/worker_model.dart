// lib/core/models/worker_model.dart

class WorkerModel {
  final int compEmpCode;
  final int empCode;
  final String empName;
  final String? empNameE;
  final int usersCode;

  WorkerModel({
    required this.compEmpCode,
    required this.empCode,
    required this.empName,
    this.empNameE,
    required this.usersCode,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      compEmpCode: json['CompEmpCode'],
      empCode: json['EmpCode'],
      empName: json['EmpName'],
      empNameE: json['EmpNameE'],
      usersCode: json['UsersCode'],
    );
  }

  // دالة مساعدة للبحث في القوائم
  String get displayNameAr => "$compEmpCode - $empName";
  String get displayNameEn => "$compEmpCode - ${empNameE ?? empName}";
}