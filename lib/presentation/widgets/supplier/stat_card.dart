import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatCard extends StatelessWidget {
  final String title;
  final double value; // Value double e thaka valo taka hole
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Card(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(title, style: GoogleFonts.inter(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Text(
                "৳ ${value.toInt()}", // Ekhane dollar bad diye taka sign deya hoyeche
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}