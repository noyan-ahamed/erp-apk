import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/purchase_model.dart';

class PurchaseDetailsDialog extends StatelessWidget {
  final PurchaseOrderModel order;
  const PurchaseDetailsDialog(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.invoiceNumber,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.status ?? "PENDING",
                    style: const TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              order.supplier?.name ?? "N/A",
              style: GoogleFonts.inter(color: isDark ? Colors.white70 : Colors.black54),
            ),
            const Divider(height: 30),

            // Product Items List
            ...order.items.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.product?.name ?? "Unknown Product",
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                    Text(
                      "${e.quantity} x ৳${e.unitPrice}", // Taka sign add kora hoyeche
                      style: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
                    ),
                  ],
                ),
              );
            }),

            const Divider(),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Total Amount",
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "৳ ${order.totalAmount}", // Dynamic Taka sign
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            )
          ],
        ),
      ),
    );
  }
}