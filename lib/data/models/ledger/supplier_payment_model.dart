class SupplierPaymentRequest {
  final int supplierId;
  final double amount;
  final String paymentDate;
  final String paymentMethod;
  final String? remarks;
  final int? purchaseOrderId;

  SupplierPaymentRequest({
    required this.supplierId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    this.remarks,
    this.purchaseOrderId,
  });

  Map<String, dynamic> toJson() {
    return {
      "supplierId": supplierId,
      "amount": amount,
      "paymentDate": paymentDate,
      "paymentMethod": paymentMethod,
      "remarks": remarks,
      "purchaseOrderId": purchaseOrderId,
    };
  }
}

class SupplierPaymentResponse {
  final int id;
  final String voucherNo;
  final String supplierName;
  final double amount;
  final String paymentDate;
  final String paymentMethod;
  final String? remarks;
  final String? purchaseInvoiceNumber;

  SupplierPaymentResponse({
    required this.id,
    required this.voucherNo,
    required this.supplierName,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    this.remarks,
    this.purchaseInvoiceNumber,
  });

  factory SupplierPaymentResponse.fromJson(Map<String, dynamic> json) {
    return SupplierPaymentResponse(
      id: json['id'],
      voucherNo: json['voucherNo'],
      supplierName: json['supplierName'],
      amount: (json['amount'] ?? 0).toDouble(),
      paymentDate: json['paymentDate'],
      paymentMethod: json['paymentMethod'],
      remarks: json['remarks'],
      purchaseInvoiceNumber: json['purchaseInvoiceNumber'],
    );
  }
}