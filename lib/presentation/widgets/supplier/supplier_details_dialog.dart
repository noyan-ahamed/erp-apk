import 'package:enterprise_resource_planning/data/models/supplier_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SupplierDetailsDialog extends StatelessWidget {
  final SupplierModel s;

  SupplierDetailsDialog(this.s);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(s.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          info("Mobile", s.mobileNumber),
          info("Email", s.email),
          info("Address", s.address),
          info("TIN", s.tinNumber),
          info("Payment", s.paymentTerms),
          info("Status", s.status),
        ],
      ),
    );
  }

  Widget info(String label, String? value) {
    return Row(
      children: [
        Text("$label: "),
        Expanded(child: Text(value ?? "-")),
      ],
    );
  }
}
