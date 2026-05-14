class ProductCategory {
  final int? id;
  final String name;
  final String? description;
  final String? status;
  final int? productCount;

  ProductCategory({
    this.id,
    required this.name,
    this.description,
    this.status,
    this.productCount,
  });

  //from json
  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      status: json['status'],
      productCount: json['productCount'],
    );
  }

  //to json post or put
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "status": status,
    };
  }
}
