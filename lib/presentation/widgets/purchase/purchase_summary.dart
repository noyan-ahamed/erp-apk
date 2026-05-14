import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PurchaseSummary extends StatelessWidget {

  final double totalAmount;

  const PurchaseSummary({
    super.key,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {

    return Align(

      alignment: Alignment.centerRight,

      child: Text(

        "Total: ৳ ${totalAmount.toStringAsFixed(2)}",

        style: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }
}