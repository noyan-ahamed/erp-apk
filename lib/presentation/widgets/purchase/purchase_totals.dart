import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PurchaseTotals extends StatelessWidget {
  final double subtotal;
  final double vat;
  final double grandTotal;

  const PurchaseTotals({
    super.key,
    required this.subtotal,
    required this.vat,
    required this.grandTotal,
  });

  Widget row(BuildContext context, String title, double value, {bool isBold = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: isDark ? Colors.white70 : Colors.black54,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "৳ ${value.toStringAsFixed(2)}",
            style: GoogleFonts.inter(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          row(context, "Subtotal", subtotal),
          row(context, "VAT", vat),
          Divider(color: isDark ? Colors.white24 : Colors.grey.shade300),
          row(context, "Grand Total", grandTotal, isBold: true),
        ],
      ),
    );
  }
}