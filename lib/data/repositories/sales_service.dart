import 'dart:convert';

import 'package:enterprise_resource_planning/core/config/app_config.dart';
import 'package:enterprise_resource_planning/core/services/api_client.dart';
import 'package:enterprise_resource_planning/core/services/token_service.dart';
import 'package:enterprise_resource_planning/data/models/sales/customer_search_response.dart';
import 'package:enterprise_resource_planning/data/models/sales/sales_create_request.dart';
import 'package:enterprise_resource_planning/data/models/sales/sales_history_model.dart';
import 'package:enterprise_resource_planning/data/models/sales/sales_response.dart';


class SalesService {

  final String baseUrl =
      "${AppConfig.baseUrl}/sales";

  Future<List<CustomerSearchResponse>>
  searchCustomers(String keyword) async {

    final response = await ApiClient.get(

      Uri.parse(
        "$baseUrl/customer-search?keyword=$keyword",
      ),
    );

    if(response.statusCode == 200){

      List data =
      jsonDecode(response.body);

      return data
          .map(
            (e) =>
            CustomerSearchResponse
                .fromJson(e),
      )
          .toList();
    }

    throw Exception(
      "Customer search failed",
    );
  }

  Future<SalesResponse> createSale(
      SalesCreateRequest request,
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

      return SalesResponse.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(response.body);
  }





  Future<List<SalesHistoryModel>>
  getMySales(String date) async {

    final response = await ApiClient.get(

      Uri.parse(
        "$baseUrl/my-sales?date=$date",
      ),
    );

    if(response.statusCode == 200){

      final List data =
      jsonDecode(response.body);

      return data
          .map(
            (e) =>
            SalesHistoryModel.fromJson(e),
      )
          .toList();
    }

    throw Exception(
      "Failed to load sales history",
    );
  }

  Future<double> getMonthlyTotal(
      int year,
      int month,
      ) async {

    final response = await ApiClient.get(

      Uri.parse(
        "$baseUrl/my-monthly-total?year=$year&month=$month",
      ),
    );

    if(response.statusCode == 200){

      return double.parse(
        response.body,
      );
    }

    throw Exception(
      "Failed to load monthly sales",
    );
  }
}