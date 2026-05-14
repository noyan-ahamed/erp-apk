import 'package:enterprise_resource_planning/data/models/department_model.dart';
import 'package:enterprise_resource_planning/data/models/designation_model.dart';
import 'package:enterprise_resource_planning/data/repositories/department_service.dart';
import 'package:enterprise_resource_planning/data/repositories/designation_service.dart';
import 'package:flutter/material.dart';

class DesignationDialog extends StatefulWidget {

  final DesignationModel? designation;

  // ADD THIS
  final VoidCallback onSuccess;

  const DesignationDialog({
    super.key,
    this.designation,

    // ADD THIS
    required this.onSuccess,
  });

  @override
  State<DesignationDialog> createState() => _DesignationDialogState();
}

class _DesignationDialogState extends State<DesignationDialog> {

  final nameController = TextEditingController();

  final designationService = DesignationService();

  final departmentService = DepartmentService();

  List<DepartmentModel> departments = [];

  DepartmentModel? selectedDepartment;

  @override
  void initState() {
    super.initState();

    loadDepartments();

    if(widget.designation != null){

      nameController.text = widget.designation!.name;

      selectedDepartment = widget.designation!.department;
    }
  }

  Future<void> loadDepartments() async {

    final data = await departmentService.getAllDepartments();

    setState(() {
      departments = data;
    });
  }

  void save() async {

    final model = DesignationModel(
      id: widget.designation?.id,
      name: nameController.text,
      department: selectedDepartment!,
    );

    if(widget.designation == null){

      await designationService.createDesignation(model);

    }else{

      await designationService.updateDesignation(
        widget.designation!.id!,
        model,
      );
    }

    // ✅ SUCCESS CALLBACK
    widget.onSuccess();

  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: Text(
        widget.designation == null
            ? "Add Designation"
            : "Update Designation",
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: "Designation Name",
            ),
          ),

          const SizedBox(height: 15),

          DropdownButtonFormField<DepartmentModel>(

            value: selectedDepartment,

            items: departments.map((d){

              return DropdownMenuItem(
                value: d,
                child: Text(d.name),
              );

            }).toList(),

            onChanged: (value){
              setState(() {
                selectedDepartment = value;
              });
            },

            decoration: const InputDecoration(
              labelText: "Department",
            ),
          ),
        ],
      ),

      actions: [

        TextButton(
          onPressed: (){
            widget.onSuccess();
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: save,
          child: const Text("Save"),
        ),
      ],
    );
  }
}