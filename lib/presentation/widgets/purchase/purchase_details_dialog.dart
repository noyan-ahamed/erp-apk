import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/purchase_model.dart';

class PurchaseDetailsDialog extends StatelessWidget {

  final PurchaseOrderModel order;

  const PurchaseDetailsDialog(this.order,{super.key});

  @override
  Widget build(BuildContext context) {

    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Container(

        padding: const EdgeInsets.all(20),

        child: Column(

          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              order.invoiceNumber,

              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              order.supplier?.name ?? "",
            ),

            const Divider(height: 30),

            ...order.items.map((e){

              return Padding(

                padding: const EdgeInsets.only(bottom: 12),

                child: Row(

                  children: [

                    Expanded(
                      child: Text(e.product?.name ?? ""),
                    ),

                    Text("${e.quantity} x ${e.unitPrice}"),
                  ],
                ),
              );
            }),

            const Divider(),

            Align(

              alignment: Alignment.centerRight,

              child: Text(

                "Total: ৳ ${order.totalAmount}",

                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}