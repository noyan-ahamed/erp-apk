import 'package:enterprise_resource_planning/data/models/customer/customer_payment_response.dart';
import 'package:enterprise_resource_planning/data/repositories/customer_payment_service.dart';
import 'package:flutter/material.dart';

class ApprovePaymentProvider extends ChangeNotifier {
  final CustomerPaymentService service;

  ApprovePaymentProvider({required this.service});

  List<CustomerPaymentResponse> payments = [];
  bool isLoading = false;
  String keyword = "";
  String status = "PENDING_APPROVAL";

  Future<void> fetchPayments() async {
    isLoading = true;
    notifyListeners();

    try {
      payments = await service.getAdminPaymentList(keyword, status);
    } catch (e) {
      debugPrint("Error fetching admin payments: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void setFilter(String newStatus) {
    status = newStatus;
    fetchPayments();
  }

  void search(String newKeyword) {
    keyword = newKeyword;
    fetchPayments();
  }

  Future<bool> approvePayment(int id, String remarks) async {
    try {
      await service.approvePayment(id, remarks);
      await fetchPayments();
      return true;
    } catch (e) {
      debugPrint("Error approving: $e");
      return false;
    }
  }

  Future<bool> rejectPayment(int id, String remarks) async {
    try {
      await service.rejectPayment(id, remarks);
      await fetchPayments();
      return true;
    } catch (e) {
      debugPrint("Error rejecting: $e");
      return false;
    }
  }
}
