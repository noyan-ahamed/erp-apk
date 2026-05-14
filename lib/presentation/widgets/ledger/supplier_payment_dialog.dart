import 'package:enterprise_resource_planning/data/models/ledger/supplier_payment_model.dart';
import 'package:enterprise_resource_planning/data/providers/supplier_ledger_provider.dart';
import 'package:enterprise_resource_planning/presentation/widgets/ledger/supplier_payment_receipt_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupplierPaymentDialog extends StatefulWidget {
  final int supplierId;
  final String supplierName;

  const SupplierPaymentDialog({
    super.key,
    required this.supplierId,
    required this.supplierName,
  });

  @override
  State<SupplierPaymentDialog> createState() => _SupplierPaymentDialogState();
}

class _SupplierPaymentDialogState extends State<SupplierPaymentDialog> {
  final amountCtrl = TextEditingController();

  String method = "CASH";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Make Payment"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: TextEditingController(text: widget.supplierName),
            readOnly: true,
            decoration: const InputDecoration(labelText: "Supplier"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: amountCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Amount"),
          ),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: method,
            isExpanded: true,
            hint: const Text("Payment Method"),
            onChanged: (v) => setState(() => method = v!),
            items: const [
              DropdownMenuItem(value: "CASH", child: Text("Cash")),
              DropdownMenuItem(value: "BANK", child: Text("Bank")),
              DropdownMenuItem(value: "BKASH", child: Text("Bkash")),
              DropdownMenuItem(value: "NAGAD", child: Text("Nagad")),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (amountCtrl.text.isEmpty) return;

            final provider = context.read<SupplierLedgerProvider>();

            final res = await provider.makePayment(
              SupplierPaymentRequest(
                supplierId: widget.supplierId,
                amount: double.parse(amountCtrl.text),
                paymentDate: DateTime.now().toIso8601String().split('T').first,
                paymentMethod: method,
              ),
            );

            if (!context.mounted) return;
            Navigator.pop(context); // close payment dialog

            if (res != null) {
              if (!context.mounted) return;
              showDialog(
                context: context,
                builder: (_) => SupplierPaymentReceiptDialog(payment: res),
              );
            } else {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Payment failed")),
              );
            }
          },
          child: const Text("Pay"),
        )
      ],
    );
  }
}