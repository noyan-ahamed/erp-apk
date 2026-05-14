import 'package:enterprise_resource_planning/data/models/supplier_model.dart';
import 'package:enterprise_resource_planning/data/repositories/supplier_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class SupplierDialog extends StatefulWidget {
  final SupplierModel? supplier;

  const SupplierDialog({super.key, this.supplier});

  @override
  State<SupplierDialog> createState() => _SupplierDialogState();
}

class _SupplierDialogState extends State<SupplierDialog> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final mobile = TextEditingController();
  final email = TextEditingController();
  final company = TextEditingController();
  final address = TextEditingController();

  final service = SupplierService();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      name.text = widget.supplier!.name;
      mobile.text = widget.supplier!.mobileNumber;
      email.text = widget.supplier!.email;
      company.text = widget.supplier!.companyName ?? "";
      address.text = widget.supplier!.address ?? "";
    }
  }

  void save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);
    
    // Show loading
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      text: widget.supplier == null ? 'Creating supplier...' : 'Updating supplier...',
    );

    final model = SupplierModel(
      id: widget.supplier?.id,
      name: name.text,
      mobileNumber: mobile.text,
      email: email.text,
      companyName: company.text.isEmpty ? null : company.text,
      address: address.text.isEmpty ? null : address.text,
      status: widget.supplier?.status ?? "ACTIVE",
      paymentTerms: widget.supplier?.paymentTerms ?? "CASH",
    );

    try {
      if (widget.supplier == null) {
        await service.createSupplier(model);
      } else {
        await service.updateSupplier(widget.supplier!.id!, model);
      }

      if (mounted) {
        Navigator.pop(context); // Close loading
        Navigator.pop(context, true); // Close dialog and return true
        
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Supplier ${widget.supplier == null ? 'created' : 'updated'} successfully!',
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        setState(() => isSaving = false);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Operation failed: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.supplier == null ? "Add New Supplier" : "Edit Supplier",
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const SizedBox(height: 16),
                _buildField(name, "Full Name", Icons.person, (v) => v!.isEmpty ? "Required" : null),
                const SizedBox(height: 12),
                _buildField(mobile, "Mobile Number", Icons.phone, (v) => v!.isEmpty ? "Required" : null, keyboardType: TextInputType.phone),
                const SizedBox(height: 12),
                _buildField(email, "Email Address", Icons.email, null, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 12),
                _buildField(company, "Company Name", Icons.business, null),
                const SizedBox(height: 12),
                _buildField(address, "Office Address", Icons.location_on, null, maxLines: 2),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: isSaving ? null : () => Navigator.pop(context),
                        child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isSaving ? null : save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          isSaving ? "Saving..." : "Save Now",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, String? Function(String?)? validator, {TextInputType? keyboardType, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: const Color(0xFF6366F1)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
