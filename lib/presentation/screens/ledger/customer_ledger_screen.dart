import 'package:enterprise_resource_planning/data/providers/customer_ledger_provider.dart';
import 'package:enterprise_resource_planning/presentation/widgets/ledger/customer_ledger_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerLedgerScreen extends StatefulWidget {
  const CustomerLedgerScreen({super.key});

  @override
  State<CustomerLedgerScreen> createState() => _CustomerLedgerScreenState();
}

class _CustomerLedgerScreenState extends State<CustomerLedgerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CustomerLedgerProvider>().loadCustomers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CustomerLedgerProvider>();

    return Scaffold(
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.customers.length,
              itemBuilder: (context, index) {
                final c = provider.customers[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(c.customerName),
                    subtitle: Text("Due: \$${c.currentDue}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => CustomerLedgerDetailsDialog(
                            customerId: c.customerId,
                            customerName: c.customerName,
                            currentDue: c.currentDue,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
