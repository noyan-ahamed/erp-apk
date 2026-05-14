import 'package:enterprise_resource_planning/data/models/product_category_model.dart';
import 'package:enterprise_resource_planning/data/models/product_model.dart';
import 'package:enterprise_resource_planning/data/repositories/product_category_service.dart';
import 'package:enterprise_resource_planning/data/repositories/product_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class ProductDialog extends StatefulWidget {

  final ProductModel? product;

  const ProductDialog({
    super.key,
    this.product,
  });

  @override
  State<ProductDialog> createState() =>
      _ProductDialogState();
}

class _ProductDialogState
    extends State<ProductDialog> {

  final _formKey = GlobalKey<FormState>();

  final nameController =
  TextEditingController();

  final skuController =
  TextEditingController();

  List<ProductCategory> categories = [];

  ProductCategory? selectedCategory;

  String status = "ACTIVE";

  final ProductService service =
  ProductService();

  final ProductCategoryService
  categoryService =
  ProductCategoryService();

  bool loading = false;

  @override
  void initState() {

    super.initState();

    loadCategories();

    if(widget.product != null){

      final p = widget.product!;

      nameController.text = p.name;

      skuController.text = p.sku;

      status = p.status;
    }
  }

  Future<void> loadCategories() async {

    try {

      final data =
      await categoryService
          .getAllCategories();

      setState(() {

        categories = data;
      });

      if(widget.product != null){

        selectedCategory =
            categories.firstWhere(
                  (c) =>
              c.id ==
                  widget.product!
                      .category.id,
            );

        setState(() {});
      }

    } catch(e){

      debugPrint(e.toString());
    }
  }

  Future<void> save() async {

    if(!_formKey.currentState!
        .validate()) {
      return;
    }

    if(widget.product == null &&
        selectedCategory == null){

      QuickAlert.show(

        context: context,

        type: QuickAlertType.warning,

        text: "Select category",
      );

      return;
    }

    setState(() => loading = true);

    QuickAlert.show(

      context: context,

      type: QuickAlertType.loading,

      text: widget.product == null
          ? "Creating product..."
          : "Updating product...",
    );

    try {

      if(widget.product != null){

        await service.updateProduct(
          widget.product!.id!,
          nameController.text,
        );

      } else {

        final product = ProductModel(

          name:
          nameController.text.trim(),

          sku:
          skuController.text.trim(),

          minStockLevel: 5,

          status: status,

          createdAt:
          DateTime.now()
              .toString()
              .split(" ")[0],

          sellingPrice: 0,

          stock: 0,

          category: selectedCategory!,
        );

        await service.createProduct(
            product);
      }

      if(mounted){

        Navigator.pop(context);

        Navigator.pop(context, true);

        QuickAlert.show(

          context: context,

          type: QuickAlertType.success,

          text: widget.product == null
              ? "Product created successfully!"
              : "Product updated successfully!",
        );
      }

    } catch(e){

      Navigator.pop(context);

      QuickAlert.show(

        context: context,

        type: QuickAlertType.error,

        text: e.toString(),
      );
    }

    setState(() => loading = false);
  }

  Widget buildField({

    required TextEditingController
    controller,

    required String label,

    required IconData icon,

    bool enabled = true,
  }) {

    return TextFormField(

      controller: controller,

      enabled: enabled,

      validator: (v){

        if(v == null ||
            v.trim().isEmpty){

          return "Required";
        }

        return null;
      },

      decoration: InputDecoration(

        labelText: label,

        prefixIcon: Icon(
          icon,
          color:
          const Color(0xFF6366F1),
        ),

        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(

      shape: RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Padding(

        padding: const EdgeInsets.all(20),

        child: Form(

          key: _formKey,

          child: SingleChildScrollView(

            child: Column(

              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Row(

                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

                  children: [

                    Text(

                      widget.product == null
                          ? "Add Product"
                          : "Edit Product",

                      style:
                      GoogleFonts.poppins(

                        fontSize: 20,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    IconButton(

                      onPressed: (){
                        Navigator.pop(
                            context);
                      },

                      icon:
                      const Icon(Icons.close),
                    ),
                  ],
                ),

                const Divider(),

                const SizedBox(height: 20),

                buildField(

                  controller:
                  nameController,

                  label:
                  "Product Name",

                  icon:
                  Icons.inventory_2_outlined,
                ),

                const SizedBox(height: 16),

                buildField(

                  controller:
                  skuController,

                  label: "SKU",

                  icon:
                  Icons.qr_code_outlined,

                  enabled:
                  widget.product == null,
                ),

                const SizedBox(height: 16),

                if(widget.product == null)

                  DropdownButtonFormField<
                      ProductCategory>(

                    value: selectedCategory,

                    items:
                    categories.map((e){

                      return DropdownMenuItem(

                        value: e,

                        child: Text(e.name),
                      );

                    }).toList(),

                    onChanged: (v){

                      setState(() {

                        selectedCategory =
                            v;
                      });
                    },

                    validator: (v){

                      if(v == null){

                        return
                          "Select category";
                      }

                      return null;
                    },

                    decoration:
                    InputDecoration(

                      labelText:
                      "Category",

                      prefixIcon:
                      const Icon(

                        Icons
                            .category_outlined,

                        color: Color(
                            0xFF6366F1),
                      ),

                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius
                            .circular(
                            12),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                SizedBox(

                  width: double.infinity,

                  height: 50,

                  child: ElevatedButton(

                    onPressed: loading
                        ? null
                        : save,

                    style:
                    ElevatedButton.styleFrom(

                      backgroundColor:
                      const Color(
                          0xFF6366F1),

                      shape:
                      RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius
                            .circular(
                            12),
                      ),
                    ),

                    child: Text(

                      widget.product == null
                          ? "Save Product"
                          : "Update Product",

                      style:
                      GoogleFonts.poppins(

                        color: Colors.white,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}