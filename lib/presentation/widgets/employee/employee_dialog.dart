import 'package:enterprise_resource_planning/data/models/department_model.dart';
import 'package:enterprise_resource_planning/data/models/designation_model.dart';
import 'package:enterprise_resource_planning/data/models/employee_model.dart';
import 'package:enterprise_resource_planning/data/repositories/department_service.dart';
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

  final DepartmentService departmentService =
  DepartmentService();

  final DesignationService designationService =
  DesignationService();

  List<DepartmentModel> departments = [];

  List<DesignationModel> designations = [];

  DepartmentModel? selectedDepartment;

  DesignationModel? selectedDesignation;

  String selectedRole = "EMPLOYEE";

  bool loading = false;

  @override
  void initState() {

    super.initState();

    initializeData();
  }

  Future<void> initializeData() async {

    await loadDepartments();

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
          e.role;

      // designation -> department
      final deptId =
          e.designation?.department.id;

      if(deptId != null){

        try {

          selectedDepartment =
              departments.firstWhere(
                    (d) => d.id == deptId,
              );

        } catch (_) {}
      }

      // load designation by department
      if(selectedDepartment != null){

        await loadDesignationByDepartment(
          selectedDepartment!.id!,
        );

        try {

          selectedDesignation =
              designations.firstWhere(
                    (d) =>
                d.id ==
                    e.designation?.id,
              );

        } catch (_) {}
      }

      setState(() {});
    }
  }

  Future<void> loadDepartments() async {

    try {

      final data =
      await departmentService
          .getAllDepartments();

      setState(() {

        departments = data;
      });

    } catch (e) {

      debugPrint(e.toString());
    }
  }

  Future<void> loadDesignationByDepartment(
      int deptId,
      ) async {

    try {

      final data =
      await designationService
          .getDesignationByDeptId(
        deptId,
      );

      setState(() {

        designations = data;
      });

    } catch(e){

      debugPrint(e.toString());
    }
  }

  Future<void> saveEmployee() async {

    if(!_formKey.currentState!
        .validate()) {
      return;
    }

    if(selectedDepartment == null){

      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text:
        "Please select department",
      );

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
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      validator: (v) => (v == null || v.trim().isEmpty) ? "Required" : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
        prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: isDark ? const BorderSide(color: Colors.white12) : BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.employee == null ? "Add Employee" : "Edit Employee",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: isDark ? Colors.white60 : Colors.black54),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      buildField(controller: nameController, label: "Employee Name", icon: Icons.person_outline),
                      const SizedBox(height: 16),
                      buildField(controller: emailController, label: "Email", icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 16),
                      buildField(controller: mobileController, label: "Mobile", icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                      const SizedBox(height: 16),

                      // Department Dropdown
                      _customDropdown<DepartmentModel>(
                        label: "Department",
                        icon: Icons.business_outlined,
                        value: selectedDepartment,
                        items: departments.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(),
                        onChanged: (v) async {
                          setState(() { selectedDepartment = v; selectedDesignation = null; designations = []; });
                          if (v != null) await loadDesignationByDepartment(v.id!);
                        },
                      ),
                      const SizedBox(height: 16),

                      // Designation Dropdown
                      _customDropdown<DesignationModel>(
                        label: "Designation",
                        icon: Icons.badge_outlined,
                        value: selectedDesignation,
                        items: designations.map((d) => DropdownMenuItem(value: d, child: Text(d.name))).toList(),
                        onChanged: (v) => setState(() => selectedDesignation = v),
                      ),
                      const SizedBox(height: 16),

                      buildField(controller: salaryController, label: "Salary", icon: Icons.currency_exchange, keyboardType: TextInputType.number),
                      const SizedBox(height: 16),

                      if (widget.employee == null) ...[
                        _customDropdown<String>(
                          label: "Role",
                          icon: Icons.admin_panel_settings_outlined,
                          value: selectedRole,
                          items: const [
                            DropdownMenuItem(value: "EMPLOYEE", child: Text("Employee")),
                            DropdownMenuItem(value: "HR", child: Text("HR")),
                          ],
                          onChanged: (v) => setState(() => selectedRole = v!),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Date Picker Field
                      _datePickerField(isDark),
                      const SizedBox(height: 16),

                      buildField(controller: addressController, label: "Address", icon: Icons.location_on_outlined, maxLines: 2),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: loading ? null : saveEmployee,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(widget.employee == null ? "Save Employee" : "Update Employee",
                      style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customDropdown<T>({required String label, required IconData icon, required T? value, required List<DropdownMenuItem<T>> items, required ValueChanged<T?> onChanged}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      validator: (v) => v == null ? "Select $label" : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
        prefixIcon: Icon(icon, color: const Color(0xFF6366F1)),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _datePickerField(bool isDark) {
    return TextFormField(
      controller: joiningDateController,
      readOnly: true,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      validator: (v) => (v == null || v.isEmpty) ? "Select joining date" : null,
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() => joiningDateController.text = pickedDate.toString().split(" ")[0]);
        }
      },
      decoration: InputDecoration(
        labelText: "Joining Date",
        labelStyle: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
        prefixIcon: const Icon(Icons.calendar_month_outlined, color: Color(0xFF6366F1)),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}