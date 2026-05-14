import 'package:enterprise_resource_planning/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerSearchSection extends StatelessWidget {

  const CustomerSearchSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final provider =
    context.read<SalesProvider>();

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(
            children: [
              Icon(
                Icons.person_search_rounded,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 10),
              Text(
                "Customer Search",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          TextField(

            controller:
            provider.customerSearchController,

            decoration: InputDecoration(
              hintText: "Search by mobile number",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () {
                  provider.searchCustomer();
                },
                icon: const Icon(Icons.arrow_forward_rounded),
              ),
            ),

            onSubmitted: (_) {
              provider.searchCustomer();
            },
          ),
        ],
      ),
    );
  }
}