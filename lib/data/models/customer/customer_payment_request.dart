class CustomerPaymentRequest {

  final int customerId;
  final int? salesOrderId;

  final double amount;

  final String paymentDate;

  final String paymentMethod;

  final String remarks;

  CustomerPaymentRequest({
    required this.customerId,
    this.salesOrderId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {

    return {

      "customerId": customerId,

      "salesOrderId": salesOrderId,

      "amount": amount,

      "paymentDate": paymentDate,

      "paymentMethod": paymentMethod,

      "remarks": remarks,
    };
  }
}