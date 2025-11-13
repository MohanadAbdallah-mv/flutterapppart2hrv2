import 'dart:convert';

import 'package:flutterapppart2hr/core/models/user_model.dart';

UserNotificationInfo userNotificationInfoFromJson(String str) => UserNotificationInfo.fromJson(json.decode(str));

String userNotificationInfoToJson(UserNotificationInfo data) => json.encode(data.toJson());

class UserNotificationInfo {
  final List<NotificationItem> items;
  final int count;
  final bool hasMore;
  final int limit;
  final int offset;
  final List<Link> links;

  UserNotificationInfo({
    required this.items,
    required this.count,
    required this.hasMore,
    required this.limit,
    required this.offset,
    required this.links,
  });

  factory UserNotificationInfo.fromJson(Map<String, dynamic> json) => UserNotificationInfo(
    items: List<NotificationItem>.from(json["items"].map((x) => NotificationItem.fromJson(x))),
    count: json["count"],
    hasMore: json["hasMore"],
    limit: json["limit"],
    offset: json["offset"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "count": count,
    "hasMore": hasMore,
    "limit": limit,
    "offset": offset,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
  };
}

class NotificationItem {
  final int usersCode;
  final int? reqApprPrOrder; // Number of purchase order approvals
  // أضف باقي الحقول إذا كنت ستحتاجها من هذا الـ API
  // final dynamic reqApprPrRequest;
  // final dynamic reqApprTraining;
  // ...

  NotificationItem({
    required this.usersCode,
    this.reqApprPrOrder,
    // ...
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) => NotificationItem(
    usersCode: json["UsersCode"],
    reqApprPrOrder: json["ReqApprPrOrder"],
    // ...
  );

  Map<String, dynamic> toJson() => {
    "UsersCode": usersCode,
    "ReqApprPrOrder": reqApprPrOrder,
    // ...
  };
}

// يمكنك إعادة استخدام نموذج Link من user_model.dart أو تعريفه هنا إذا كان مختلفًا
// class Link { ... }