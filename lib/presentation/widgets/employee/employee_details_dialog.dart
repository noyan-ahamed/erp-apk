import 'package:enterprise_resource_planning/data/models/employee_model.dart';
import 'package:flutter/material.dart';

class EmployeeDetailsDialog extends StatelessWidget {

  final EmployeeModel employee;

  const EmployeeDetailsDialog(
      this.employee,
      {super.key}
      );

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      title: Text(employee.name),

      content: SingleChildScrollView(

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            info("Email", employee.email),

            info(
              "Mobile",
              employee.mobileNumber,
            ),

            info(
              "Designation",
              employee.designation['name'],
            ),

            info(
              "Role",
              employee.role,
            ),

            info(
              "Salary",
              employee.basicSalary.toString(),
            ),

            info(
              "Joining Date",
              employee.joiningDate,
            ),

            info(
              "Address",
              employee.address,
            ),
          ],
        ),
      ),
    );
  }

  Widget info(
      String label,
      String value,
      ) {

    return Padding(

      padding: const EdgeInsets.only(
        bottom: 12,
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          SizedBox(
            width: 100,

            child: Text(
              "$label :",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}