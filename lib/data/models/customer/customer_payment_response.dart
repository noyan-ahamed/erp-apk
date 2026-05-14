class CustomerPaymentResponse {

  final int id;

  final String voucherNo;

  final String customerName;

  final String customerMobile;

  final String? salesInvoiceNumber;

  final double amount;

  final String paymentDate;

  final String paymentMethod;

  final String remarks;

  final String status;

  CustomerPaymentResponse({
    required this.id,
    required this.voucherNo,
    required this.customerName,
    required this.customerMobile,
    required this.salesInvoiceNumber,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.remarks,
    required this.status,
  });

  factory CustomerPaymentResponse.fromJson(
      Map<String, dynamic> json,
      ) {

    return CustomerPaymentResponse(

      id: json["id"],

      voucherNo:
      json["voucherNo"]?.toString() ?? "",

      customerName:
      json["customerName"]?.toString() ?? "",

      customerMobile:
      json["customerMobile"]?.toString() ?? "",

      salesInvoiceNumber:
      json["salesInvoiceNumber"]?.toString(),

      amount: double.tryParse(json["amount"]?.toString() ?? "0") ?? 0.0,

      paymentDate:
      json["paymentDate"]?.toString() ?? "",

      paymentMethod:
      json["paymentMethod"]?.toString() ?? "",

      remarks:
      json["remarks"]?.toString() ?? "",

      status:
      json["status"]?.toString() ?? "",
    );
  }
}