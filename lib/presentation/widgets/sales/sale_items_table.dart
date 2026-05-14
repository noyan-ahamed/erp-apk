
import 'package:enterprise_resource_planning/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SaleItemsTable
    extends StatelessWidget {

  const SaleItemsTable({
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
                  "Sale Items",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                ListView.builder(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount:
                  provider.saleItems.length,

                  itemBuilder: (_, index) {

                    final item =
                    provider.saleItems[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (index > 0)
                            InkWell(
                              onTap: () {
                                // Add remove logic if provider supports it
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Icon(Icons.close, size: 20, color: Colors.redAccent),
                              ),
                            ),
                          DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              labelText: "Select Product",
                              prefixIcon: Icon(Icons.inventory_2_outlined),
                            ),
                            value: item.productId,
                            items: provider.products.map((p) {
                              return DropdownMenuItem<int>(
                                value: p.id,
                                child: Text(p.name ?? "Unknown"),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              final product = provider.products.firstWhere((e) => e.id == value);
                              provider.onProductSelected(index, product);
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            initialValue: item.quantity.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Quantity",
                              prefixIcon: Icon(Icons.add_shopping_cart),
                            ),
                            onChanged: (value) {
                              provider.updateQuantity(
                                index,
                                int.tryParse(value) ?? 1,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: provider.addItemRow,
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text("Add Another Product"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      foregroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
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
}