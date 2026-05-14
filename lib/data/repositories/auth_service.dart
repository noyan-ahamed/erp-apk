// here we save login and token
import 'dart:convert';

import 'package:enterprise_resource_planning/core/config/app_config.dart';
import 'package:enterprise_resource_planning/core/services/token_service.dart';
import 'package:enterprise_resource_planning/data/models/auth_response_model.dart';
import 'package:enterprise_resource_planning/data/models/login_request_model.dart';
import 'package:enterprise_resource_planning/data/repositories/user_service.dart';
import 'package:http/http.dart' as http;

class AuthService {

  static const String baseUrl =
      "${AppConfig.baseUrl}/authentication";

  Future<AuthResponseModel> login(
      LoginRequestModel request
      ) async {

    final response = await http.post(
      Uri.parse("$baseUrl/authenticate"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      final authResponse =
      AuthResponseModel.fromJson(data);

      //save token
      await TokenService.saveToken(authResponse.token);

      //save role
      await TokenService.saveRoles(authResponse.roles);

      // save password changed status
      await TokenService.savePasswordChanged(
        authResponse.passwordChanged,
      );

      //get current user
      final user =
      await UserService.getCurrentUser();

      //save user locally
      if (user != null) {

        await TokenService.saveUser(
          jsonEncode(user.toJson()),
        );
      }

      return authResponse;

    } else {
      throw Exception("Invalid username or password");
    }
  }

}