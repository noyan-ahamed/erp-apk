import 'package:flutter/material.dart';

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

  Widget row(String title, double value){

    return Padding(

      padding: const EdgeInsets.only(bottom: 8),

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children: [

          Text(title),

          Text(
            "৳ ${value.toStringAsFixed(2)}",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        row("Subtotal", subtotal),

        row("VAT", vat),

        const Divider(),

        row("Grand Total", grandTotal),
      ],
    );
  }
}