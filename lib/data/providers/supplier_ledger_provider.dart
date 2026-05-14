import 'package:flutter/material.dart';
import '../models/ledger/supplier_ledger_model.dart';
import '../models/ledger/supplier_payment_model.dart';
import '../repositories/supplier_ledger_repository.dart';

class SupplierLedgerProvider extends ChangeNotifier {
  final SupplierLedgerRepository ledgerRepository;

  SupplierLedgerProvider({
    required this.ledgerRepository,
  });

  List<SupplierLedgerSummary> suppliers = [];
  bool loading = false;

  Future<void> loadSuppliers() async {
    loading = true;
    notifyListeners();

    try {
      suppliers = await ledgerRepository.getAllSuppliers();
    } catch (e) {
      debugPrint("Error: $e");
    }

    loading = false;
    notifyListeners();
  }

  Future<List<SupplierLedgerDetails>> getSupplierLedgerDetails(int id) async {
    try {
      return await ledgerRepository.getSupplierLedgerDetails(id);
    } catch (e) {
      debugPrint("Error: $e");
      return [];
    }
  }

  Future<SupplierPaymentResponse?> makePayment(SupplierPaymentRequest req) async {
    try {
      final res = await ledgerRepository.createPayment(req);
      await loadSuppliers();
      return res;
    } catch (e) {
      debugPrint("Error: $e");
      return null;
    }
  }
}