import 'package:enterprise_resource_planning/data/providers/customer_payment_provider.dart';
import 'package:enterprise_resource_planning/data/repositories/customer_payment_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class CustomerPaymentScreen extends StatelessWidget {
  const CustomerPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomerPaymentProvider(
        service: CustomerPaymentService(),
      ),
      child: const _CustomerPaymentView(),
    );
  }
}

class _CustomerPaymentView extends StatelessWidget {
  const _CustomerPaymentView();

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerPaymentProvider>(
      builder: (context, provider, __) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          // Background color ta surface korlam jate dark/light mode e thik thake
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: const Text("Customer Payment"),
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 1. SEARCH BOX SECTION
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: provider.searchController,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface, // Text color set kora holo
                        ),
                        decoration: InputDecoration(
                          hintText: "Search mobile or customer",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          // Search box er color light/dark mode onujayi change hobe
                          fillColor: isDark ? Colors.white10 : const Color(0xFFF1F5F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: provider.searching
                              ? null
                              : () async {
                            try {
                              await provider.searchCustomer();
                            } catch (e) {
                              if (context.mounted) {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.error,
                                  text: e.toString(),
                                );
                              }
                            }
                          },
                          icon: provider.searching
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.person_search_rounded),
                          label: Text(
                            provider.searching ? "Searching..." : "Search Customer",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 2. CUSTOMER INFO CARD
                if (provider.customer != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4F46E5).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.customer!.customerName,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          provider.customer!.mobileNumber,
                          style: GoogleFonts.inter(color: Colors.white70),
                        ),
                        const Divider(color: Colors.white24, height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _info("Total Sales", "৳${provider.customer!.totalSales.toStringAsFixed(0)}"),
                            _info("Paid", "৳${provider.customer!.totalApprovedPayment.toStringAsFixed(0)}"),
                            _info("Due", "৳${provider.customer!.currentDue.toStringAsFixed(0)}", isDue: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. PAYMENT FORM
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: provider.amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Payment Amount",
                            prefixIcon: Icon(Icons.payments_outlined),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: "Payment Method",
                            prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                            border: OutlineInputBorder(),
                          ),
                          value: provider.paymentMethod,
                          items: const [
                            DropdownMenuItem(value: "CASH", child: Text("Cash")),
                            DropdownMenuItem(value: "BANK", child: Text("Bank")),
                            DropdownMenuItem(value: "MOBILE_BANKING", child: Text("Mobile Banking")),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              provider.paymentMethod = value;
                              provider.notifyListeners();
                            }
                          },
                          dropdownColor: Theme.of(context).cardColor,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: provider.remarksController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: "Remarks (Optional)",
                            prefixIcon: Icon(Icons.note_alt_outlined),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: provider.saving
                                ? null
                                : () async {
                              try {
                                final response = await provider.submitPayment();
                                if (context.mounted && response != null) {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    title: "Payment Submitted",
                                    text: "Voucher: ${response.voucherNo}\nWaiting for admin approval.",
                                  );
                                  provider.reset();
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    text: e.toString(),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4F46E5),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              provider.saving ? "Submitting..." : "Submit Payment",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _info(String label, String value, {bool isDue = false}) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            color: isDue ? Colors.yellowAccent : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}