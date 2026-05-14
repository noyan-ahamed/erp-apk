import 'package:enterprise_resource_planning/data/models/designation_model.dart';

class EmployeeModel {

  final int? id;
  final String name;
  final String email;
  final String mobileNumber;
  final String address;
  final double basicSalary;
  final String joiningDate;
  final DesignationModel? designation;
  final String role;

  EmployeeModel({
    this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.address,
    required this.basicSalary,
    required this.joiningDate,
    required this.designation,
    required this.role,
  });

  factory EmployeeModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return EmployeeModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobileNumber:
      json['mobileNumber'] ?? '',
      address: json['address'] ?? '',
      basicSalary:
      (json['basicSalary'] ?? 0)
          .toDouble(),
      joiningDate:
      json['joiningDate'] ?? '',
      designation: json['designation'] != null
          ? DesignationModel.fromJson(json['designation'])
          : null,
      role: json['user'] != null &&
          json['user']['roles'] != null &&
          json['user']['roles'].isNotEmpty
          ? json['user']['roles'][0]['name']
          : "EMPLOYEE",
    );
  }

  Map<String, dynamic> toJson() {

    return {
      "name": name,
      "email": email,
      "mobileNumber": mobileNumber,
      "address": address,
      "basicSalary": basicSalary,
      "joiningDate": joiningDate,
      "designationId": designation?.id,
    };
  }
}