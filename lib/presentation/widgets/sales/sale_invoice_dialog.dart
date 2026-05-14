import 'package:enterprise_resource_planning/data/models/sales/sales_response.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SaleInvoiceDialog extends StatelessWidget {

  final SalesResponse sale;

  const SaleInvoiceDialog({
    super.key,
    required this.sale,
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
              "Sale Completed",
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "ERP Invoice",
              style: GoogleFonts.inter(
                color: Colors.grey.shade600,
              ),
            ),

            const Divider(height: 30),

            _row(
              "Invoice",
              sale.invoiceNumber,
            ),

            _row(
              "Customer",
              sale.customerName,
            ),

            _row(
              "Mobile",
              sale.customerMobile,
            ),

            _row(
              "Date",
              sale.salesDate,
            ),

            const Divider(height: 30),

            _row(
              "Sub Total",
              "৳ ${sale.subTotal.toStringAsFixed(2)}",
            ),

            _row(
              "Discount",
              "৳ ${sale.discountAmount.toStringAsFixed(2)}",
            ),

            _row(
              "Net Total",
              "৳ ${sale.netTotal.toStringAsFixed(2)}",
              bold: true,
            ),

            _row(
              "Paid",
              "৳ ${sale.paidAmount.toStringAsFixed(2)}",
            ),

            _row(
              "Due",
              "৳ ${sale.dueAmount.toStringAsFixed(2)}",
              color: sale.dueAmount > 0
                  ? Colors.red
                  : Colors.green,
            ),

            const Divider(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Items",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            ...sale.items.map((item){

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),

                child: Row(
                  children: [

                    Expanded(
                      child: Text(
                        item.productName,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                        ),
                      ),
                    ),

                    Text(
                      "${item.quantity} x ${item.unitPrice}",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),

            Row(
              children: [

                Expanded(
                  child: OutlinedButton.icon(

                    onPressed: () {

                      ScaffoldMessenger.of(context).showSnackBar(

                        const SnackBar(
                          content: Text(
                            "Print feature coming soon",
                          ),
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

        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

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
              fontWeight:
              bold
                  ? FontWeight.bold
                  : FontWeight.w600,

              color: color,
            ),
          ),
        ],
      ),
    );
  }
}