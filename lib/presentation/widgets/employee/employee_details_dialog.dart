import 'package:enterprise_resource_planning/data/models/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmployeeDetailsDialog extends StatelessWidget {
  final EmployeeModel employee;
  const EmployeeDetailsDialog(this.employee, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
            child: Text(
              employee.name[0].toUpperCase(),
              style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            employee.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            const SizedBox(height: 8),
            info(context, "Email", employee.email, Icons.email_outlined),
            info(context, "Mobile", employee.mobileNumber, Icons.phone_outlined),
            info(context, "Designation", employee.designation?.name ?? 'N/A', Icons.badge_outlined),
            info(context, "Role", employee.role, Icons.admin_panel_settings_outlined),
            info(context, "Salary", "৳ ${employee.basicSalary.toString()}", Icons.currency_exchange),
            info(context, "Joining Date", employee.joiningDate, Icons.calendar_month_outlined),
            info(context, "Address", employee.address, Icons.location_on_outlined),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close", style: TextStyle(color: Color(0xFF6366F1))),
        ),
      ],
    );
  }

  Widget info(BuildContext context, String label, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6366F1).withOpacity(0.7)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white38 : Colors.black38,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}