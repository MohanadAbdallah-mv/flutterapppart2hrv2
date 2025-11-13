// lib/core/models/notification_info_model.dart

import 'dart:convert';

// دالة مساعدة لتحويل JSON إلى قائمة من النماذج
List<NotificationInfo> notificationInfoListFromJson(String str) =>
    List<NotificationInfo>.from(json.decode(str)["items"].map((x) => NotificationInfo.fromJson(x)));

class NotificationInfo {
  final int usersCode;
  final int? reqApprVcnc;
  final int? lastVcncSeq;
  final int? reqApprLoan;
  final int? lastLoanSeq;
  final int? reqApprEndsrv;
  final int? lastEndsrvSeq;
  final int? reqApprPrOrder;
  final int? reqApprPrReq;
  final int? reqApprAsOrder;
  final int? reqApprAsReq;
  final int? reqApprCstd;
  final int? reqApprCstdReq;
  final int? hrSystem;
  final int? mnSystem;
  final int? puSystem;
  final int? asSystem;
  final int? cstdSystem;
  final int? taSystem;
  final int? reqApprMnEntry;
  final int? reqApprMnReq;
  final int? reqApprMnMast;
  final double? lat;
  final double? lon;

  NotificationInfo({
    required this.usersCode,
    this.reqApprVcnc,
    this.lastVcncSeq,
    this.reqApprLoan,
    this.lastLoanSeq,
    this.reqApprEndsrv,
    this.lastEndsrvSeq,
    this.reqApprPrOrder,
    this.reqApprPrReq,
    this.reqApprAsOrder,
    this.reqApprAsReq,
    this.reqApprCstd,
    this.reqApprCstdReq,
    this.hrSystem,
    this.mnSystem,
    this.puSystem,
    this.asSystem,
    this.cstdSystem,
    this.taSystem,
    this.reqApprMnEntry,
    this.reqApprMnReq,
    this.reqApprMnMast,
    this.lat,
    this.lon,
  });

  factory NotificationInfo.fromJson(Map<String, dynamic> json) => NotificationInfo(
    usersCode: json["UsersCode"],
    reqApprVcnc: json["ReqApprVcnc"],
    lastVcncSeq: json["LastVcncSeq"],
    reqApprLoan: json["ReqApprLoan"],
    lastLoanSeq: json["LastLoanSeq"],
    reqApprEndsrv: json["ReqApprEndsrv"],
    lastEndsrvSeq: json["LastEndsrvSeq"],
    reqApprPrOrder: json["ReqApprPrOrder"],
    reqApprPrReq: json["ReqApprPrReq"],
    reqApprAsOrder: json["ReqApprAsOrder"],
    reqApprAsReq: json["ReqApprAsReq"],
    reqApprCstd: json["ReqApprCstd"],
    reqApprCstdReq: json["ReqApprCstdReq"],
    hrSystem: json["HrSystem"],
    mnSystem: json["MnSystem"],
    puSystem: json["PuSystem"],
    asSystem: json["AsSystem"],
    cstdSystem: json["CstdSystem"],
    taSystem: json["TaSystem"],
    reqApprMnEntry: json["ReqApprMnEntry"],
    reqApprMnReq: json["ReqApprMnReq"],
    reqApprMnMast: json["ReqApprMnMast"],
    lat: (json["Lat"] as num?)?.toDouble(),
    lon: (json["Lon"] as num?)?.toDouble(),
  );
}