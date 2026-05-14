import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/purchase_model.dart';

class PurchaseCard extends StatelessWidget {
  final PurchaseOrderModel order;
  final VoidCallback onView;
  final VoidCallback onApprove;
  final VoidCallback onReceive;
  final VoidCallback onCancel;

  const PurchaseCard({
    super.key,
    required this.order,
    required this.onView,
    required this.onApprove,
    required this.onReceive,
    required this.onCancel,
  });

  Color getStatusColor() {
    switch (order.status) {
      case "PENDING": return Colors.orange;
      case "APPROVED": return Colors.blue;
      case "RECEIVED": return Colors.green;
      case "CANCELLED": return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.invoiceNumber,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.supplier?.name ?? "N/A",
                      style: GoogleFonts.inter(
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: getStatusColor().withOpacity(.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  order.status,
                  style: GoogleFonts.inter(
                    color: getStatusColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  "৳ ${order.totalAmount.toStringAsFixed(2)}",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: onView,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300),
                ),
                child: const Text("Details"),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _actionButton("Approve", order.status == "PENDING" ? onApprove : null, const Color(0xFF6366F1)),
              _actionButton("Receive", order.status == "APPROVED" ? onReceive : null, Colors.green),
              _actionButton("Cancel", (order.status == "RECEIVED" || order.status == "CANCELLED") ? null : onCancel, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, VoidCallback? onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        disabledBackgroundColor: color.withOpacity(0.12),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}