class CustomerLedgerSummary {
  final int customerId;
  final String customerName;
  final String? companyName;
  final String? mobileNumber;

  final double totalSales;
  final double totalApprovedPayment;
  final double currentDue;

  CustomerLedgerSummary({
    required this.customerId,
    required this.customerName,
    this.companyName,
    this.mobileNumber,
    required this.totalSales,
    required this.totalApprovedPayment,
    required this.currentDue,
  });

  factory CustomerLedgerSummary.fromJson(Map<String, dynamic> json) {
    return CustomerLedgerSummary(
      customerId: json['customerId'],
      customerName: json['customerName'],
      companyName: json['companyName'],
      mobileNumber: json['mobileNumber'],

      totalSales: (json['totalSales'] ?? 0).toDouble(),
      totalApprovedPayment: (json['totalApprovedPayment'] ?? 0).toDouble(),
      currentDue: (json['currentDue'] ?? 0).toDouble(),
    );
  }
}

class CustomerLedgerDetails {
  final String? date;
  final int? referenceId;
  final String? referenceNo;
  final String? referenceType;
  final String transactionType;
  final double debit;
  final double credit;
  final double runningBalance;
  final String? remarks;

  CustomerLedgerDetails({
    this.date,
    this.referenceId,
    this.referenceNo,
    this.referenceType,
    required this.transactionType,
    required this.debit,
    required this.credit,
    required this.runningBalance,
    this.remarks,
  });

  factory CustomerLedgerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerLedgerDetails(
      date: json['date']?.toString(),
      referenceId: json['referenceId'],
      referenceNo: json['referenceNo']?.toString(),
      referenceType: json['referenceType']?.toString(),
      transactionType: json['transactionType']?.toString() ?? '',
      debit: (json['debit'] ?? 0).toDouble(),
      credit: (json['credit'] ?? 0).toDouble(),
      runningBalance: (json['runningBalance'] ?? 0).toDouble(),
      remarks: json['remarks']?.toString(),
    );
  }
}