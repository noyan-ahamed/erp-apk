import 'dart:convert';

import 'package:enterprise_resource_planning/core/config/app_config.dart';
import 'package:enterprise_resource_planning/core/services/api_client.dart';
import 'package:enterprise_resource_planning/data/models/department_model.dart';

class DepartmentService {

  final String baseUrl = "${AppConfig.baseUrl}/department";

  Future<List<DepartmentModel>> getAllDepartments() async {

    final response = await ApiClient.get(Uri.parse(baseUrl));

    if(response.statusCode == 200){

      List data = jsonDecode(response.body);

      return data.map((e) => DepartmentModel.fromJson(e)).toList();

    }else{
      throw Exception("Failed to load departments");
    }
  }

  Future<void> createDepartment(DepartmentModel department) async {

    final response = await ApiClient.post(
      Uri.parse(baseUrl),
      jsonEncode(department.toJson()),
    );

    if(response.statusCode != 200){
      throw Exception("Failed to create department");
    }
  }

  Future<void> updateDepartment(int id, DepartmentModel department) async {

    final response = await ApiClient.put(
      Uri.parse("$baseUrl/$id"),
      jsonEncode(department.toJson()),
    );

    if(response.statusCode != 200){
      throw Exception("Failed to update department");
    }
  }

  Future<void> deleteDepartment(int id) async {

    final response = await ApiClient.delete(
      Uri.parse("$baseUrl/$id"),
    );

    if(response.statusCode != 200){
      throw Exception("Failed to delete department");
    }
  }
}