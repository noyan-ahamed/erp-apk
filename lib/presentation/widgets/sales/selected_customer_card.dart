import 'package:enterprise_resource_planning/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectedCustomerCard
    extends StatelessWidget {

  const SelectedCustomerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final provider =
    context.watch<SalesProvider>();

    final customer =
        provider.selectedCustomer;

    if(customer == null){
      return const SizedBox();
    }

    return Container(

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        gradient: const LinearGradient(
          colors: [
            Color(0xff4f46e5),
            Color(0xff6366f1),
          ],
        ),

        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Row(

        children: [

          Container(

            padding:
            const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 32,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  customer.name,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  customer.mobileNumber,

                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}