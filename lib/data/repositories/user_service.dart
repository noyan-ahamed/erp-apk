import 'dart:convert';
import 'dart:io';
import 'package:enterprise_resource_planning/core/config/app_config.dart';
import 'package:enterprise_resource_planning/core/services/api_client.dart';
import 'package:enterprise_resource_planning/core/services/token_service.dart';
import 'package:enterprise_resource_planning/data/models/change_password_model.dart';
import 'package:enterprise_resource_planning/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {

  static const String baseUrl =
      "${AppConfig.baseUrl}/user";

  // GET CURRENT USER
  static Future<UserModel?> getCurrentUser() async {

    final response = await ApiClient.get(
      Uri.parse("$baseUrl/me"),
    );

    if(response.statusCode == 200){

      return UserModel.fromJson(
        jsonDecode(response.body),
      );
    }

    return null;
  }

  // CHANGE PASSWORD
  static Future<void> changePassword(
      ChangePasswordModel request,
      ) async {

    final response = await ApiClient.post(
      Uri.parse("$baseUrl/change-password"),
      jsonEncode(request.toJson()),
    );

    if(response.statusCode != 200){

      throw Exception(
        response.body,
      );
    }
  }

  // UPLOAD PROFILE IMAGE
  // upload profile image
  static Future<void> uploadProfileImage(
      File imageFile,
      ) async {

    final token =
    await TokenService.getToken();

    var request = http.MultipartRequest(
      "PUT",
      Uri.parse(
        "$baseUrl/upload-profile-image",
      ),
    );

    // auth header
    request.headers["Authorization"] =
    "Bearer $token";

    // file attach
    request.files.add(
      await http.MultipartFile.fromPath(
        "file", // MUST MATCH BACKEND
        imageFile.path,
      ),
    );

    final response =
    await request.send();

    if(response.statusCode != 200){

      final responseBody =
      await response.stream.bytesToString();

      throw Exception(
        "Upload failed: $responseBody",
      );
    }
  }
}