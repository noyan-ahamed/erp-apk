import 'package:enterprise_resource_planning/data/models/ledger/supplier_ledger_model.dart';
import 'package:enterprise_resource_planning/data/providers/supplier_ledger_provider.dart';
import 'package:enterprise_resource_planning/presentation/widgets/ledger/supplier_payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupplierLedgerDetailsDialog extends StatefulWidget {
  final int supplierId;
  final String supplierName;
  final double currentDue;

  const SupplierLedgerDetailsDialog({
    super.key,
    required this.supplierId,
    required this.supplierName,
    required this.currentDue,
  });

  @override
  State<SupplierLedgerDetailsDialog> createState() =>
      _SupplierLedgerDetailsDialogState();
}

class _SupplierLedgerDetailsDialogState
    extends State<SupplierLedgerDetailsDialog> {
  bool isLoading = true;
  List<SupplierLedgerDetails> details = [];

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final provider = context.read<SupplierLedgerProvider>();
    final data = await provider.getSupplierLedgerDetails(widget.supplierId);
    if (mounted) {
      setState(() {
        details = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Name - ${widget.supplierName}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // Name boro hole thik thakbe
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const Divider(),
            if (isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (details.isEmpty)
              const Expanded(
                child: Center(child: Text("No ledger records found.")),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: details.length,
                  itemBuilder: (context, index) {
                    final d = details[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(
                            "${d.transactionType} - ${d.referenceNo ?? 'N/A'}"),
                        subtitle: Text(d.date ?? ''),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (d.debit > 0)
                              Text("Dr: \$${d.debit}",
                                  style: const TextStyle(color: Colors.red, fontSize: 12)),
                            if (d.credit > 0)
                              Text("Cr: \$${d.credit}",
                                  style: const TextStyle(color: Colors.green, fontSize: 12)),
                            Text("Bal: \$${d.runningBalance}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const Divider(),
            // --- FIX START HERE ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( // Text-ke Expanded kora hoyeche jate overflow na hoy
                  child: Text(
                    "Current Due: \$${widget.currentDue}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8), // Majhkane ektu faka
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => SupplierPaymentDialog(
                        supplierId: widget.supplierId,
                        supplierName: widget.supplierName,
                      ),
                    ).then((_) {
                      setState(() {
                        isLoading = true;
                      });
                      _fetchDetails();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  icon: const Icon(Icons.payment, size: 18),
                  label: const Text("Pay Now", style: TextStyle(fontSize: 13)),
                )
              ],
            )
            // --- FIX END HERE ---
          ],
        ),
      ),
    );
  }
}