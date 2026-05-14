import 'dart:convert';

import 'package:enterprise_resource_planning/core/config/app_config.dart';
import 'package:enterprise_resource_planning/core/services/api_client.dart';
import 'package:enterprise_resource_planning/data/models/employee_model.dart';

class EmployeeService {

  final String baseUrl =
      "${AppConfig.baseUrl}/employees";

  Future<List<EmployeeModel>> getAllEmployees() async {

    final response = await ApiClient.get(
      Uri.parse(baseUrl),
    );

    if(response.statusCode == 200){

      List data = jsonDecode(response.body);

      return data
          .map((e) => EmployeeModel.fromJson(e))
          .toList();
    }

    throw Exception("Failed to load employees");
  }

  Future<EmployeeModel> createEmployee(
      EmployeeModel employee,
      String role,
      ) async {

    final url = role == "HR"
        ? "$baseUrl/hr"
        : baseUrl;

    final response = await ApiClient.post(
      Uri.parse(url),
      jsonEncode(employee.toJson()),
    );

    if(response.statusCode == 200 ||
        response.statusCode == 201){

      return EmployeeModel.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(response.body);
  }

  Future<EmployeeModel> updateEmployee(
      int id,
      EmployeeModel employee,
      ) async {

    final response = await ApiClient.put(
      Uri.parse("$baseUrl/$id"),
      jsonEncode(employee.toJson()),
    );

    if(response.statusCode == 200 ||
        response.statusCode == 204){

      return EmployeeModel.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(response.body);
  }

  Future<void> deleteEmployee(int id) async {

    final response = await ApiClient.delete(
      Uri.parse("$baseUrl/$id"),
    );

    if(response.statusCode != 204){
      throw Exception("Failed to delete employee");
    }
  }
}