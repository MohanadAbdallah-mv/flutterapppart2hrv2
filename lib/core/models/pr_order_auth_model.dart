

/*
import 'dart:convert';

PrOrderAuthResponse prOrderAuthResponseFromJson(String str) => PrOrderAuthResponse.fromJson(json.decode(str));
String prOrderAuthResponseToJson(PrOrderAuthResponse data) => json.encode(data.toJson());

class PrOrderAuthResponse {
  final List<PrOrderAuthItem> items;
  // ... أي حقول أخرى في الاستجابة الخارجية

  PrOrderAuthResponse({required this.items});

  factory PrOrderAuthResponse.fromJson(Map<String, dynamic> json) => PrOrderAuthResponse(
    items: List<PrOrderAuthItem>.from(json["items"].map((x) => PrOrderAuthItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}


class PrOrderAuthItem {
  final int? usersCode; // رقم مسؤول المشتريات
  final String? usersName; // اسم مسؤول المشتريات
  final String? authDate; // تاريخ الاعتماد "2023-01-14T10:30:00"
  final String? authStatus; // حالة الاعتماد (مثلاً: معتمد، مرفوض، تحت الإجراء)
  final String? notes; // البيان/الملاحظات
  // ... أي حقول أخرى مثل AuthLevel, etc.

  PrOrderAuthItem({
    this.usersCode,
    this.usersName,
    this.authDate,
    this.authStatus,
    this.notes,
  });

  factory PrOrderAuthItem.fromJson(Map<String, dynamic> json) => PrOrderAuthItem(
    usersCode: json["UsersCode"],
    usersName: json["UsersName"],
    authDate: json["AuthDate"],
    authStatus: json["AuthStatus"], // افترض وجود هذا الحقل
    notes: json["Notes"],       // افترض وجود هذا الحقل
  );

  Map<String, dynamic> toJson() => {
    "UsersCode": usersCode,
    "UsersName": usersName,
    "AuthDate": authDate,
    "AuthStatus": authStatus,
    "Notes": notes,
  };
}
*/
import 'dart:convert';
// لا نحتاج لاستيراد Link هنا إذا لم تكن جزءًا من AuthItem مباشرة

PrOrderAuthResponse prOrderAuthResponseFromJson(String str) => PrOrderAuthResponse.fromJson(json.decode(str));
String prOrderAuthResponseToJson(PrOrderAuthResponse data) => json.encode(data.toJson());

class PrOrderAuthResponse {
  final List<PrOrderAuthItem> items;
  final int? count;
  final bool? hasMore;
  final int? limit;
  final int? offset;
  // قد يكون هناك links على مستوى الـ collection أيضًا، أضفها إذا كانت موجودة ومهمة
  // final List<Link>? links;

  PrOrderAuthResponse({
    required this.items,
    this.count,
    this.hasMore,
    this.limit,
    this.offset,
    // this.links,
  });

  factory PrOrderAuthResponse.fromJson(Map<String, dynamic> json) => PrOrderAuthResponse(
    items: List<PrOrderAuthItem>.from(json["items"].map((x) => PrOrderAuthItem.fromJson(x))),
    count: json["count"],
    hasMore: json["hasMore"],
    limit: json["limit"],
    offset: json["offset"],
    // links: json["links"] == null ? null : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "count": count,
    "hasMore": hasMore,
    "limit": limit,
    "offset": offset,
    // "links": links == null ? null : List<dynamic>.from(links!.map((x) => x.toJson())),
  };
}


class PrOrderAuthItem {
  final String? altKey;
  final String? authDate; // "12-02-2024 02:10 pm"
  final int? authFlag;   // حالة الاعتماد (1 = معتمد)
  final String? authPk1;
  final String? authPk2;
  final String? authTableName;
  final int? prevSer;
  final int? usersCode;
  final String? usersDesc; // البيان/الملاحظات المسجلة من قبل هذا المستخدم
  final String? usersName;
  final String? usersNameE;
  final String? jobDesc;   // المسمى الوظيفي للمسؤول
  final String? jobDescE;
  // final List<Link>? links; // إذا كان لكل item روابط خاصة به

  PrOrderAuthItem({
    this.altKey,
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
    // this.links,
  });

  factory PrOrderAuthItem.fromJson(Map<String, dynamic> json) => PrOrderAuthItem(
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
    // links: json["links"] == null ? null : List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "AltKey": altKey,
    "AuthDate": authDate,
    "AuthFlag": authFlag,
    "AuthPk1": authPk1,
    "AuthPk2": authPk2,
    "AuthTableName": authTableName,
    "PrevSer": prevSer,
    "UsersCode": usersCode,
    "UsersDesc": usersDesc,
    "UsersName": usersName,
    "UsersNameE": usersNameE,
    "JobDesc": jobDesc,
    "JobDescE": jobDescE,
    // "links": links == null ? null : List<dynamic>.from(links!.map((x) => x.toJson())),
  };
}












