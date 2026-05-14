import 'package:enterprise_resource_planning/data/models/supplier_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupplierDetailsDialog extends StatelessWidget {
  final SupplierModel s;
  const SupplierDetailsDialog(this.s, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(s.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _infoRow(context, "Mobile", s.mobileNumber, Icons.phone),
            _infoRow(context, "Email", s.email, Icons.email),
            _infoRow(context, "Address", s.address, Icons.location_on),
            _infoRow(context, "TIN", s.tinNumber, Icons.badge),
            _infoRow(context, "Payment", s.paymentTerms, Icons.payments),
            _infoRow(context, "Status", s.status, Icons.info_outline),
            // Jodi balance thake tobe taka sign e bhabe dekhabe
            // _infoRow(context, "Balance", "৳ ${s.openingBalance ?? 0}", Icons.account_balance_wallet),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))
      ],
    );
  }

  Widget _infoRow(BuildContext context, String label, String? value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6366F1)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                Text(value ?? "-", style: GoogleFonts.inter(fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}