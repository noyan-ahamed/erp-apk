import 'package:dropdown_search/dropdown_search.dart';
import 'package:enterprise_resource_planning/data/models/product_model.dart';
import 'package:flutter/material.dart';



class PurchaseItemRow extends StatelessWidget {

  final Map<String,dynamic> item;

  final List<ProductModel> products;

  final int index;

  final VoidCallback onChanged;

  final VoidCallback onDelete;

  const PurchaseItemRow({
    super.key,
    required this.item,
    required this.products,
    required this.index,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        border: Border.all(
          color: Colors.grey.shade300,
        ),

        borderRadius:
        BorderRadius.circular(16),
      ),

      child: Column(

        children: [

          DropdownSearch<ProductModel>(

            selectedItem: item["product"],

          items: products,

            compareFn: (a,b) => a.id == b.id,

            itemAsString:
                (ProductModel p) => p.name,

            popupProps:
            const PopupProps.menu(

              showSearchBox: true,
            ),

            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Product",
                border: OutlineInputBorder(),
              ),
            ),

            onChanged: (v){

              item["product"] = v;

              onChanged();
            },
          ),

          const SizedBox(height: 12),

          Row(

            children: [

              Expanded(

                child: TextFormField(

                  initialValue:
                  item["quantity"].toString(),

                  keyboardType:
                  TextInputType.number,

                  decoration:
                  const InputDecoration(

                    labelText: "Quantity",

                    border:
                    OutlineInputBorder(),
                  ),

                  onChanged: (v){

                    item["quantity"] =
                        int.tryParse(v) ?? 1;

                    onChanged();
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(

                child:
                DropdownButtonFormField<String>(

                  value: item["unit"],

                  decoration:
                  const InputDecoration(

                    labelText: "Unit",

                    border:
                    OutlineInputBorder(),
                  ),

                  items: const [

                    DropdownMenuItem(
                      value: "Pcs",
                      child: Text("Pcs"),
                    ),

                    DropdownMenuItem(
                      value: "Kg",
                      child: Text("Kg"),
                    ),

                    DropdownMenuItem(
                      value: "Box",
                      child: Text("Box"),
                    ),
                  ],

                  onChanged: (v){

                    item["unit"] = v;

                    onChanged();
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(

            children: [

              Expanded(

                child: TextFormField(

                  initialValue:
                  item["unitPrice"].toString(),

                  keyboardType:
                  const TextInputType.numberWithOptions(
                    decimal: true,
                  ),

                  decoration:
                  const InputDecoration(

                    labelText: "Unit Price",

                    prefixText: "৳ ",

                    border:
                    OutlineInputBorder(),
                  ),

                  onChanged: (v){

                    item["unitPrice"] =
                        double.tryParse(v) ?? 0;

                    onChanged();
                  },
                ),
              ),

              IconButton(

                onPressed: onDelete,

                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}