import 'dart:convert';

import 'package:enterprise_resource_planning/core/config/app_config.dart';
import 'package:enterprise_resource_planning/core/services/api_client.dart';
import 'package:enterprise_resource_planning/data/models/sales/customer_search_response.dart';
import 'package:enterprise_resource_planning/data/models/sales/quick_customer_create_request.dart';


class CustomerService {

  final String baseUrl =
      "${AppConfig.baseUrl}/customer";

  Future<CustomerSearchResponse>
  quickCustomerCreate(
      QuickCustomerCreateRequest request,
      ) async {

    final response = await ApiClient.post(

      Uri.parse("$baseUrl/quick-create"),

      jsonEncode(
        request.toJson(),
      ),
    );

    if(response.statusCode == 200){

      return CustomerSearchResponse
          .fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(response.body);
  }
}