import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentTermsDropdown extends StatelessWidget {
  final String value;
  final Function(String?) onChanged;

  const PaymentTermsDropdown({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      style: GoogleFonts.inter(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: "Payment Terms",
        labelStyle: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
        ),
      ),
      items: const [
        DropdownMenuItem(value: "7 Days", child: Text("7 Days")),
        DropdownMenuItem(value: "15 Days", child: Text("15 Days")),
        DropdownMenuItem(value: "30 Days", child: Text("30 Days")),
      ],
      onChanged: onChanged,
    );
  }
}