import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../../data/models/supplier_model.dart';

class SupplierSelector extends StatelessWidget {
  final List<SupplierModel> suppliers;
  final SupplierModel? selectedSupplier;
  final Function(SupplierModel?) onChanged;

  const SupplierSelector({
    super.key,
    required this.suppliers,
    required this.selectedSupplier,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DropdownSearch<SupplierModel>(
      selectedItem: selectedSupplier,
      items: suppliers,
      compareFn: (a, b) => a.id == b.id,
      itemAsString: (SupplierModel s) => s.name,
      popupProps: PopupProps.menu(
        showSearchBox: true,
        menuProps: MenuProps(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        ),
        searchFieldProps: TextFieldProps(
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: "Search supplier...",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Supplier",
          labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
          filled: true,
          fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey),
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}