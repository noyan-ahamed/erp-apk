import 'package:enterprise_resource_planning/presentation/widgets/purchase/purchase_card.dart';
import 'package:enterprise_resource_planning/presentation/widgets/purchase/purchase_details_dialog.dart';
import 'package:enterprise_resource_planning/presentation/widgets/purchase/purchase_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

import '../../../data/models/purchase_model.dart';
import '../../../data/repositories/purchase_service.dart';

enum PurchaseFilter { today, last7Days, last30Days, all, custom }

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final PurchaseService service = PurchaseService();
  final searchController = TextEditingController();
  List<PurchaseOrderModel> orders = [];
  List<PurchaseOrderModel> filtered = [];
  bool loading = true;
  PurchaseFilter selectedFilter = PurchaseFilter.last7Days;
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      setState(() => loading = true);
      final data = await service.getAllOrders();
      orders = data;
      applyFilters();
    } catch (e) {
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Failed to load purchases",
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void applyFilters() {
    List<PurchaseOrderModel> temp = [...orders];
    final keyword = searchController.text.trim().toLowerCase();

    if (keyword.isNotEmpty) {
      temp = temp.where((e) {
        return e.invoiceNumber.toLowerCase().contains(keyword) ||
            (e.supplier?.name ?? "").toLowerCase().contains(keyword);
      }).toList();
    }

    final now = DateTime.now();
    if (selectedFilter != PurchaseFilter.all) {
      temp = temp.where((e) {
        if (e.createdAt == null) return false;
        final date = DateTime.parse(e.createdAt!);
        switch (selectedFilter) {
          case PurchaseFilter.today:
            return date.year == now.year && date.month == now.month && date.day == now.day;
          case PurchaseFilter.last7Days:
            return date.isAfter(now.subtract(const Duration(days: 7)));
          case PurchaseFilter.last30Days:
            return date.isAfter(now.subtract(const Duration(days: 30)));
          case PurchaseFilter.custom:
            if (fromDate == null || toDate == null) return true;
            return date.isAfter(fromDate!.subtract(const Duration(days: 1))) &&
                date.isBefore(toDate!.add(const Duration(days: 1)));
          case PurchaseFilter.all:
            return true;
        }
      }).toList();
    }

    setState(() {
      filtered = temp.reversed.toList();
    });
  }

  Future<void> pickDateRange() async {
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFF6366F1),
            ),
          ),
          child: child!,
        );
      },
    );
    if (result != null) {
      fromDate = result.start;
      toDate = result.end;
      selectedFilter = PurchaseFilter.custom;
      applyFilters();
    }
  }

  Future<void> updateStatus(PurchaseOrderModel order, String status) async {
    final success = await service.updateStatus(order.id!, status);
    if (success) {
      if (status == "RECEIVED") await service.sendMail(order.id!);
      await loadOrders();
      if (mounted) {
        QuickAlert.show(context: context, type: QuickAlertType.success, text: "Status Updated");
      }
    }
  }

  String getFilterText() {
    switch (selectedFilter) {
      case PurchaseFilter.today: return "Today";
      case PurchaseFilter.last7Days: return "Last 7 Days";
      case PurchaseFilter.last30Days: return "Last 30 Days";
      case PurchaseFilter.custom:
        if (fromDate == null || toDate == null) return "Custom Range";
        return "${DateFormat.yMMMd().format(fromDate!)} - ${DateFormat.yMMMd().format(toDate!)}";
      case PurchaseFilter.all: return "All Records";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          /// Header Section (Search & Filter)
          Container(
            decoration: BoxDecoration(
              color: isDark ? theme.cardColor : Colors.white,
              border: Border(bottom: BorderSide(color: theme.dividerColor, width: 0.5)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        onChanged: (_) => applyFilters(),
                        style: GoogleFonts.inter(color: theme.colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText: "Search invoice...",
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF6366F1)),
                          filled: true,
                          fillColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF1F5F9),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const PurchaseDialog(),
                        );
                        if (result == true) await loadOrders();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<PurchaseFilter>(
                        value: selectedFilter,
                        dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        style: GoogleFonts.inter(color: theme.colorScheme.onSurface, fontSize: 14),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDark ? theme.scaffoldBackgroundColor : const Color(0xFFF1F5F9),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        items: const [
                          DropdownMenuItem(value: PurchaseFilter.today, child: Text("Today")),
                          DropdownMenuItem(value: PurchaseFilter.last7Days, child: Text("Last 7 Days")),
                          DropdownMenuItem(value: PurchaseFilter.last30Days, child: Text("Last 30 Days")),
                          DropdownMenuItem(value: PurchaseFilter.all, child: Text("All Records")),
                        ],
                        onChanged: (v) {
                          setState(() {
                            selectedFilter = v!;
                            applyFilters();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: pickDateRange,
                      icon: const Icon(Icons.date_range, size: 18),
                      label: Text(getFilterText(), style: const TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: theme.dividerColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// Orders List
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)))
                : RefreshIndicator(
              onRefresh: loadOrders,
              color: const Color(0xFF6366F1),
              child: filtered.isEmpty
                  ? ListView(
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Text(
                      "No purchases found",
                      style: GoogleFonts.inter(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ],
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final order = filtered[index];
                  return PurchaseCard(
                    order: order,
                    onView: () {
                      showDialog(
                        context: context,
                        builder: (_) => PurchaseDetailsDialog(order),
                      );
                    },
                    onApprove: () => updateStatus(order, "APPROVED"),
                    onReceive: () => updateStatus(order, "RECEIVED"),
                    onCancel: () => updateStatus(order, "CANCELLED"),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}