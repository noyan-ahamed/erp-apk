


import 'package:enterprise_resource_planning/data/providers/sales_provider.dart';
import 'package:enterprise_resource_planning/presentation/widgets/sales/sale_invoice_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleSummaryCard
    extends StatelessWidget {

  const SaleSummaryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Consumer<SalesProvider>(
      builder: (_, provider, __) {

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Details",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller:
                  provider.discountPercentController,

                  decoration: const InputDecoration(
                    labelText: "Discount %",
                    prefixIcon: Icon(Icons.percent_outlined),
                  ),

                  keyboardType:
                  TextInputType.number,

                  onChanged: (_) {
                    provider.refreshSummary();
                  },
                ),

                const SizedBox(height: 12),

                TextField(
                  controller:
                  provider.paidAmountController,

                  decoration: const InputDecoration(
                    labelText: "Paid Amount",
                    prefixIcon: Icon(Icons.attach_money_rounded),
                  ),

                  keyboardType:
                  TextInputType.number,

                  onChanged: (_) {
                    provider.refreshSummary();
                  },
                ),

                const SizedBox(height: 20),

                const Divider(height: 32),
                _summaryRow("Subtotal", provider.subTotal.toStringAsFixed(2), context),
                const SizedBox(height: 8),
                _summaryRow("Discount", provider.discountAmount.toStringAsFixed(2), context, color: Colors.redAccent),
                const SizedBox(height: 8),
                _summaryRow("Net Total", provider.netTotal.toStringAsFixed(2), context, isBold: true),
                const SizedBox(height: 8),
                _summaryRow("Due", provider.dueAmount.toStringAsFixed(2), context, color: Colors.orange),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(

                    onPressed: provider.saving
                        ? null
                        : () async {

                      final validation =
                      provider.validateSale();

                      if(validation != null){

                        ScaffoldMessenger.of(context)
                            .showSnackBar(

                          SnackBar(
                            content: Text(validation),
                          ),
                        );

                        return;
                      }

                      try {

                        final sale =
                        await provider.saveSale();

                        if(context.mounted && sale != null){

                          showDialog(

                            context: context,

                            barrierDismissible: false,

                            builder: (_) {

                              return SaleInvoiceDialog(
                                sale: sale,
                              );
                            },

                          ).then((_) {

                            provider.resetAll();
                          });
                        }

                      } catch (e) {

                        ScaffoldMessenger.of(context).showSnackBar(

                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      provider.saving ? "Saving..." : "Complete Sale",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _summaryRow(String title, String value, BuildContext context, {Color? color, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontSize: isBold ? 16 : 14,
            color: color ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}