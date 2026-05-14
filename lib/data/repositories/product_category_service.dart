import 'dart:convert';
import 'package:enterprise_resource_planning/core/config/app_config.dart';
import 'package:enterprise_resource_planning/core/services/api_client.dart';
import 'package:enterprise_resource_planning/data/models/product_category_model.dart';
import 'package:http/http.dart' as http;


class ProductCategoryService {
  final String baseUrl = "${AppConfig.baseUrl}/category";
  // Android emulator → localhost = 10.0.2.2

  /// GET ALL
  Future<List<ProductCategory>> getAllCategories() async {
    final response = await ApiClient.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data.map((e) => ProductCategory.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }

  /// CREATE
  Future<ProductCategory> createCategory(ProductCategory category) async {
    final response = await ApiClient.post(
      Uri.parse("$baseUrl/create-category"),
      jsonEncode(category.toJson()),
    );

    if (response.statusCode == 200) {
      return ProductCategory.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to create category");
    }
  }

  /// UPDATE
  Future<ProductCategory> updateCategory(int id, ProductCategory category) async {
    final response = await ApiClient.put(
      Uri.parse("$baseUrl/$id"),
      jsonEncode(category.toJson()),
    );

    if (response.statusCode == 200) {
      return ProductCategory.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update category");
    }
  }

  /// DELETE
  Future<void> deleteCategory(int id) async {
    final response = await ApiClient.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete category");
    }
  }
}
