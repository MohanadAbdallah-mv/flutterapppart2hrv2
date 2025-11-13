import 'dart:convert';

PrOrderDetResponse prOrderDetResponseFromJson(String str) => PrOrderDetResponse.fromJson(json.decode(str));
String prOrderDetResponseToJson(PrOrderDetResponse data) => json.encode(data.toJson());

class PrOrderDetResponse {
  final List<PrOrderDetItem> items;
  PrOrderDetResponse({required this.items});
  factory PrOrderDetResponse.fromJson(Map<String, dynamic> json) => PrOrderDetResponse(
    items: List<PrOrderDetItem>.from(json["items"].map((x) => PrOrderDetItem.fromJson(x))),
  );
  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class PrOrderDetItem {
  // افترض وجود حقول مشابهة للخدمات، ولكن قد تكون أسماؤها مختلفة
  // مثال: ItemName, ItemCode, UnitName, UnitPrice, Tax, Qty
  final String? itemName; // اسم الصنف
  final String? itemNameE;
  final String? itemCode; // كود الصنف
  final String? unitNameD; // الوحدة
  final String? unitNameDE;
  final double? unitPrice; // سعر الوحدة
  final double? taxValue;  // الضريبة
  final double? qty;       // الكمية
  final String? itemDesc;  // وصف الصنف

  PrOrderDetItem({
    this.itemName,
    this.itemNameE,
    this.itemCode,
    this.unitNameD,
    this.unitNameDE,
    this.unitPrice,
    this.taxValue,
    this.qty,
    this.itemDesc,
  });

  factory PrOrderDetItem.fromJson(Map<String, dynamic> json) => PrOrderDetItem(
    itemName: json["ItemName"], // أو اسم الحقل الصحيح
    itemNameE: json["ItemNameE"],
    itemCode: json["ItemCode"]?.toString(),
    unitNameD: json["UnitName"], // أو UnitName
    unitNameDE: json["UnitNameE"],
    unitPrice: (json["VnPrice"] as num?)?.toDouble(), // أو UnitCost
    taxValue: (json["TaxValue1"] as num?)?.toDouble(), // أو TaxValue1
    qty: (json["Quantity"] as num?)?.toDouble(), // أو Quantity
    itemDesc: json["TechDesc"],
  );

  Map<String, dynamic> toJson() => {
    "ItemName": itemName,
    "ItemNameE": itemNameE,
    "ItemCode": itemCode,
    "UnitNameD": unitNameD,
    "UnitNameDE": unitNameDE,
    "UnitPrice": unitPrice,
    "TaxValue": taxValue,
    "Qty": qty,
    "ItemDesc": itemDesc,
  };

  double get totalAmount {
    return (unitPrice ?? 0.0) * (qty ?? 0.0);
  }
  double get totalAmountWithTax {
    return totalAmount + (taxValue ?? 0.0);
  }
}