import 'dart:convert';

import 'package:enterprise_resource_planning/core/config/app_config.dart';
import 'package:enterprise_resource_planning/core/services/api_client.dart';
import 'package:enterprise_resource_planning/data/models/customer/customer_due_summary_model.dart';
import 'package:enterprise_resource_planning/data/models/customer/customer_payment_request.dart';
import 'package:enterprise_resource_planning/data/models/customer/customer_payment_response.dart';

class CustomerPaymentService {

  final String baseUrl =
      "${AppConfig.baseUrl}/customer-payments";

  Future<CustomerDueSummaryModel>
  searchCustomer(
      String keyword,
      ) async {

    final response = await ApiClient.get(

      Uri.parse(
        "$baseUrl/summary?keyword=$keyword",
      ),
    );

    if(response.statusCode == 200){

      return CustomerDueSummaryModel.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      response.body,
    );
  }

  Future<CustomerPaymentResponse>
  submitPayment(
      CustomerPaymentRequest request,
      ) async {

    final response = await ApiClient.post(

      Uri.parse(baseUrl),

      jsonEncode(
        request.toJson(),
      ),
    );

    if(response.statusCode == 200
        ||
        response.statusCode == 201){

      return CustomerPaymentResponse.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      response.body,
    );
  }

  Future<List<CustomerPaymentResponse>> getAdminPaymentList(String keyword, String status) async {
    final response = await ApiClient.get(
      Uri.parse("$baseUrl/admin/list?keyword=$keyword&status=$status"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => CustomerPaymentResponse.fromJson(e)).toList();
    }
    throw Exception(response.body);
  }

  Future<CustomerPaymentResponse> approvePayment(int id, String remarks) async {
    final response = await ApiClient.put(
      Uri.parse("$baseUrl/$id/approve"),
      jsonEncode({"remarks": remarks}),
    );

    if (response.statusCode == 200) {
      return CustomerPaymentResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }

  Future<CustomerPaymentResponse> rejectPayment(int id, String remarks) async {
    final response = await ApiClient.put(
      Uri.parse("$baseUrl/$id/reject"),
      jsonEncode({"remarks": remarks}),
    );

    if (response.statusCode == 200) {
      return CustomerPaymentResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }
}