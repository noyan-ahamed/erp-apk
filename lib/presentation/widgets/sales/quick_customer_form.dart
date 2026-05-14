import 'package:enterprise_resource_planning/data/providers/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuickCustomerForm
    extends StatelessWidget {

  const QuickCustomerForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Consumer<SalesProvider>(

      builder: (_, provider, __) {

        if(!provider.customerFormVisible){
          return const SizedBox();
        }

        return Container(

          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: const Offset(0, 5),
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
                    Icons.person_add_alt_1_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Create New Customer",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              TextField(

                controller:
                provider.customerNameController,

                decoration: _decoration(context, "Customer Name", Icons.person_outline),
              ),

              const SizedBox(height: 14),

              TextField(

                controller:
                provider.customerMobileController,

                keyboardType:
                TextInputType.phone,

                decoration: _decoration(context, "Mobile Number", Icons.phone_outlined),
              ),

              const SizedBox(height: 14),

              TextField(

                controller:
                provider.customerEmailController,

                keyboardType:
                TextInputType.emailAddress,

                decoration: _decoration(context, "Email Address", Icons.email_outlined),
              ),

              const SizedBox(height: 14),

              TextField(

                controller:
                provider.customerCompanyController,

                decoration: _decoration(context, "Company Name", Icons.business_outlined),
              ),

              const SizedBox(height: 14),

              TextField(

                controller:
                provider.customerAddressController,

                maxLines: 2,

                decoration: _decoration(context, "Address", Icons.location_on_outlined),
              ),

              const SizedBox(height: 22),

              SizedBox(

                width: double.infinity,

                height: 52,

                child: ElevatedButton.icon(

                  onPressed: () async {

                    await provider
                        .createQuickCustomer();
                  },

                  style: ElevatedButton.styleFrom(

                    backgroundColor:
                    const Color(0xff4f46e5),

                    foregroundColor:
                    Colors.white,

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),

                  icon: const Icon(
                    Icons.check_circle_outline,
                  ),

                  label: const Text(
                    "Create Customer",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _decoration(BuildContext context, String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
    );
  }
}