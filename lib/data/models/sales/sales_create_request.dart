import 'sales_item_request.dart';

class SalesCreateRequest {

  final int? customerId;

  final String salesDate;

  final double discountAmount;

  final double paidAmount;

  final String? remarks;

  final List<SalesItemRequest> items;

  SalesCreateRequest({
    this.customerId,
    required this.salesDate,
    required this.discountAmount,
    required this.paidAmount,
    this.remarks,
    required this.items,
  });

  Map<String, dynamic> toJson() {

    return {
      "customerId": customerId,
      "salesDate": salesDate,
      "discountAmount": discountAmount,
      "paidAmount": paidAmount,
      "remarks": remarks,
      "items": items
          .map((e) => e.toJson())
          .toList(),
    };
  }
}