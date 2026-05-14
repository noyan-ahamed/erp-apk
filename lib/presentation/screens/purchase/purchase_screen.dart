import 'package:enterprise_resource_planning/presentation/widgets/purchase/purchase_card.dart';
import 'package:enterprise_resource_planning/presentation/widgets/purchase/purchase_details_dialog.dart';
import 'package:enterprise_resource_planning/presentation/widgets/purchase/purchase_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

import '../../../data/models/purchase_model.dart';
import '../../../data/repositories/purchase_service.dart';

enum PurchaseFilter {
  today,
  last7Days,
  last30Days,
  all,
  custom,
}

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

  PurchaseFilter selectedFilter =
      PurchaseFilter.last7Days;

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

      if(mounted){

        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Failed to load purchases",
        );
      }

    } finally {

      if(mounted){

        setState(() => loading = false);
      }
    }
  }

  void applyFilters() {

    List<PurchaseOrderModel> temp = [...orders];

    final keyword =
    searchController.text.trim().toLowerCase();

    if(keyword.isNotEmpty){

      temp = temp.where((e){

        return e.invoiceNumber
            .toLowerCase()
            .contains(keyword)

            ||

            (e.supplier?.name ?? "")
                .toLowerCase()
                .contains(keyword);

      }).toList();
    }

    final now = DateTime.now();

    if(selectedFilter != PurchaseFilter.all){

      temp = temp.where((e){

        if(e.createdAt == null) return false;

        final date = DateTime.parse(e.createdAt!);

        switch(selectedFilter){

          case PurchaseFilter.today:

            return date.year == now.year
                &&
                date.month == now.month
                &&
                date.day == now.day;

          case PurchaseFilter.last7Days:

            return date.isAfter(
              now.subtract(const Duration(days: 7)),
            );

          case PurchaseFilter.last30Days:

            return date.isAfter(
              now.subtract(const Duration(days: 30)),
            );

          case PurchaseFilter.custom:

            if(fromDate == null || toDate == null){
              return true;
            }

            return date.isAfter(
              fromDate!.subtract(const Duration(days: 1)),
            ) &&
                date.isBefore(
                  toDate!.add(const Duration(days: 1)),
                );

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
    );

    if(result != null){

      fromDate = result.start;

      toDate = result.end;

      selectedFilter = PurchaseFilter.custom;

      applyFilters();
    }
  }

  Future<void> updateStatus(
      PurchaseOrderModel order,
      String status,
      ) async {

    final success = await service.updateStatus(
      order.id!,
      status,
    );

    if(success){

      if(status == "RECEIVED"){

        await service.sendMail(order.id!);
      }

      await loadOrders();

      if(mounted){

        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Status Updated",
        );
      }
    }
  }

  String getFilterText() {

    switch(selectedFilter){

      case PurchaseFilter.today:
        return "Today";

      case PurchaseFilter.last7Days:
        return "Last 7 Days";

      case PurchaseFilter.last30Days:
        return "Last 30 Days";

      case PurchaseFilter.custom:

        if(fromDate == null || toDate == null){
          return "Custom";
        }

        return "${DateFormat.yMMMd().format(fromDate!)} - ${DateFormat.yMMMd().format(toDate!)}";

      case PurchaseFilter.all:
        return "All";
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF8FAFC),

      body: Column(

        children: [

          Container(

            color: Colors.white,

            padding: const EdgeInsets.all(16),

            child: Column(

              children: [

                Row(

                  children: [

                    Expanded(

                      child: TextField(

                        controller: searchController,

                        onChanged: (_) => applyFilters(),

                        decoration: InputDecoration(

                          hintText: "Search invoice or supplier",

                          prefixIcon:
                          const Icon(Icons.search),

                          filled: true,

                          fillColor:
                          const Color(0xFFF1F5F9),

                          border: OutlineInputBorder(

                            borderRadius:
                            BorderRadius.circular(12),

                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    ElevatedButton.icon(

                      onPressed: () async {

                        final result =
                        await showDialog(

                          context: context,

                          barrierDismissible: false,

                          builder: (_) =>
                          const PurchaseDialog(),
                        );

                        if(result == true){

                          await loadOrders();
                        }
                      },

                      icon: const Icon(Icons.add),

                      label:
                      const Text("New Purchase"),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(

                  children: [

                    Expanded(

                      child:
                      DropdownButtonFormField<PurchaseFilter>(

                        value: selectedFilter,

                        decoration: InputDecoration(

                          filled: true,

                          fillColor:
                          const Color(0xFFF1F5F9),

                          border: OutlineInputBorder(

                            borderRadius:
                            BorderRadius.circular(12),

                            borderSide: BorderSide.none,
                          ),
                        ),

                        items: const [

                          DropdownMenuItem(
                            value: PurchaseFilter.today,
                            child: Text("Today"),
                          ),

                          DropdownMenuItem(
                            value: PurchaseFilter.last7Days,
                            child: Text("Last 7 Days"),
                          ),

                          DropdownMenuItem(
                            value: PurchaseFilter.last30Days,
                            child: Text("Last 30 Days"),
                          ),

                          DropdownMenuItem(
                            value: PurchaseFilter.all,
                            child: Text("All"),
                          ),
                        ],

                        onChanged: (v){

                          selectedFilter = v!;

                          applyFilters();
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    OutlinedButton.icon(

                      onPressed: pickDateRange,

                      icon:
                      const Icon(Icons.date_range),

                      label: Text(getFilterText()),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(

            child: loading

                ? const Center(
              child:
              CircularProgressIndicator(),
            )

                : RefreshIndicator(

              onRefresh: loadOrders,

              child: filtered.isEmpty

                  ? ListView(

                children: const [

                  SizedBox(height: 250),

                  Center(
                    child:
                    Text("No purchases found"),
                  ),
                ],
              )

                  : ListView.builder(

                padding:
                const EdgeInsets.all(16),

                itemCount: filtered.length,

                itemBuilder: (context,index){

                  final order = filtered[index];

                  return PurchaseCard(

                    order: order,

                    onView: () {

                      showDialog(

                        context: context,

                        builder: (_) =>
                            PurchaseDetailsDialog(
                              order,
                            ),
                      );
                    },

                    onApprove: () {

                      updateStatus(
                        order,
                        "APPROVED",
                      );
                    },

                    onReceive: () {

                      updateStatus(
                        order,
                        "RECEIVED",
                      );
                    },

                    onCancel: () {

                      updateStatus(
                        order,
                        "CANCELLED",
                      );
                    },
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