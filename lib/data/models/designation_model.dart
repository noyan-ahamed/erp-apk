import 'department_model.dart';

class DesignationModel {
  final int? id;
  final String name;
  final DepartmentModel department;

  DesignationModel({
    this.id,
    required this.name,
    required this.department,
  });

  factory DesignationModel.fromJson(Map<String, dynamic> json) {
    return DesignationModel(
      id: json['id'],
      name: json['name'],
      department: DepartmentModel.fromJson(json['department']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "department": {
        "id": department.id,
      }
    };
  }
}