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

  Color getStatusColor(){

    switch(order.status){

      case "PENDING":
        return Colors.orange;

      case "APPROVED":
        return Colors.blue;

      case "RECEIVED":
        return Colors.green;

      case "CANCELLED":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 10,
            offset: const Offset(0,4),
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
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      order.supplier?.name ?? "",

                      style: GoogleFonts.inter(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Container(

                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: getStatusColor().withOpacity(.1),
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Text(
                  order.status,

                  style: GoogleFonts.inter(
                    color: getStatusColor(),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
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
                  ),
                ),
              ),

              OutlinedButton(
                onPressed: onView,
                child: const Text("Details"),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Wrap(

            spacing: 8,

            runSpacing: 8,

            children: [

              ElevatedButton(

                onPressed:
                order.status == "PENDING"
                    ? onApprove
                    : null,

                child: const Text("Approve"),
              ),

              ElevatedButton(

                onPressed:
                order.status == "APPROVED"
                    ? onReceive
                    : null,

                child: const Text("Receive"),
              ),

              ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),

                onPressed:
                order.status == "RECEIVED" ||
                    order.status == "CANCELLED"
                    ? null
                    : onCancel,

                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}