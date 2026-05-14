import 'dart:convert';
import 'package:enterprise_resource_planning/core/config/app_config.dart';
import 'package:enterprise_resource_planning/core/services/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:enterprise_resource_planning/data/models/supplier_model.dart';

class SupplierService {
  static const String baseUrl = '${AppConfig.baseUrl}/supplier';


  /// GET ALL SUPPLIERS
  Future<List<SupplierModel>> getAllSuppliers() async {
    final response = await ApiClient.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return data
          .map((e) => SupplierModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load suppliers: ${response.body}');
    }
  }


  /// GET SUPPLIER BY ID
  Future<SupplierModel> getSupplierById(int id) async {
    final response = await ApiClient.get(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode == 200) {
      return SupplierModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load supplier');
    }
  }


  /// CREATE SUPPLIER
  Future<SupplierModel> createSupplier(SupplierModel supplier) async {
    final response = await ApiClient.post(
      Uri.parse('$baseUrl/create-supplier'),
      jsonEncode(supplier.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SupplierModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create supplier: ${response.body}');
    }
  }


  /// UPDATE SUPPLIER
  Future<SupplierModel> updateSupplier(
      int id, SupplierModel supplier) async {

    final response = await ApiClient.put(
      Uri.parse('$baseUrl/update-supplier/$id'),
      jsonEncode(supplier.toJson()),
    );

    if (response.statusCode == 200) {
      return SupplierModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update supplier: ${response.body}');
    }
  }


  /// DELETE SUPPLIER
  Future<void> deleteSupplier(int id) async {
    final response = await ApiClient.delete(
      Uri.parse('$baseUrl/delete-supplier/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete supplier');
    }
  }
}