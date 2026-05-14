
import 'package:enterprise_resource_planning/data/models/product_model.dart';
import 'package:enterprise_resource_planning/data/models/sales/customer_search_response.dart';
import 'package:enterprise_resource_planning/data/models/sales/quick_customer_create_request.dart';
import 'package:enterprise_resource_planning/data/models/sales/sales_create_request.dart';
import 'package:enterprise_resource_planning/data/models/sales/sales_history_model.dart';
import 'package:enterprise_resource_planning/data/models/sales/sales_item_request.dart';
import 'package:enterprise_resource_planning/data/models/sales/sales_response.dart';

import 'package:enterprise_resource_planning/data/repositories/customer_service.dart';
import 'package:enterprise_resource_planning/data/repositories/product_service.dart';
import 'package:enterprise_resource_planning/data/repositories/sales_service.dart';
import 'package:flutter/material.dart';

class SalesProvider extends ChangeNotifier {

  final SalesService salesService;
  final ProductService productService;
  final CustomerService customerService;
  SalesResponse? lastCreatedSale;
  DateTime selectedDate =
  DateTime.now();

  double monthlyTotal = 0;


  SalesProvider({
    required this.salesService,
    required this.productService,
    required this.customerService,

  });

  bool loading = false;
  bool saving = false;

  List<ProductModel> products = [];

  CustomerSearchResponse? selectedCustomer;

  bool customerFormVisible = false;

  final customerSearchController =
  TextEditingController();

  final remarksController =
  TextEditingController();

  final paidAmountController =
  TextEditingController(text: "0");

  final discountPercentController =
  TextEditingController(text: "0");

  final customerNameController =
  TextEditingController();

  final customerMobileController =
  TextEditingController();

  final customerEmailController =
  TextEditingController();

  final customerCompanyController =
  TextEditingController();

  final customerAddressController =
  TextEditingController();

  List<SaleItemRowModel> saleItems = [
    SaleItemRowModel()
  ];

  Future<void> loadProducts() async {

    loading = true;
    notifyListeners();

    try {

      products =
      await productService.getProducts();

    } finally {

      loading = false;
      notifyListeners();
    }
  }

  void addItemRow() {

    saleItems.add(SaleItemRowModel());

    notifyListeners();
  }

  void removeItemRow(int index) {

    saleItems.removeAt(index);

    if(saleItems.isEmpty){
      saleItems.add(SaleItemRowModel());
    }

    notifyListeners();
  }

  void onProductSelected(
      int index,
      ProductModel product,
      ) {

    final item = saleItems[index];

    item.productId = product.id!;
    item.productName = product.name!;
    item.sku = product.sku ?? "";

    item.availableStock =
        product.stock ?? 0;

    item.unitPrice =
        product.sellingPrice ?? 0;

    item.quantity = 1;

    item.lineTotal =
        item.unitPrice * item.quantity;

    notifyListeners();
  }

  void updateQuantity(
      int index,
      int quantity,
      ) {

    final item = saleItems[index];

    item.quantity = quantity;

    item.lineTotal =
        item.unitPrice * item.quantity;

    notifyListeners();
  }

  double get subTotal {

    return saleItems.fold(
      0,
          (sum, item) =>
      sum + item.lineTotal,
    );
  }

  double get discountAmount {

    final percent =
        double.tryParse(
          discountPercentController.text,
        ) ?? 0;

    return (subTotal * percent) / 100;
  }

  double get netTotal {

    return subTotal - discountAmount;
  }

  double get paidAmount {

    return double.tryParse(
      paidAmountController.text,
    ) ?? 0;
  }

  double get dueAmount {

    return netTotal - paidAmount;
  }

  Future<void> searchCustomer() async {

    final keyword =
    customerSearchController.text.trim();

    if(keyword.isEmpty){
      return;
    }

    final customers =
    await salesService
        .searchCustomers(keyword);

    if(customers.isNotEmpty){

      selectedCustomer = customers.first;

      customerFormVisible = false;

    } else {

      selectedCustomer = null;

      customerFormVisible = true;

      customerMobileController.text =
          keyword;
    }

    notifyListeners();
  }

  Future<void> createQuickCustomer()
  async {

    final request =
    QuickCustomerCreateRequest(
      name:
      customerNameController.text,
      email:
      customerEmailController.text,
      companyName:
      customerCompanyController.text,
      mobileNumber:
      customerMobileController.text,
      address:
      customerAddressController.text,
    );

    final customer =
    await customerService
        .quickCustomerCreate(request);

    selectedCustomer = customer;

    customerFormVisible = false;

    notifyListeners();
  }

  Future<SalesResponse?> saveSale() async {

    saving = true;
    notifyListeners();

    try {

      final request =
      SalesCreateRequest(

        customerId:
        selectedCustomer?.id,

        salesDate:
        DateTime.now()
            .toIso8601String()
            .split("T")
            .first,

        discountAmount:
        discountAmount,

        paidAmount:
        paidAmount,

        remarks:
        remarksController.text,

        items: saleItems
            .where(
              (e) =>
          e.productId != null,
        )
            .map((e) {

          return SalesItemRequest(
            productId: e.productId!,
            quantity: e.quantity,
            unitPrice: e.unitPrice,
          );

        }).toList(),
      );

      final response =
      await salesService.createSale(request);

      lastCreatedSale = response;

      return response;

    } finally {

      saving = false;
      notifyListeners();
    }
  }

  void resetAll() {

    selectedCustomer = null;

    customerFormVisible = false;

    customerSearchController.clear();

    remarksController.clear();

    paidAmountController.text = "0";

    discountPercentController.text = "0";

    customerNameController.clear();

    customerMobileController.clear();

    customerEmailController.clear();

    customerCompanyController.clear();

    customerAddressController.clear();

    saleItems = [
      SaleItemRowModel()
    ];

    notifyListeners();
  }


  List<SalesHistoryModel> salesHistory = [];

  bool salesHistoryLoading = false;

  Future<void> loadSalesHistory() async {

    salesHistoryLoading = true;

    notifyListeners();

    try {

      final date =
          selectedDate
              .toIso8601String()
              .split("T")
              .first;

      salesHistory =
      await salesService
          .getMySales(date);

      monthlyTotal =
      await salesService
          .getMonthlyTotal(
        selectedDate.year,
        selectedDate.month,
      );

    } finally {

      salesHistoryLoading = false;

      notifyListeners();
    }
  }

  void refreshSummary() {
    notifyListeners();
  }


  String? validateSale() {

    if(selectedCustomer == null){
      return "Please select customer";
    }

    final validItems =
    saleItems.where(
          (e) => e.productId != null,
    ).toList();

    if(validItems.isEmpty){
      return "Please add product";
    }

    final invalidQty =
    validItems.any(
          (e) => e.quantity <= 0,
    );

    if(invalidQty){
      return "Invalid quantity";
    }

    if(paidAmount > netTotal){
      return "Paid amount cannot exceed net total";
    }

    return null;
  }
}

class SaleItemRowModel {

  int? productId;

  String productName = "";

  String sku = "";

  int availableStock = 0;

  double unitPrice = 0;

  int quantity = 1;

  double lineTotal = 0;
}