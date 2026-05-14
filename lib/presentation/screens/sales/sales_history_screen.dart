import 'package:enterprise_resource_planning/data/models/sales/sales_history_model.dart';
import 'package:enterprise_resource_planning/data/providers/sales_provider.dart';
import 'package:enterprise_resource_planning/data/repositories/customer_service.dart';
import 'package:enterprise_resource_planning/data/repositories/product_service.dart';
import 'package:enterprise_resource_planning/data/repositories/sales_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SalesHistoryScreen extends StatelessWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SalesProvider(
        salesService: SalesService(),
        productService: ProductService(),
        customerService: CustomerService(),
      )..loadSalesHistory(),
      child: const _SalesHistoryView(),
    );
  }
}

class _SalesHistoryView extends StatefulWidget {
  const _SalesHistoryView();

  @override
  State<_SalesHistoryView> createState() => _SalesHistoryViewState();
}

class _SalesHistoryViewState extends State<_SalesHistoryView> {
  final TextEditingController searchController = TextEditingController();
  List<SalesHistoryModel> filteredSales = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<SalesProvider>(context, listen: false);
    filteredSales = provider.salesHistory;
  }

  void filterSales(String value) {
    final provider = Provider.of<SalesProvider>(context, listen: false);
    setState(() {
      final search = value.toLowerCase();
      filteredSales = provider.salesHistory.where((sale) {
        return sale.invoiceNumber.toLowerCase().contains(search) ||
            sale.customerName.toLowerCase().contains(search) ||
            sale.customerMobile.toLowerCase().contains(search) ||
            (sale.sellerEmployeeName ?? '').toLowerCase().contains(search);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<SalesProvider>(
      builder: (context, provider, child) {
        if (searchController.text.isEmpty) {
          filteredSales = provider.salesHistory;
        }

        return Scaffold(
          // Background Color fix
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: provider.salesHistoryLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// SEARCH BOX (Dark mode fixed)
                TextField(
                  controller: searchController,
                  onChanged: filterSales,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    hintText: "Search invoice / customer / mobile",
                    hintStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: isDark ? Colors.white10 : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                /// DATE PICKER
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          provider.selectedDate.toString().split(" ").first,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: provider.selectedDate,
                            firstDate: DateTime(2024),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            provider.selectedDate = picked;
                            await provider.loadSalesHistory();
                            filterSales(searchController.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Change"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                /// MONTHLY TOTAL
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Monthly Sales",
                        style: GoogleFonts.inter(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "৳ ${provider.monthlyTotal.toStringAsFixed(2)}",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                /// SALES LIST
                Expanded(
                  child: filteredSales.isEmpty
                      ? Center(
                    child: Text(
                      "No sales found",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemCount: filteredSales.length,
                    itemBuilder: (context, index) {
                      final sale = filteredSales[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    sale.invoiceNumber,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: sale.dueAmount > 0
                                        ? Colors.red.withOpacity(0.1)
                                        : Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "Due: ৳${sale.dueAmount}",
                                    style: GoogleFonts.inter(
                                      color: sale.dueAmount > 0 ? Colors.redAccent : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildRow(context, "Customer", sale.customerName),
                            _buildRow(context, "Mobile", sale.customerMobile),
                            _buildRow(context, "Seller", sale.sellerEmployeeName ?? '-'),
                            _buildRow(context, "Date", sale.salesDate),
                            const Divider(height: 28),
                            _buildRow(context, "Sub Total", "৳ ${sale.subTotal}"),
                            _buildRow(context, "Discount", "৳ ${sale.discountAmount}"),
                            _buildRow(context, "Net Total", "৳ ${sale.netTotal}"),
                            _buildRow(context, "Paid", "৳ ${sale.paidAmount}"),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}