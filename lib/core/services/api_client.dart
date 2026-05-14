import 'dart:convert';

import 'package:enterprise_resource_planning/core/services/token_service.dart';
import 'package:http/http.dart' as http;

class ApiClient {

  static Future<Map<String, String>> headers() async {

    final token =
    await TokenService.getToken();

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  static Future<http.Response> get(Uri uri) async {

    final response = await http.get(
      uri,
      headers: await headers(),
    );

    await _handleUnauthorized(response);

    return response;
  }

  static Future<http.Response> post(
      Uri uri, [
        String? body,
      ]) async {

    final response = await http.post(
      uri,
      headers: await headers(),
      body: body,
    );

    await _handleUnauthorized(response);

    return response;
  }

  static Future<http.Response> put(
      Uri uri, [
        String? body,
      ]) async {

    final response = await http.put(
      uri,
      headers: await headers(),
      body: body,
    );

    await _handleUnauthorized(response);

    return response;
  }

  static Future<http.Response> delete(
      Uri uri,
      ) async {

    final response = await http.delete(
      uri,
      headers: await headers(),
    );

    await _handleUnauthorized(response);

    return response;
  }

  static Future<void> _handleUnauthorized(
      http.Response response,
      ) async {

    if (response.statusCode == 401) {

      await TokenService.clearAll();
    }
  }
}