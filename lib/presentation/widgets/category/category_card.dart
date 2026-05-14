import 'package:enterprise_resource_planning/data/models/product_category_model.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final ProductCategory item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = item.status == "ACTIVE";

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? Colors.green : Colors.red,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6)
        ],
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(12),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// STATUS
          Align(
            alignment: Alignment.topRight,
            child: Chip(
              label: Text(item.status ?? ''),
              backgroundColor:
              isActive ? Colors.green.shade100 : Colors.red.shade100,
            ),
          ),

          const SizedBox(height: 8),

          /// TITLE
          Text(
            item.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          /// DESCRIPTION (Flexible use করলাম)
          Flexible(
            child: Text(
              item.description ?? "No description",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 8),

          /// PRODUCT COUNT
          Text(
            "Products: ${item.productCount ?? 0}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),

          const Divider(height: 16),

          /// ACTION BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              ),
            ],
          )
        ],
      ),
    );
  }
}
