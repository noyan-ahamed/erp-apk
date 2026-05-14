class SalesHistoryModel {

  final int salesId;
  final String invoiceNumber;
  final String salesDate;
  final String customerName;
  final String customerMobile;
  final String? sellerEmployeeName;

  final double subTotal;
  final double discountAmount;
  final double netTotal;
  final double paidAmount;
  final double dueAmount;

  SalesHistoryModel({
    required this.salesId,
    required this.invoiceNumber,
    required this.salesDate,
    required this.customerName,
    required this.customerMobile,
    this.sellerEmployeeName,
    required this.subTotal,
    required this.discountAmount,
    required this.netTotal,
    required this.paidAmount,
    required this.dueAmount,
  });

  factory SalesHistoryModel.fromJson(Map<String, dynamic> json) {

    return SalesHistoryModel(
      salesId: json['salesId'],
      invoiceNumber: json['invoiceNumber'] ?? '',
      salesDate: json['salesDate'] ?? '',
      customerName: json['customerName'] ?? '',
      customerMobile: json['customerMobile'] ?? '',
      sellerEmployeeName: json['sellerEmployeeName'],

      subTotal: (json['subTotal'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      netTotal: (json['netTotal'] ?? 0).toDouble(),
      paidAmount: (json['paidAmount'] ?? 0).toDouble(),
      dueAmount: (json['dueAmount'] ?? 0).toDouble(),
    );
  }
}