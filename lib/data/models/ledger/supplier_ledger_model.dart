class SupplierLedgerSummary {
  final int supplierId;
  final String supplierName;
  final String? companyName;
  final String? mobileNumber;
  final double totalPurchase;
  final double totalPayment;
  final double currentDue;

  SupplierLedgerSummary({
    required this.supplierId,
    required this.supplierName,
    this.companyName,
    this.mobileNumber,
    required this.totalPurchase,
    required this.totalPayment,
    required this.currentDue,
  });

  factory SupplierLedgerSummary.fromJson(Map<String, dynamic> json) {
    return SupplierLedgerSummary(
      supplierId: json['supplierId'],
      supplierName: json['supplierName'],
      companyName: json['companyName'],
      mobileNumber: json['mobileNumber'],
      totalPurchase: (json['totalPurchase'] ?? 0).toDouble(),
      totalPayment: (json['totalPayment'] ?? 0).toDouble(),
      currentDue: (json['currentDue'] ?? 0).toDouble(),
    );
  }
}

class SupplierLedgerDetails {
  final String? date;
  final String? transactionType;
  final String? referenceType;
  final int? referenceId;
  final String? referenceNo;
  final double debit;
  final double credit;
  final double runningBalance;
  final String? remarks;

  SupplierLedgerDetails({
    this.date,
    this.transactionType,
    this.referenceType,
    this.referenceId,
    this.referenceNo,
    required this.debit,
    required this.credit,
    required this.runningBalance,
    this.remarks,
  });

  factory SupplierLedgerDetails.fromJson(Map<String, dynamic> json) {
    return SupplierLedgerDetails(
      date: json['date'],
      transactionType: json['transactionType'],
      referenceType: json['referenceType'],
      referenceId: json['referenceId'],
      referenceNo: json['referenceNo'],
      debit: (json['debit'] ?? 0).toDouble(),
      credit: (json['credit'] ?? 0).toDouble(),
      runningBalance: (json['runningBalance'] ?? 0).toDouble(),
      remarks: json['remarks'],
    );
  }
}