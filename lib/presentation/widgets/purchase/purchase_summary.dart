import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PurchaseSummary extends StatelessWidget {
  final double totalAmount;
  const PurchaseSummary({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Grand Total",
            style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : Colors.black54
            ),
          ),
          Text(
            "৳ ${totalAmount.toStringAsFixed(2)}",
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}