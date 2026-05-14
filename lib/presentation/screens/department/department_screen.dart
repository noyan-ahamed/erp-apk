import 'package:enterprise_resource_planning/data/models/department_model.dart';
import 'package:enterprise_resource_planning/data/repositories/department_service.dart';
import 'package:enterprise_resource_planning/presentation/widgets/department/department_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  final DepartmentService service = DepartmentService();

  List<DepartmentModel> departments = [];

  bool loading = true;

  bool showForm = false;

  DepartmentModel? selectedDepartment;

  @override
  void initState() {
    super.initState();
    loadDepartments();
  }

  Future<void> loadDepartments() async {
    setState(() => loading = true);

    try {
      final data = await service.getAllDepartments();

      setState(() {
        departments = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  void resetForm() {
    selectedDepartment = null;
  }

  Future<void> deleteDepartment(int id) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Are you sure you want to delete this department?',
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () async {
        Navigator.pop(context);

        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          text: 'Deleting...',
        );

        try {
          await service.deleteDepartment(id);

          if (mounted) {
            Navigator.pop(context);

            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Department deleted successfully!',
            );

            loadDepartments();
          }
        } catch (e) {
          if (mounted) {
            Navigator.pop(context);

            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: 'Delete failed!',
            );
          }
        }
      },
    );
  }

  void onEdit(DepartmentModel department) {
    setState(() {
      showForm = true;
      selectedDepartment = department;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      body: RefreshIndicator(
        onRefresh: loadDepartments,
        color: const Color(0xFF6366F1),

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        showForm = !showForm;

                        if (!showForm) {
                          resetForm();
                        }
                      });
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: showForm
                          ? Colors.grey
                          : const Color(0xFF6366F1),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    icon: Icon(
                      showForm ? Icons.close : Icons.add,
                      color: Colors.white,
                    ),

                    label: Text(
                      showForm ? "Cancel" : "Add Department",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),

                child: showForm
                    ? DepartmentDialog(
                  department: selectedDepartment,
                  onSuccess: () {
                    resetForm();

                    setState(() {
                      showForm = false;
                    });

                    loadDepartments();
                  },
                )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 20),

              loading && departments.isEmpty
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF6366F1),
                ),
              )

                  : departments.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    "No departments found",
                    style: GoogleFonts.inter(
                      color: Colors.grey,
                    ),
                  ),
                ),
              )

                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemCount: departments.length,

                itemBuilder: (context, index) {
                  final d = departments[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),

                      leading: Container(
                        width: 48,
                        height: 48,

                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1)
                              .withOpacity(0.1),

                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Center(
                          child: Text(
                            d.name[0].toUpperCase(),

                            style: const TextStyle(
                              color: Color(0xFF6366F1),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),

                      title: Text(
                        d.name,

                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: const Color(0xFF1E293B),
                        ),
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Color(0xFF64748B),
                              size: 20,
                            ),

                            onPressed: () {
                              onEdit(d);
                            },
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                              size: 20,
                            ),

                            onPressed: () {
                              deleteDepartment(d.id!);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}