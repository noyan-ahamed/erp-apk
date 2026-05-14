import 'package:enterprise_resource_planning/data/providers/supplier_ledger_provider.dart';
import 'package:enterprise_resource_planning/presentation/widgets/ledger/supplier_ledger_details_dialog.dart';
import 'package:enterprise_resource_planning/presentation/widgets/ledger/supplier_payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SupplierLedgerScreen extends StatefulWidget {
  const SupplierLedgerScreen({super.key});

  @override
  State<SupplierLedgerScreen> createState() => _SupplierLedgerScreenState();
}

class _SupplierLedgerScreenState extends State<SupplierLedgerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SupplierLedgerProvider>().loadSuppliers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SupplierLedgerProvider>();

    return Scaffold(
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: provider.suppliers.length,
        itemBuilder: (context, index) {
          final s = provider.suppliers[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(s.supplierName),
              subtitle: Text("Due: ${s.currentDue}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => SupplierLedgerDetailsDialog(
                          supplierId: s.supplierId,
                          supplierName: s.supplierName,
                          currentDue: s.currentDue,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.payment),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => SupplierPaymentDialog(
                          supplierId: s.supplierId,
                          supplierName: s.supplierName,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}