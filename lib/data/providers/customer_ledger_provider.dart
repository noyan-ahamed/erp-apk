import 'package:enterprise_resource_planning/data/models/ledger/customer_ledger_model.dart';
import 'package:enterprise_resource_planning/data/repositories/customer_ledger_repository.dart';
import 'package:flutter/material.dart';

class CustomerLedgerProvider extends ChangeNotifier {
  final CustomerLedgerRepository ledgerRepository;

  CustomerLedgerProvider({
    required this.ledgerRepository,
  });

  List<CustomerLedgerSummary> customers = [];
  bool loading = false;

  Future<void> loadCustomers() async {
    loading = true;
    notifyListeners();

    try {
      customers = await ledgerRepository.getAllCustomersDueSummary();
    } catch (e) {
      debugPrint("Error: \$e");
    }

    loading = false;
    notifyListeners();
  }

  Future<List<CustomerLedgerDetails>> getCustomerLedgerDetails(int id) async {
    try {
      return await ledgerRepository.getCustomerLedgerDetails(id);
    } catch (e) {
      debugPrint("Error: \$e");
      return [];
    }
  }
}
