class CustomerDueSummaryModel {

  final int customerId;
  final String customerName;
  final String mobileNumber;
  final String? companyName;
  final String? address;

  final double totalSales;
  final double totalApprovedPayment;
  final double currentDue;

  final String? lastPaymentDate;
  final String? lastSaleDate;

  CustomerDueSummaryModel({
    required this.customerId,
    required this.customerName,
    required this.mobileNumber,
    required this.companyName,
    required this.address,
    required this.totalSales,
    required this.totalApprovedPayment,
    required this.currentDue,
    required this.lastPaymentDate,
    required this.lastSaleDate,
  });

  factory CustomerDueSummaryModel.fromJson(
      Map<String, dynamic> json,
      ) {

    return CustomerDueSummaryModel(

      customerId: json["customerId"],

      customerName:
      json["customerName"] ?? "",

      mobileNumber:
      json["mobileNumber"] ?? "",

      companyName:
      json["companyName"],

      address:
      json["address"],

      totalSales:
      (json["totalSales"] ?? 0).toDouble(),

      totalApprovedPayment:
      (json["totalApprovedPayment"] ?? 0)
          .toDouble(),

      currentDue:
      (json["currentDue"] ?? 0)
          .toDouble(),

      lastPaymentDate:
      json["lastPaymentDate"],

      lastSaleDate:
      json["lastSaleDate"],
    );
  }
}