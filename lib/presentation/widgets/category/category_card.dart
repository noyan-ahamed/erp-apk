import 'package:enterprise_resource_planning/data/models/product_category_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = item.status == "ACTIVE";

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border.all(
          color: isActive
              ? Colors.green.withOpacity(0.5)
              : Colors.red.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// STATUS & ICON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.status ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.green : Colors.red,
                  ),
                ),
              ),
              Icon(
                Icons.category_rounded,
                size: 18,
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// TITLE
          Text(
            item.name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          /// DESCRIPTION
          Expanded(
            child: Text(
              item.description ?? "No description provided",
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isDark ? Colors.white60 : Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 8),

          /// PRODUCT COUNT
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.inventory_2_outlined, size: 14, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  "Products: ${item.productCount ?? 0}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, thickness: 0.5),
          ),

          /// ACTION BUTTONS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _actionButton(
                icon: Icons.edit_note_rounded,
                color: Colors.blue,
                onTap: onEdit,
                isDark: isDark,
              ),
              Container(width: 1, height: 20, color: theme.dividerColor),
              _actionButton(
                icon: Icons.delete_outline_rounded,
                color: Colors.redAccent,
                onTap: onDelete,
                isDark: isDark,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Icon(icon, color: color.withOpacity(0.9), size: 22),
      ),
    );
  }
}