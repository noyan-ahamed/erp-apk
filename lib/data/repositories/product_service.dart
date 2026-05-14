import 'dart:convert';

import 'package:enterprise_resource_planning/core/config/app_config.dart';
import 'package:enterprise_resource_planning/core/services/api_client.dart';
import 'package:enterprise_resource_planning/data/models/product_model.dart';

class ProductService {

  final String baseUrl =
      "${AppConfig.baseUrl}/product";

  // get
  Future<List<ProductModel>> getProducts() async {

    final response = await ApiClient.get(
      Uri.parse(baseUrl),
    );

    if(response.statusCode == 200){

      List data = jsonDecode(response.body);

      return data
          .map((e) => ProductModel.fromJson(e))
          .toList();
    }

    throw Exception("Failed to load products");
  }

  // create
  Future<ProductModel> createProduct(
      ProductModel product,
      ) async {

    final response = await ApiClient.post(

      Uri.parse("$baseUrl/create-product"),

      jsonEncode(product.toJson()),
    );

    if(response.statusCode == 200){

      return ProductModel.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(response.body);
  }

  // update
  Future<ProductModel> updateProduct(
      int id,
      String name,
      ) async {

    final response = await ApiClient.put(

      Uri.parse("$baseUrl/update-product/$id"),

      jsonEncode({
        "name": name,
      }),
    );

    if(response.statusCode == 200){

      return ProductModel.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(response.body);
  }

  //delete
  Future<void> deleteProduct(int id) async {

    final response = await ApiClient.delete(
      Uri.parse("$baseUrl/delete-product/$id"),
    );

    if(response.statusCode != 200){

      throw Exception("Delete failed");
    }
  }
}