import 'package:enterprise_resource_planning/data/models/supplier_model.dart';
import 'package:enterprise_resource_planning/presentation/widgets/supplier/supplier_details_dialog.dart';
import 'package:enterprise_resource_planning/presentation/widgets/supplier/supplier_dialog.dart';
import 'package:flutter/material.dart';


class SupplierCard extends StatelessWidget {
  final SupplierModel supplier;
  final VoidCallback onDelete;

  const SupplierCard({required this.supplier, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(supplier.name),
        subtitle: Text(supplier.mobileNumber),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            IconButton(
              icon: Icon(Icons.visibility),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => SupplierDetailsDialog(supplier),
                );
              },
            ),

            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => SupplierDialog(supplier: supplier),
                );
              },
            ),

            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
