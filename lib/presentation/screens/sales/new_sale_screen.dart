import 'package:enterprise_resource_planning/data/providers/sales_provider.dart';
import 'package:enterprise_resource_planning/data/repositories/customer_service.dart';
import 'package:enterprise_resource_planning/data/repositories/product_service.dart';
import 'package:enterprise_resource_planning/data/repositories/sales_service.dart';
import 'package:enterprise_resource_planning/presentation/widgets/sales/customer_search_section.dart';
import 'package:enterprise_resource_planning/presentation/widgets/sales/quick_customer_form.dart';
import 'package:enterprise_resource_planning/presentation/widgets/sales/sale_items_table.dart';
import 'package:enterprise_resource_planning/presentation/widgets/sales/sale_summary_card.dart';
import 'package:enterprise_resource_planning/presentation/widgets/sales/selected_customer_card.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewSaleScreen extends StatelessWidget {

  const NewSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(

      create: (_) => SalesProvider(
        salesService: SalesService(),
        productService: ProductService(),
        customerService: CustomerService(),
      )..loadProducts(),

      child: const _NewSaleView(),
    );
  }
}

class _NewSaleView extends StatelessWidget {

  const _NewSaleView();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.background,

      body: Consumer<SalesProvider>(

        builder: (_, provider, __) {

          return SingleChildScrollView(

            padding: const EdgeInsets.all(18),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 24),

                const CustomerSearchSection(),

                const SizedBox(height: 18),

                const SelectedCustomerCard(),

                const SizedBox(height: 18),

                const QuickCustomerForm(),

                const SizedBox(height: 18),

                const SaleItemsTable(),

                const SizedBox(height: 18),

                const SaleSummaryCard(),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}