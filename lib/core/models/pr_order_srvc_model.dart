import 'dart:convert';

PrOrderSrvcResponse prOrderSrvcResponseFromJson(String str) => PrOrderSrvcResponse.fromJson(json.decode(str));
String prOrderSrvcResponseToJson(PrOrderSrvcResponse data) => json.encode(data.toJson());

class PrOrderSrvcResponse {
  final List<PrOrderSrvcItem> items;
  PrOrderSrvcResponse({required this.items});
  factory PrOrderSrvcResponse.fromJson(Map<String, dynamic> json) => PrOrderSrvcResponse(
    items: List<PrOrderSrvcItem>.from(json["items"].map((x) => PrOrderSrvcItem.fromJson(x))),
  );
  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class PrOrderSrvcItem {
  final String? srvcName; // اسم الخدمة
  final String? srvcNameE;
  final String? serviceCode; // رقم الخدمة (قد يكون int أو String)
  final String? unitName; // الوحدة
  final String? unitNameE;
  final double? unitCost; // التكلفة
  final double? taxValue1; // الضريبة
  final double? quantity; // الكمية
  // final double? totalValue; // الإجمالي (UnitCost * Quantity) - يمكن حسابه

  PrOrderSrvcItem({
    this.srvcName,
    this.srvcNameE,
    this.serviceCode,
    this.unitName,
    this.unitNameE,
    this.unitCost,
    this.taxValue1,
    this.quantity,
  });

  factory PrOrderSrvcItem.fromJson(Map<String, dynamic> json) => PrOrderSrvcItem(
    srvcName: json["SrvcName"],
    srvcNameE: json["SrvcNameE"],
    serviceCode: json["ServiceCode"]?.toString(), // للتأكد أنه String
    unitName: json["UnitName"],
    unitNameE: json["UnitNameE"],
    unitCost: (json["UnitCost"] as num?)?.toDouble(),
    taxValue1: (json["TaxValue1"] as num?)?.toDouble(),
    quantity: (json["Quantity"] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "SrvcName": srvcName,
    "SrvcNameE": srvcNameE,
    "ServiceCode": serviceCode,
    "UnitName": unitName,
    "UnitNameE": unitNameE,
    "UnitCost": unitCost,
    "TaxValue1": taxValue1,
    "Quantity": quantity,
  };

  double get totalAmount {
    return (unitCost ?? 0.0) * (quantity ?? 0.0);
  }
  double get totalAmountWithTax {
    return totalAmount + (taxValue1 ?? 0.0); // أو حسب طريقة حساب الضريبة
  }
}