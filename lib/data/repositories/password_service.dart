import 'dart:convert';


import 'package:enterprise_resource_planning/core/config/app_config.dart';
import 'package:enterprise_resource_planning/core/services/api_client.dart';
import 'package:enterprise_resource_planning/core/services/token_service.dart';
import 'package:enterprise_resource_planning/data/models/first_password_change_request.dart';

class PasswordService {

  static const String baseUrl =
      "${AppConfig.baseUrl}/user";

  Future<void> firstPasswordChange(
      FirstPasswordChangeRequest request
      ) async {

    final response = await ApiClient.post(
      Uri.parse(
          "$baseUrl/first-password-change"
      ),
      jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {

      await TokenService.savePasswordChanged(
        true,
      );

    } else {

      throw Exception(
          "Password change failed"
      );
    }
  }
}