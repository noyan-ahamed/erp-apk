import 'dart:convert';
import 'package:enterprise_resource_planning/core/config/app_config.dart';
import 'package:enterprise_resource_planning/core/services/api_client.dart';
import 'package:enterprise_resource_planning/data/models/admin_dashboard_model.dart';
import 'package:http/http.dart' as http;



class AdminDashboardService {

  static const String baseUrl = '${AppConfig.baseUrl}/admin-dashboard';

  Future<AdminDashboardResponse> getDashboardData({
    required String filterType,
    String? fromDate,
    String? toDate,
  }) async {

    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'filterType': filterType,
        if (fromDate != null && fromDate.isNotEmpty) 'fromDate': fromDate,
        if (toDate != null && toDate.isNotEmpty) 'toDate': toDate,
      },
    );

    final response = await ApiClient.get(uri);

    if (response.statusCode == 200) {
      return AdminDashboardResponse.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to load dashboard');
    }
  }
}
