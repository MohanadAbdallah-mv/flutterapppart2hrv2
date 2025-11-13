// lib/core/models/purchase_order_model.dart

import 'dart:convert';

PurchaseOrderList purchaseOrderListFromJson(String str) => PurchaseOrderList.fromJson(json.decode(str));
String purchaseOrderListToJson(PurchaseOrderList data) => json.encode(data.toJson());

class PurchaseOrderList {
  final List<PurchaseOrderItem> items;
  final int count;
  final bool hasMore;

  PurchaseOrderList({
    required this.items,
    required this.count,
    required this.hasMore,
  });

  factory PurchaseOrderList.fromJson(Map<String, dynamic> json) => PurchaseOrderList(
    items: List<PurchaseOrderItem>.from(json["items"].map((x) => PurchaseOrderItem.fromJson(x))),
    count: json["count"],
    hasMore: json["hasMore"],
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "count": count,
    "hasMore": hasMore,
  };
}

class PurchaseOrderItem {
  final String? trnsDesc;
  final String? trnsDescE;
  final String altKey;
  final String? supplierName;
  final String? supplierNameE;
  final String? prOrderDate;
  final String? poSubject;
  final String? compName;
  final String? poStatusDesc;
  final String? poSubjectE;
  final String? poStatus;
  final int? trnsTypeCode; // تمت الإضافة لاستخدامه كـ AuthPk1
  final int? trnsSerial;   // تمت الإضافة لاستخدامه كـ AuthPk2
  final List<Link> links;

  PurchaseOrderItem({
    this.trnsDesc,
    this.trnsDescE,
    required this.altKey,
    this.supplierName,
    this.supplierNameE,
    this.prOrderDate,
    this.poSubject,
    required this.links,
    this.compName,
    this.poStatusDesc,
    this.poSubjectE,
    this.poStatus,
    this.trnsTypeCode, // تمت الإضافة
    this.trnsSerial,   // تمت الإضافة
  });

  factory PurchaseOrderItem.fromJson(Map<String, dynamic> json) => PurchaseOrderItem(
    trnsDesc: json["TrnsDesc"],
    trnsDescE: json["TrnsDescE"],
    altKey: json["AltKey"],
    supplierName: json["SupplierName"],
    supplierNameE: json["SupplierNameE"],
    prOrderDate: json["PrOrderDate"],
    poSubject: json["PoSubject"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    compName: json["CompName"],
    poStatusDesc: json["PoStatusDesc"],
    poSubjectE: json["PoSubjectE"],
    poStatus: json["PoStatus"],
    trnsTypeCode: json["TrnsTypeCode"], // تمت الإضافة
    trnsSerial: json["TrnsSerial"],     // تمت الإضافة
  );

  Map<String, dynamic> toJson() => {
    "TrnsDesc": trnsDesc,
    "TrnsDescE": trnsDescE,
    "AltKey": altKey,
    "SupplierName": supplierName,
    "SupplierNameE": supplierNameE,
    "PrOrderDate": prOrderDate,
    "PoSubject": poSubject,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
    "TrnsTypeCode": trnsTypeCode,
    "TrnsSerial": trnsSerial,
  };

  String? getLink(String name) {
    try {
      return links.firstWhere((link) => link.name == name).href;
    } catch (e) {
      return null;
    }
  }
}

class Link {
  final String rel;
  final String href;
  final String name;
  final String kind;

  Link({
    required this.rel,
    required this.href,
    required this.name,
    required this.kind,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    rel: json["rel"],
    href: json["href"],
    name: json["name"],
    kind: json["kind"],
  );

  Map<String, dynamic> toJson() => {
    "rel": rel,
    "href": href,
    "name": name,
    "kind": kind,
  };
}