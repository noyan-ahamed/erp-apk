import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';

import '../../../data/models/product_model.dart';
import '../../../data/models/supplier_model.dart';
import '../../../data/repositories/product_service.dart';
import '../../../data/repositories/purchase_service.dart';
import '../../../data/repositories/supplier_service.dart';

import 'payment_terms_dropdown.dart';
import 'purchase_item_row.dart';
import 'purchase_summary.dart';
import 'supplier_selector.dart';

class PurchaseDialog extends StatefulWidget {
  const PurchaseDialog({super.key});

  @override
  State<PurchaseDialog> createState() =>
      _PurchaseDialogState();
}

class _PurchaseDialogState
    extends State<PurchaseDialog> {

  final PurchaseService purchaseService =
  PurchaseService();

  final SupplierService supplierService =
  SupplierService();

  final ProductService productService =
  ProductService();

  bool loading = true;

  bool creating = false;

  List<SupplierModel> suppliers = [];

  List<ProductModel> products = [];

  SupplierModel? selectedSupplier;

  String paymentTerms = "7 Days";

  final List<Map<String, dynamic>> items = [];

  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    try {

      final supplierData =
      await supplierService.getAllSuppliers();

      final productData =
      await productService.getProducts();

      suppliers = supplierData;

      products = productData;

      addItem();

    } catch (e) {

      if(mounted){

        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Failed to load data",
        );
      }

    } finally {

      if(mounted){
        setState(() => loading = false);
      }
    }
  }

  void addItem(){

    setState(() {

      items.add({

        "product": null,
        "quantity": 1,
        "unit": "Pcs",
        "unitPrice": 0.0,
      });
    });
  }

  void removeItem(int index){

    setState(() {

      items.removeAt(index);

      calculateTotal();
    });
  }

  void calculateTotal(){

    double total = 0;

    for(final item in items){

      total +=
          (item["quantity"] ?? 0) *
              (item["unitPrice"] ?? 0);
    }

    totalAmount = total;
  }

  Future<void> createPurchase() async {

    if(selectedSupplier == null){

      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "Select supplier",
      );

      return;
    }

    if(items.isEmpty){

      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: "Add product",
      );

      return;
    }

    for(final item in items){

      if(item["product"] == null){

        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: "Select all products",
        );

        return;
      }
    }

    setState(() => creating = true);

    final body = {

      "supplierId": selectedSupplier!.id,

      "paymentTerms": paymentTerms,

      "items": items.map((e){

        return {

          "productId":
          (e["product"] as ProductModel).id,

          "quantity": e["quantity"],

          "unit": e["unit"],

          "unitPrice": e["unitPrice"],
        };

      }).toList(),
    };

    try {

      final success =
      await purchaseService.createPurchase(body);

      if(!mounted) return;

      if(success){

        Navigator.pop(context, true);

      } else {

        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Purchase creation failed",
        );
      }

    } catch(e){

      if(mounted){

        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Something went wrong",
        );
      }

    } finally {

      if(mounted){
        setState(() => creating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Container(

        width: 950,

        padding: const EdgeInsets.all(20),

        child: loading

            ? const SizedBox(
          height: 300,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )

            : SingleChildScrollView(

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Text(

                "Create Purchase",

                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              SupplierSelector(

                suppliers: suppliers,

                selectedSupplier:
                selectedSupplier,

                onChanged: (v){

                  setState(() {
                    selectedSupplier = v;
                  });
                },
              ),

              const SizedBox(height: 16),

              PaymentTermsDropdown(

                value: paymentTerms,

                onChanged: (v){

                  setState(() {
                    paymentTerms = v!;
                  });
                },
              ),

              const SizedBox(height: 24),

              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  Text(

                    "Purchase Items",

                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  ElevatedButton.icon(

                    onPressed: addItem,

                    icon: const Icon(Icons.add),

                    label:
                    const Text("Add Product"),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              ...List.generate(items.length, (index){

                return PurchaseItemRow(

                  item: items[index],

                  products: products,

                  index: index,

                  onChanged: (){

                    calculateTotal();

                    setState(() {});
                  },

                  onDelete: (){
                    removeItem(index);
                  },
                );
              }),

              const SizedBox(height: 20),

              PurchaseSummary(
                totalAmount: totalAmount,
              ),

              const SizedBox(height: 24),

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed:
                  creating ? null : createPurchase,

                  style: ElevatedButton.styleFrom(

                    backgroundColor:
                    const Color(0xFF6366F1),

                    foregroundColor:
                    Colors.white,

                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),

                  child: creating

                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )

                      : const Text(
                    "Create Purchase",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}