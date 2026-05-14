import 'package:enterprise_resource_planning/data/models/product_model.dart';
import 'package:enterprise_resource_planning/data/repositories/product_service.dart';
import 'package:enterprise_resource_planning/presentation/widgets/product/product_details_dialog.dart';
import 'package:enterprise_resource_planning/presentation/widgets/product/product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

class ProductScreen extends StatefulWidget {

  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() =>
      _ProductScreenState();
}

class _ProductScreenState
    extends State<ProductScreen> {

  final ProductService service =
  ProductService();

  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];
  String searchQuery = "";

  bool loading = true;

  @override
  void initState() {

    super.initState();

    loadProducts();
  }

  Future<void> loadProducts() async {

    setState(() => loading = true);

    try {

      final data =
      await service.getProducts();

      setState(() {

        products = data;
        filteredProducts = data;

        loading = false;
      });

    } catch(e){

      setState(() => loading = false);
    }
  }

  Future<void> onEdit(
      ProductModel product) async {

    final result = await showDialog(

      context: context,

      builder: (_) => ProductDialog(
        product: product,
      ),
    );

    if(result == true){
      loadProducts();
    }
  }

  Future<void> deleteProduct(
      int id) async {

    QuickAlert.show(

      context: context,

      type: QuickAlertType.confirm,

      text: "Delete product?",

      confirmBtnColor: Colors.red,

      onConfirmBtnTap: () async {

        Navigator.pop(context);

        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          text: "Deleting...",
        );

        try {

          await service.deleteProduct(id);

          Navigator.pop(context);

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "Deleted successfully!",
          );

          loadProducts();

        } catch(e){

          Navigator.pop(context);

          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: "Delete failed!",
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,

      body: RefreshIndicator(

        onRefresh: loadProducts,

        color: const Color(0xFF6366F1),

        child: SingleChildScrollView(

          physics:
          const AlwaysScrollableScrollPhysics(),

          padding: const EdgeInsets.all(16),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Search product...",
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (val) {
                        setState(() {
                          searchQuery = val.toLowerCase();
                          if (searchQuery.isEmpty) {
                            filteredProducts = products;
                          } else {
                            filteredProducts = products.where((p) =>
                                p.name.toLowerCase().contains(searchQuery) ||
                                p.sku.toLowerCase().contains(searchQuery)).toList();
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (_) => const ProductDialog(),
                        );
                        if(result == true){
                          loadProducts();
                        }
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text("Add", overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              loading

                  ? const Center(
                child:
                CircularProgressIndicator(
                  color:
                  Color(0xFF6366F1),
                ),
              )

                  : filteredProducts.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    "No products found",
                    style: GoogleFonts.inter(color: Colors.grey),
                  ),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredProducts.length,
                itemBuilder: (context,index){
                  final p = filteredProducts[index];

                  return Container(

                    margin:
                    const EdgeInsets.only(
                      bottom: 12,
                    ),

                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).cardTheme.shadowColor ?? Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: ListTile(

                      onTap: (){

                        showDialog(

                          context: context,

                          builder: (_) =>
                              ProductDetailsDialog(
                                  p),
                        );
                      },

                      contentPadding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),

                      leading: Container(

                        width: 48,
                        height: 48,

                        decoration:
                        BoxDecoration(

                          color:
                          const Color(
                              0xFF6366F1)
                              .withOpacity(
                              0.1),

                          borderRadius:
                          BorderRadius
                              .circular(
                              12),
                        ),

                        child: const Center(

                          child: Icon(
                            Icons.inventory_2_outlined,

                            color:
                            Color(
                                0xFF6366F1),
                          ),
                        ),
                      ),

                      title: Text(

                        p.name,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(
                        "${p.sku} • Stock: ${p.stock}",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),

                      trailing: Row(
                        mainAxisSize:
                        MainAxisSize.min,
                        children: [

                          IconButton(

                            onPressed: (){
                              onEdit(p);
                            },

                            icon: const Icon(
                              Icons.edit_outlined,
                              color:
                              Color(
                                  0xFF64748B),
                            ),
                          ),

                          IconButton(
                            onPressed: (){
                              deleteProduct(
                                  p.id!);
                            },
                            icon: const Icon(
                              Icons
                                  .delete_outline_rounded,
                              color:
                              Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}