import 'package:flutter/material.dart';

class PaymentTermsDropdown
    extends StatelessWidget {

  final String value;

  final Function(String?) onChanged;

  const PaymentTermsDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return DropdownButtonFormField<String>(

      value: value,

      decoration: const InputDecoration(
        labelText: "Payment Terms",
        border: OutlineInputBorder(),
      ),

      items: const [

        DropdownMenuItem(
          value: "7 Days",
          child: Text("7 Days"),
        ),

        DropdownMenuItem(
          value: "15 Days",
          child: Text("15 Days"),
        ),

        DropdownMenuItem(
          value: "30 Days",
          child: Text("30 Days"),
        ),
      ],

      onChanged: onChanged,
    );
  }
}