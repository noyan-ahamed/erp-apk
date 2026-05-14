import 'dart:convert';

import 'package:enterprise_resource_planning/core/config/app_config.dart';
import 'package:enterprise_resource_planning/core/services/api_client.dart';
import 'package:enterprise_resource_planning/data/models/designation_model.dart';

class DesignationService {

  final String baseUrl = "${AppConfig.baseUrl}/designation";

  Future<List<DesignationModel>> getAllDesignations() async {

    final response = await ApiClient.get(
      Uri.parse(baseUrl),
    );

    if(response.statusCode == 200){

      List data = jsonDecode(response.body);

      return data
          .map((e) => DesignationModel.fromJson(e))
          .toList();
    }

    throw Exception("Failed to load designations");
  }

  Future<List<DesignationModel>> getDesignationByDeptId(
      int deptId,
      ) async {

    final response = await ApiClient.get(
      Uri.parse("$baseUrl/by_dept_id/$deptId"),
    );

    if(response.statusCode == 200){

      List data = jsonDecode(response.body);

      return data
          .map((e) => DesignationModel.fromJson(e))
          .toList();
    }

    throw Exception("Failed to load designations");
  }

  Future<void> createDesignation(
      DesignationModel designation,
      ) async {

    final response = await ApiClient.post(
      Uri.parse(baseUrl),
      jsonEncode(designation.toJson()),
    );

    if(response.statusCode != 200){
      throw Exception("Failed to create designation");
    }
  }

  Future<void> updateDesignation(
      int id,
      DesignationModel designation,
      ) async {

    final response = await ApiClient.put(
      Uri.parse("$baseUrl/$id"),
      jsonEncode(designation.toJson()),
    );

    if(response.statusCode != 200){
      throw Exception("Failed to update designation");
    }
  }

  Future<void> deleteDesignation(int id) async {

    final response = await ApiClient.delete(
      Uri.parse("$baseUrl/$id"),
    );

    if(response.statusCode != 200){
      throw Exception("Failed to delete designation");
    }
  }
}