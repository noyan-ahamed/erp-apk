import 'package:enterprise_resource_planning/data/models/ledger/supplier_payment_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupplierPaymentReceiptDialog extends StatelessWidget {
  final SupplierPaymentResponse payment;

  const SupplierPaymentReceiptDialog({
    super.key,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: 70,
              ),
              const SizedBox(height: 12),
              Text(
                "Payment Successful",
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Supplier Voucher",
                style: GoogleFonts.inter(
                  color: Colors.grey.shade600,
                ),
              ),
              const Divider(height: 30),
              _row("Voucher No", payment.voucherNo),
              _row("Supplier", payment.supplierName),
              _row("Date", payment.paymentDate),
              _row("Method", payment.paymentMethod),
              if (payment.purchaseInvoiceNumber != null)
                _row("Invoice No", payment.purchaseInvoiceNumber!),
              const Divider(height: 30),
              _row(
                "Amount Paid",
                "৳ ${payment.amount.toStringAsFixed(2)}",
                bold: true,
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Print feature coming soon"),
                          ),
                        );
                      },
                      icon: const Icon(Icons.print),
                      label: const Text("Print"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Close"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
