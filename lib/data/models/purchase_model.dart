import 'supplier_model.dart';
import 'product_model.dart';

class PurchaseOrderModel {
  final int? id;
  final String invoiceNumber;
  final String status;
  final String? paymentTerms;
  final double totalAmount;
  final String createdAt;
  final SupplierModel? supplier;
  final List<PurchaseItemModel> items;

  PurchaseOrderModel({
    this.id,
    required this.invoiceNumber,
    required this.status,
    required this.paymentTerms,
    required this.totalAmount,
    required this.createdAt,
    required this.supplier,
    required this.items,
  });

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderModel(
      id: json['id'],
      invoiceNumber: json['invoiceNumber'] ?? '',
      status: json['status'] ?? '',
      paymentTerms: json['paymentTerms'],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      createdAt: json['created_at'] ?? '',
      supplier: json['supplier'] != null
          ? SupplierModel.fromJson(json['supplier'])
          : null,
      items: json['items'] != null
          ? List<PurchaseItemModel>.from(
        json['items'].map((x) => PurchaseItemModel.fromJson(x)),
      )
          : [],
    );
  }
}

class PurchaseItemModel {
  final int? id;
  ProductModel? product;
  int quantity;
  String unit;
  double unitPrice;
  double lineTotal;

  PurchaseItemModel({
    this.id,
    this.product,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.lineTotal,
  });

  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseItemModel(
      id: json['id'],
      product: json['product'] != null
          ? ProductModel.fromJson(json['product'])
          : null,
      quantity: json['quantity'] ?? 0,
      unit: json['unit'] ?? '',
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      lineTotal: (json['lineTotal'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": product?.id,
      "quantity": quantity,
      "unit": unit,
      "unitPrice": unitPrice,
      "lineTotal": lineTotal,
    };
  }
}