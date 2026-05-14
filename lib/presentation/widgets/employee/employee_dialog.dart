import 'package:enterprise_resource_planning/data/models/designation_model.dart';
import 'package:enterprise_resource_planning/data/models/employee_model.dart';
import 'package:enterprise_resource_planning/data/repositories/designation_service.dart';
import 'package:enterprise_resource_planning/data/repositories/employee_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class EmployeeDialog extends StatefulWidget {

  final EmployeeModel? employee;

  const EmployeeDialog({
    super.key,
    this.employee,
  });

  @override
  State<EmployeeDialog> createState() =>
      _EmployeeDialogState();
}

class _EmployeeDialogState
    extends State<EmployeeDialog> {

  final _formKey = GlobalKey<FormState>();

  final nameController =
  TextEditingController();

  final emailController =
  TextEditingController();

  final mobileController =
  TextEditingController();

  final addressController =
  TextEditingController();

  final salaryController =
  TextEditingController();

  final joiningDateController =
  TextEditingController();

  final EmployeeService employeeService =
  EmployeeService();

  final DesignationService
  designationService =
  DesignationService();

  List<DesignationModel> designations = [];

  DesignationModel? selectedDesignation;

  String selectedRole = "EMPLOYEE";

  bool loading = false;

  @override
  void initState() {

    super.initState();

    loadDesignations();

    if(widget.employee != null){

      final e = widget.employee!;

      nameController.text = e.name;

      emailController.text = e.email;

      mobileController.text =
          e.mobileNumber;

      addressController.text =
          e.address;

      salaryController.text =
          e.basicSalary.toString();

      joiningDateController.text =
          e.joiningDate;

      selectedRole =
          widget.employee?.role ??
              "EMPLOYEE";
    }
  }

  Future<void> loadDesignations() async {

    try {

      final data =
      await designationService
          .getAllDesignations();

      setState(() {

        designations = data;
      });

      if(widget.employee != null){

        selectedDesignation =
            designations.firstWhere(
                  (d) =>
              d.id ==
                  widget.employee!
                      .designation['id'],
            );

        setState(() {});
      }

    } catch(e){

      debugPrint(e.toString());
    }
  }

  Future<void> saveEmployee() async {

    if(!_formKey.currentState!
        .validate()) {
      return;
    }

    if(selectedDesignation == null){

      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text:
        "Please select designation",
      );

      return;
    }

    setState(() => loading = true);

    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      text: widget.employee == null
          ? "Creating employee..."
          : "Updating employee...",
    );

    final employee = EmployeeModel(

      id: widget.employee?.id,

      name:
      nameController.text.trim(),

      email:
      emailController.text.trim(),

      mobileNumber:
      mobileController.text.trim(),

      address:
      addressController.text.trim(),

      basicSalary:
      double.parse(
        salaryController.text.trim(),
      ),

      joiningDate:
      joiningDateController.text,

      designation:
      selectedDesignation!,

      role: selectedRole,
    );

    try {

      if(widget.employee == null){

        await employeeService
            .createEmployee(
          employee,
          selectedRole,
        );

      } else {

        await employeeService
            .updateEmployee(
          widget.employee!.id!,
          employee,
        );
      }

      if(mounted){

        Navigator.pop(context);

        Navigator.pop(context, true);

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text:
          widget.employee == null
              ? "Employee created successfully!"
              : "Employee updated successfully!",
        );
      }

    } catch(e){

      Navigator.pop(context);

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: e.toString(),
      );
    }

    setState(() => loading = false);
  }

  Widget buildField({
    required TextEditingController
    controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {

    return TextFormField(

      controller: controller,

      keyboardType: keyboardType,

      maxLines: maxLines,

      validator: (v){

        if(v == null ||
            v.trim().isEmpty){

          return "Required";
        }

        return null;
      },

      decoration: InputDecoration(

        labelText: label,

        prefixIcon: Icon(
          icon,
          color: const Color(
              0xFF6366F1),
        ),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Padding(

        padding: const EdgeInsets.all(20),

        child: Form(

          key: _formKey,

          child: SingleChildScrollView(

            child: Column(

              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Row(

                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

                  children: [

                    Text(

                      widget.employee == null
                          ? "Add Employee"
                          : "Edit Employee",

                      style:
                      GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    IconButton(

                      onPressed: () {
                        Navigator.pop(
                            context);
                      },

                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),

                const Divider(),

                const SizedBox(height: 20),

                buildField(
                  controller:
                  nameController,
                  label:
                  "Employee Name",
                  icon:
                  Icons.person_outline,
                ),

                const SizedBox(height: 16),

                buildField(
                  controller:
                  emailController,
                  label: "Email",
                  icon:
                  Icons.email_outlined,
                  keyboardType:
                  TextInputType
                      .emailAddress,
                ),

                const SizedBox(height: 16),

                buildField(
                  controller:
                  mobileController,
                  label: "Mobile",
                  icon:
                  Icons.phone_outlined,
                  keyboardType:
                  TextInputType.phone,
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<
                    DesignationModel>(

                  value:
                  selectedDesignation,

                  items:
                  designations.map((d){

                    return DropdownMenuItem(
                      value: d,
                      child: Text(d.name),
                    );

                  }).toList(),

                  onChanged: (v){

                    setState(() {

                      selectedDesignation =
                          v;
                    });
                  },

                  validator: (v){

                    if(v == null){

                      return
                        "Select designation";
                    }

                    return null;
                  },

                  decoration:
                  InputDecoration(

                    labelText:
                    "Designation",

                    prefixIcon:
                    const Icon(
                      Icons
                          .badge_outlined,
                      color: Color(
                          0xFF6366F1),
                    ),

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                          12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                buildField(
                  controller:
                  salaryController,
                  label: "Salary",
                  icon: Icons
                      .currency_exchange,
                  keyboardType:
                  TextInputType.number,
                ),

                if(widget.employee ==
                    null) ...[

                  const SizedBox(
                      height: 16),

                  DropdownButtonFormField<
                      String>(

                    value: selectedRole,

                    items: const [

                      DropdownMenuItem(
                        value:
                        "EMPLOYEE",
                        child: Text(
                            "Employee"),
                      ),

                      DropdownMenuItem(
                        value: "HR",
                        child:
                        Text("HR"),
                      ),
                    ],

                    onChanged: (v){

                      setState(() {

                        selectedRole =
                        v!;
                      });
                    },

                    decoration:
                    InputDecoration(

                      labelText:
                      "Role",

                      prefixIcon:
                      const Icon(
                        Icons
                            .admin_panel_settings_outlined,
                        color: Color(
                            0xFF6366F1),
                      ),

                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                            12),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                TextFormField(

                  controller:
                  joiningDateController,

                  readOnly: true,

                  validator: (v){

                    if(v == null ||
                        v.isEmpty){

                      return
                        "Select joining date";
                    }

                    return null;
                  },

                  onTap: () async {

                    final pickedDate =
                    await showDatePicker(

                      context: context,

                      initialDate:
                      DateTime.now(),

                      firstDate:
                      DateTime(2000),

                      lastDate:
                      DateTime(2100),
                    );

                    if(pickedDate !=
                        null){

                      joiningDateController
                          .text =
                      pickedDate
                          .toString()
                          .split(
                          " ")[0];

                      setState(() {});
                    }
                  },

                  decoration:
                  InputDecoration(

                    labelText:
                    "Joining Date",

                    prefixIcon:
                    const Icon(
                      Icons
                          .calendar_month_outlined,
                      color: Color(
                          0xFF6366F1),
                    ),

                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                          12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                buildField(
                  controller:
                  addressController,
                  label: "Address",
                  icon: Icons
                      .location_on_outlined,
                  maxLines: 2,
                ),

                const SizedBox(height: 24),

                SizedBox(

                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    onPressed: loading
                        ? null
                        : saveEmployee,

                    style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                      const Color(
                          0xFF6366F1),

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                            12),
                      ),
                    ),

                    child: Text(

                      widget.employee ==
                          null
                          ? "Save Employee"
                          : "Update Employee",

                      style:
                      GoogleFonts.poppins(
                        color:
                        Colors.white,
                        fontWeight:
                        FontWeight
                            .bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}