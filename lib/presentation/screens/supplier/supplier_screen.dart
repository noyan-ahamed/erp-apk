import 'package:enterprise_resource_planning/data/models/supplier_model.dart';
import 'package:enterprise_resource_planning/data/repositories/supplier_service.dart';
import 'package:enterprise_resource_planning/presentation/widgets/supplier/supplier_details_dialog.dart';
import 'package:enterprise_resource_planning/presentation/widgets/supplier/supplier_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final SupplierService _service = SupplierService();
  List<SupplierModel> suppliers = [];
  List<SupplierModel> filtered = [];
  bool isLoading = true;
  bool showForm = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSuppliers();
  }

  Future<void> loadSuppliers() async {
    setState(() => isLoading = true);
    try {
      final data = await _service.getAllSuppliers();
      setState(() {
        suppliers = data;
        filtered = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void deleteSupplier(SupplierModel supplier) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to delete ${supplier.name}?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () async {
        Navigator.pop(context); 
        QuickAlert.show(context: context, type: QuickAlertType.loading, text: 'Deleting...');
        try {
          await _service.deleteSupplier(supplier.id!);
          if (mounted) {
            Navigator.pop(context);
            QuickAlert.show(context: context, type: QuickAlertType.success, text: 'Deleted successfully!');
            loadSuppliers();
          }
        } catch (e) {
          if (mounted) {
            Navigator.pop(context);
            QuickAlert.show(context: context, type: QuickAlertType.error, text: 'Delete failed.');
          }
        }
      },
    );
  }

  void search(String value) {
    setState(() {
      filtered = suppliers
          .where((s) =>
              s.name.toLowerCase().contains(value.toLowerCase()) ||
              s.mobileNumber.contains(value))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: RefreshIndicator(
        onRefresh: loadSuppliers,
        color: const Color(0xFF6366F1),
        child: Column(
          children: [
            // 🔍 SEARCH & ADD BUTTON ROW
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              color: Colors.white,
              child: Row(
                children: [
                  // Search Field (3/4)
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: searchController,
                      onChanged: search,
                      decoration: InputDecoration(
                        hintText: "Search supplier...",
                        prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF6366F1)),
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Add Button
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(

                      onPressed: () async {

                        setState(() {
                          showForm = true;
                        });

                        final result = await showDialog(
                          context: context,
                          builder: (_) => const SupplierDialog(),
                        );

                        setState(() {
                          showForm = false;
                        });

                        if(result == true){
                          loadSuppliers();
                        }
                      },

                      style: ElevatedButton.styleFrom(

                        backgroundColor: showForm
                            ? Colors.grey
                            : const Color(0xFF6366F1),

                        foregroundColor: Colors.white,

                        elevation: 0,

                        padding: const EdgeInsets.symmetric(vertical: 14),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      icon: Icon(
                        showForm ? Icons.close : Icons.add,
                        color: Colors.white,
                      ),

                      label: Text(
                        showForm ? "Close" : "Add New",

                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: isLoading 
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)))
                : filtered.isEmpty
                  ? Center(child: Text("No suppliers found", style: GoogleFonts.inter(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final s = filtered[index];
                        return _buildSupplierItem(s);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierItem(SupplierModel s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        onTap: () => showDialog(context: context, builder: (_) => SupplierDetailsDialog(s)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: const Color(0xFF6366F1).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(s.name[0].toUpperCase(), style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 18))),
        ),
        title: Text(s.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: const Color(0xFF1E293B))),
        subtitle: Text(s.mobileNumber, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Color(0xFF64748B), size: 20),
              onPressed: () async {
                final result = await showDialog(context: context, builder: (_) => SupplierDialog(supplier: s));
                if (result == true) loadSuppliers();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
              onPressed: () => deleteSupplier(s),
            ),
          ],
        ),
      ),
    );
  }
}
