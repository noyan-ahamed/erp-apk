import 'dart:convert';

import 'package:enterprise_resource_planning/core/config/app_config.dart';
import 'package:enterprise_resource_planning/core/services/api_client.dart';
import 'package:http/http.dart' as http;

import '../models/purchase_model.dart';

class PurchaseService {

  final String baseUrl = "${AppConfig.baseUrl}/purchases";

  Future<List<PurchaseOrderModel>> getAllOrders() async {

    final response = await ApiClient.get(Uri.parse(baseUrl));

    if(response.statusCode == 200){

      final data = jsonDecode(response.body);

      return List<PurchaseOrderModel>.from(
        data.map((x) => PurchaseOrderModel.fromJson(x)),
      );
    }

    throw Exception("Failed to load");
  }

  Future<bool> createPurchase(Map<String,dynamic> body) async {

    final response = await ApiClient.post(

      Uri.parse(baseUrl),
      jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  Future<bool> updateStatus(int id, String status) async {

    final response = await ApiClient.put(
      Uri.parse("$baseUrl/$id/status?status=$status")
    );

    return response.statusCode == 200;
  }

  Future<bool> sendMail(int id) async {

    final response = await ApiClient.post(
      Uri.parse("$baseUrl/$id/send-email")
    );

    return response.statusCode == 200;
  }
}