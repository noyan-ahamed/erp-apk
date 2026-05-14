import 'package:enterprise_resource_planning/data/models/employee_model.dart';
import 'package:enterprise_resource_planning/data/repositories/employee_service.dart';
import 'package:enterprise_resource_planning/presentation/widgets/employee/employee_details_dialog.dart';
import 'package:enterprise_resource_planning/presentation/widgets/employee/employee_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {

  final EmployeeService service = EmployeeService();

  List<EmployeeModel> employees = [];
  List<EmployeeModel> filtered = [];

  bool loading = true;

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  Future<void> loadEmployees() async {

    setState(() => loading = true);

    try {

      final data = await service.getAllEmployees();

      setState(() {
        employees = data;
        filtered = data;
        loading = false;
      });

    } catch(e){

      setState(() => loading = false);
    }
  }

  void search(String value){

    setState(() {

      filtered = employees.where((e){

        return e.name.toLowerCase().contains(value.toLowerCase()) ||
            e.mobileNumber.contains(value);

      }).toList();
    });
  }

  Future<void> deleteEmployee(int id) async {

    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Delete this employee?',
      confirmBtnColor: Colors.red,

      onConfirmBtnTap: () async {

        Navigator.pop(context);

        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          text: 'Deleting...',
        );

        try{

          await service.deleteEmployee(id);

          Navigator.pop(context);

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Deleted successfully!',
          );

          loadEmployees();

        }catch(e){

          Navigator.pop(context);

          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Delete failed!',
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: loadEmployees,
        color: const Color(0xFF6366F1),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              color: isDark ? theme.cardColor : Colors.white,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: searchController,
                      onChanged: search,
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        hintText: "Search employee...",
                        prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF6366F1)),
                        filled: true,
                        fillColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (_) => EmployeeDialog(),
                        );
                        if (result == true) loadEmployees();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.add, color: Colors.white, size: 18),
                      label: const Text("Add New", style: TextStyle(color: Colors.white, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)))
                  : filtered.isEmpty
                  ? Center(child: Text("No employees found", style: GoogleFonts.inter(color: Colors.grey)))
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final e = filtered[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => EmployeeDetailsDialog(e),
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      leading: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            e.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF6366F1),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        e.name,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                        ),
                      ),
                      subtitle: Text(
                        "${e.mobileNumber} • ${e.designation?.name ?? ''}",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : const Color(0xFF64748B),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit_outlined, color: isDark ? Colors.white70 : const Color(0xFF64748B), size: 20),
                            onPressed: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (_) => EmployeeDialog(employee: e),
                              );
                              if (result == true) loadEmployees();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                            onPressed: () => deleteEmployee(e.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}