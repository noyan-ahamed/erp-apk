class ProductModel {

  final int? id;

  final String name;
  final String sku;

  final int minStockLevel;

  final String status;

  final String createdAt;

  final double sellingPrice;

  final int stock;

  final dynamic category;

  ProductModel({
    this.id,
    required this.name,
    required this.sku,
    required this.minStockLevel,
    required this.status,
    required this.createdAt,
    required this.sellingPrice,
    required this.stock,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {

    return ProductModel(
      id: json['id'],
      name: json['name'] ?? '',
      sku: json['sku'] ?? '',
      minStockLevel: json['minStockLevel'] ?? 0,
      status: json['status'] ?? 'ACTIVE',
      createdAt: json['created_at'] ?? '',
      sellingPrice:
      (json['sellingPrice'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "sku": sku,
      "minStockLevel": minStockLevel,
      "status": status,
      "created_at": createdAt,
      "category": {
        "id": category.id,
      },
    };
  }
}