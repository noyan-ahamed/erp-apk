import 'package:enterprise_resource_planning/data/providers/approve_payment_provider.dart';
import 'package:enterprise_resource_planning/data/repositories/customer_payment_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class ApprovePaymentScreen extends StatelessWidget {
  const ApprovePaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ApprovePaymentProvider(service: CustomerPaymentService())
        ..fetchPayments(),
      child: const _ApprovePaymentView(),
    );
  }
}

class _ApprovePaymentView extends StatefulWidget {
  const _ApprovePaymentView();

  @override
  State<_ApprovePaymentView> createState() => _ApprovePaymentViewState();
}

class _ApprovePaymentViewState extends State<_ApprovePaymentView> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ApprovePaymentProvider>();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      labelText: "Search customer/mobile",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (v) => provider.search(v),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: provider.status,
                    decoration: const InputDecoration(
                      labelText: "Filter",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: "ALL", child: Text("All")),
                      DropdownMenuItem(
                          value: "PENDING_APPROVAL", child: Text("Pending")),
                      DropdownMenuItem(
                          value: "APPROVED", child: Text("Approved")),
                      DropdownMenuItem(
                          value: "REJECTED", child: Text("Rejected")),
                    ],
                    onChanged: (v) {
                      if (v != null) provider.setFilter(v);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: provider.payments.length,
                    itemBuilder: (context, index) {
                      final p = provider.payments[index];

                      Color statusColor = Colors.grey;
                      if (p.status == "PENDING_APPROVAL") statusColor = Colors.orange;
                      if (p.status == "APPROVED") statusColor = Colors.green;
                      if (p.status == "REJECTED") statusColor = Colors.red;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      p.customerName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(
                                      p.status,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: statusColor,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text("Mobile: ${p.customerMobile}"),
                              Text("Voucher: ${p.voucherNo}"),
                              Text("Date: ${p.paymentDate}"),
                              Text("Method: ${p.paymentMethod}"),
                              Text(
                                "Amount: \$ ${p.amount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              if (p.status == "PENDING_APPROVAL") ...[
                                const Divider(),
                                Wrap(
                                  alignment: WrapAlignment.end,
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () =>
                                          _handleReject(context, p.id),
                                      icon: const Icon(Icons.cancel,
                                          color: Colors.red, size: 18),
                                      label: const Text("Reject",
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          _handleApprove(context, p.id),
                                      icon: const Icon(Icons.check, size: 18),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      label: const Text("Approve"),
                                    ),
                                  ],
                                )
                              ]
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  void _handleApprove(BuildContext context, int id) async {
    final remarksCtrl = TextEditingController();
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Approve Payment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Are you sure you want to approve this payment?"),
            const SizedBox(height: 10),
            TextField(
              controller: remarksCtrl,
              decoration: const InputDecoration(labelText: "Remarks (optional)"),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Approve"),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final success = await context
          .read<ApprovePaymentProvider>()
          .approvePayment(id, remarksCtrl.text);


      if (success && context.mounted) {
        context.read<ApprovePaymentProvider>().fetchPayments();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Payment approved successfully!",
        );
      } else if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Failed to approve payment.",
        );
      }
    }
  }

  void _handleReject(BuildContext context, int id) async {
    final remarksCtrl = TextEditingController();
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reject Payment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Are you sure you want to reject this payment?"),
            const SizedBox(height: 10),
            TextField(
              controller: remarksCtrl,
              decoration: const InputDecoration(
                labelText: "Reason for rejection",
                hintText: "Required",
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (remarksCtrl.text.isEmpty) return;
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Reject"),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final success = await context
          .read<ApprovePaymentProvider>()
          .rejectPayment(id, remarksCtrl.text);

      if (success && context.mounted) {
        context.read<ApprovePaymentProvider>().fetchPayments();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Payment rejected.",
        );
      } else if (context.mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Failed to reject payment.",
        );
      }
    }
  }
}
