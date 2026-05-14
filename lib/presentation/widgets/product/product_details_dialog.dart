import 'package:enterprise_resource_planning/data/models/product_model.dart';
import 'package:flutter/material.dart';

class ProductDetailsDialog
    extends StatelessWidget {

  final ProductModel product;

  const ProductDetailsDialog(
      this.product,
      {super.key}
      );

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: Text(product.name),

      content: Column(
        mainAxisSize: MainAxisSize.min,

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          info("SKU", product.sku),

          info(
            "Category",
            product.category['name'],
          ),

          info(
            "Stock",
            product.stock.toString(),
          ),

          info(
            "Selling Price",
            "৳ ${product.sellingPrice}",
          ),

          info(
            "Min Stock",
            product.minStockLevel.toString(),
          ),

          info(
            "Status",
            product.status,
          ),
        ],
      ),
    );
  }

  Widget info(
      String title,
      String value,
      ){

    return Padding(

      padding:
      const EdgeInsets.only(bottom: 12),

      child: Row(

        children: [

          Text("$title : "),

          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}