import 'package:enterprise_resource_planning/data/models/customer/customer_due_summary_model.dart';
import 'package:enterprise_resource_planning/data/models/customer/customer_payment_request.dart';
import 'package:enterprise_resource_planning/data/models/customer/customer_payment_response.dart';
import 'package:enterprise_resource_planning/data/repositories/customer_payment_service.dart';
import 'package:flutter/material.dart';

class CustomerPaymentProvider
    extends ChangeNotifier {

  final CustomerPaymentService service;

  CustomerPaymentProvider({
    required this.service,
  });

  bool searching = false;

  bool saving = false;

  CustomerDueSummaryModel? customer;

  final searchController =
  TextEditingController();

  final amountController =
  TextEditingController();

  final remarksController =
  TextEditingController();

  String paymentMethod = "CASH";

  Future<void> searchCustomer()
  async {

    final keyword =
    searchController.text.trim();

    if(keyword.isEmpty){
      return;
    }

    searching = true;
    notifyListeners();

    try {

      customer =
      await service.searchCustomer(
        keyword,
      );

    } finally {

      searching = false;
      notifyListeners();
    }
  }

  String? validate() {

    if(customer == null){
      return "Search customer first";
    }

    final amount =
    double.tryParse(
      amountController.text,
    );

    if(amount == null || amount <= 0){
      return "Enter valid amount";
    }

    if(amount > customer!.currentDue){
      return "Amount exceeds current due";
    }

    return null;
  }

  Future<CustomerPaymentResponse?>
  submitPayment() async {

    final validation = validate();

    if(validation != null){
      throw Exception(validation);
    }

    saving = true;
    notifyListeners();

    try {

      final request =
      CustomerPaymentRequest(

        customerId:
        customer!.customerId,

        amount:
        double.parse(
          amountController.text,
        ),

        paymentDate:
        DateTime.now()
            .toIso8601String()
            .split("T")
            .first,

        paymentMethod:
        paymentMethod,

        remarks:
        remarksController.text,
      );

      return await service.submitPayment(
        request,
      );

    } finally {

      saving = false;
      notifyListeners();
    }
  }

  void reset() {

    customer = null;

    searchController.clear();

    amountController.clear();

    remarksController.clear();

    paymentMethod = "CASH";

    notifyListeners();
  }
}