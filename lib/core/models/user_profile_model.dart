import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));
String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
  final List<UserProfileData> items;
  final int count;
  final bool hasMore;

  UserProfile({
    required this.items,
    required this.count,
    required this.hasMore,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    items: List<UserProfileData>.from(json["items"].map((x) => UserProfileData.fromJson(x))),
    count: json["count"],
    hasMore: json["hasMore"],
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "count": count,
    "hasMore": hasMore,
  };
}

class UserProfileData {
  final int compEmpCode;
  final String? empName;
  final String? empNameE;
  final String? dNameA; // Department Name Arabic
  final String? dNameE; // Department Name English
  final String? jobDesc;
  final String? jobDescE;
  final double? salary;
  final double? transport;
  final double? nature;
  final double? food;
  final double? extra;
  final double? others;
  final double? dcsnOthr;
  final double? allowance1;
  final double? allowance2;
  final double? allowance3;
  final int? houseMnths;
  final double? houseAmount;
  final int? normalDays;
  final int? suddenSlryDays;
  final int? absenceNotAllowExtraDays;
  final int? vacationEvery;
  final double? ticketsAmount;
  final int? ticketsEvery;
  final String? ticketsType;
  final String? cityNameA;
  final String? cityNameE;
  final String? airlineNameA;
  final String? airlineNameE;

  UserProfileData({
    required this.compEmpCode,
    this.empName,
    this.empNameE,
    this.dNameA,
    this.dNameE,
    this.jobDesc,
    this.jobDescE,
    this.salary,
    this.transport,
    this.nature,
    this.food,
    this.extra,
    this.others,
    this.dcsnOthr,
    this.allowance1,
    this.allowance2,
    this.allowance3,
    this.houseMnths,
    this.houseAmount,
    this.normalDays,
    this.suddenSlryDays,
    this.absenceNotAllowExtraDays,
    this.vacationEvery,
    this.ticketsAmount,
    this.ticketsEvery,
    this.ticketsType,
    this.cityNameA,
    this.cityNameE,
    this.airlineNameA,
    this.airlineNameE,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    try {
      return UserProfileData(
        // تحويل آمن للأرقام - يدعم int و double و String
        compEmpCode: _parseInt(json["CompEmpCode"]),
        empName: json["EmpName"]?.toString(),
        empNameE: json["EmpNameE"]?.toString(),
        dNameA: json["DName"]?.toString(), // الاسم العربي للقسم
        dNameE: json["DNameE"]?.toString(), // الاسم الإنجليزي للقسم
        jobDesc: json["JobDesc"]?.toString(),
        jobDescE: json["JobDescE"]?.toString(),

        // تحويل آمن للأرقام العشرية
        salary: _parseDouble(json["Salary"]),
        transport: _parseDouble(json["Transport"]),
        nature: _parseDouble(json["Nature"]),
        food: _parseDouble(json["Food"]),
        extra: _parseDouble(json["Extra"]),
        others: _parseDouble(json["Others"]),
        dcsnOthr: _parseDouble(json["DcsnOthr"]),
        allowance1: _parseDouble(json["Allowance1"]),
        allowance2: _parseDouble(json["Allowance2"]),
        allowance3: _parseDouble(json["Allowance3"]),
        houseAmount: _parseDouble(json["HouseAmount"]),
        ticketsAmount: _parseDouble(json["TicketsAmount"]),

        // تحويل آمن للأرقام الصحيحة
        houseMnths: _parseIntNullable(json["HouseMnths"]),
        normalDays: _parseIntNullable(json["NormalDays"]),
        suddenSlryDays: _parseIntNullable(json["SuddenSlryDays"]),
        absenceNotAllowExtraDays: _parseIntNullable(json["AbsenceNotAllowExtraDays"]),
        vacationEvery: _parseIntNullable(json["VacationEvery"]),
        ticketsEvery: _parseIntNullable(json["TicketsEvery"]),

        ticketsType: json["TicketsType"]?.toString(),
        cityNameA: json["CityNameA"]?.toString(),
        cityNameE: json["CityNameE"]?.toString(),
        airlineNameA: json["AirlineNameA"]?.toString(),
        airlineNameE: json["AirlineNameE"]?.toString(),
      );
    } catch (e, stackTrace) {
      print("❌ خطأ في تحويل البيانات (fromJson):");
      print("البيانات الواردة: $json");
      print("الخطأ: $e");
      print("التفاصيل: $stackTrace");
      rethrow;
    }
  }

  // دالة مساعدة لتحويل آمن إلى int (مطلوبة)
  static int _parseInt(dynamic value) {
    if (value == null) {
      throw ArgumentError("القيمة المطلوبة لا يمكن أن تكون null");
    }
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw ArgumentError("لا يمكن تحويل القيمة $value (${value.runtimeType}) إلى int");
  }

  // دالة مساعدة لتحويل آمن إلى int nullable
  static int? _parseIntNullable(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  // دالة مساعدة لتحويل آمن إلى double
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() => {
    "CompEmpCode": compEmpCode,
    "EmpName": empName,
    "EmpNameE": empNameE,
    "DName": dNameA, // ✅ مُصحح
    "DNameE": dNameE, // ✅ مُصحح (كان DNamee)
    "JobDesc": jobDesc,
    "JobDescE": jobDescE,
    "Salary": salary,
    "Transport": transport,
    "Nature": nature,
    "Food": food,
    "Extra": extra,
    "Others": others,
    "DcsnOthr": dcsnOthr,
    "Allowance1": allowance1,
    "Allowance2": allowance2,
    "Allowance3": allowance3,
    "HouseMnths": houseMnths,
    "HouseAmount": houseAmount,
    "NormalDays": normalDays,
    "SuddenSlryDays": suddenSlryDays,
    "AbsenceNotAllowExtraDays": absenceNotAllowExtraDays,
    "VacationEvery": vacationEvery,
    "TicketsAmount": ticketsAmount,
    "TicketsEvery": ticketsEvery,
    "TicketsType": ticketsType,
    "CityNameA": cityNameA,
    "CityNameE": cityNameE,
    "AirlineNameA": airlineNameA,
    "AirlineNameE": airlineNameE,
  };
}