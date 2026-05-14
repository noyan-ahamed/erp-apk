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

    return DropdownSearch<SupplierModel>(

      selectedItem: selectedSupplier,

      items: suppliers,

      compareFn: (a,b) => a.id == b.id,

      itemAsString: (SupplierModel s) => s.name,

      popupProps: const PopupProps.menu(

        showSearchBox: true,
      ),

      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Supplier",
          border: OutlineInputBorder(),
        ),
      ),

      onChanged: onChanged,
    );
  }
}