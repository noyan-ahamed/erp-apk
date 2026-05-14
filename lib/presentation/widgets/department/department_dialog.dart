import 'package:enterprise_resource_planning/data/models/department_model.dart';
import 'package:enterprise_resource_planning/data/repositories/department_service.dart';
import 'package:flutter/material.dart';

class DepartmentDialog extends StatefulWidget {

  final DepartmentModel? department;
  final VoidCallback onSuccess;

  const DepartmentDialog({super.key, this.department , required this.onSuccess});

  @override
  State<DepartmentDialog> createState() => _DepartmentDialogState();
}

class _DepartmentDialogState extends State<DepartmentDialog> {

  final nameController = TextEditingController();

  final service = DepartmentService();

  @override
  void initState() {
    super.initState();

    if(widget.department != null){
      nameController.text = widget.department!.name;
    }
  }

  void save() async {

    final model = DepartmentModel(
      id: widget.department?.id,
      name: nameController.text,
    );

    if(widget.department == null){
      await service.createDepartment(model);
    }else{
      await service.updateDepartment(widget.department!.id!, model);
    }

    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(
        widget.department == null
            ? "Add Department"
            : "Update Department",
      ),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(
          hintText: "Department Name",
        ),
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