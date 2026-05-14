import 'package:enterprise_resource_planning/data/models/ledger/customer_ledger_model.dart';
import 'package:enterprise_resource_planning/data/providers/customer_ledger_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerLedgerDetailsDialog extends StatefulWidget {
  final int customerId;
  final String customerName;
  final double currentDue;

  const CustomerLedgerDetailsDialog({
    super.key,
    required this.customerId,
    required this.customerName,
    required this.currentDue,
  });

  @override
  State<CustomerLedgerDetailsDialog> createState() =>
      _CustomerLedgerDetailsDialogState();
}

class _CustomerLedgerDetailsDialogState
    extends State<CustomerLedgerDetailsDialog> {
  bool isLoading = true;
  List<CustomerLedgerDetails> details = [];

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final provider = context.read<CustomerLedgerProvider>();
    final data = await provider.getCustomerLedgerDetails(widget.customerId);
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
                    "Name - ${widget.customerName}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                              Text("Debit: \$${d.debit}",
                                  style: const TextStyle(color: Colors.red)),
                            if (d.credit > 0)
                              Text("Credit: \$${d.credit}",
                                  style: const TextStyle(color: Colors.green)),
                            Text("Balance: \$${d.runningBalance}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Current Due: \$${widget.currentDue}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
