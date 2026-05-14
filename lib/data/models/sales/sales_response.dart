class SalesResponse {

  final int salesId;

  final String invoiceNumber;

  final String salesDate;

  final int customerId;

  final String customerName;

  final String customerMobile;

  final int? sellerEmployeeId;

  final String? sellerEmployeeName;

  final double subTotal;

  final double discountAmount;

  final double netTotal;

  final double paidAmount;

  final double dueAmount;

  final String? remarks;

  final List<SalesOrderItemResponse> items;

  SalesResponse({

    required this.salesId,

    required this.invoiceNumber,

    required this.salesDate,

    required this.customerId,

    required this.customerName,

    required this.customerMobile,

    this.sellerEmployeeId,

    this.sellerEmployeeName,

    required this.subTotal,

    required this.discountAmount,

    required this.netTotal,

    required this.paidAmount,

    required this.dueAmount,

    this.remarks,

    required this.items,
  });

  factory SalesResponse.fromJson(
      Map<String, dynamic> json,
      ) {

    return SalesResponse(

      salesId:
      json["salesId"],

      invoiceNumber:
      json["invoiceNumber"] ?? "",

      salesDate:
      json["salesDate"] ?? "",

      customerId:
      json["customerId"] ?? 0,

      customerName:
      json["customerName"] ?? "",

      customerMobile:
      json["customerMobile"] ?? "",

      sellerEmployeeId:
      json["sellerEmployeeId"],

      sellerEmployeeName:
      json["sellerEmployeeName"],

      subTotal:
      (json["subTotal"] ?? 0).toDouble(),

      discountAmount:
      (json["discountAmount"] ?? 0).toDouble(),

      netTotal:
      (json["netTotal"] ?? 0).toDouble(),

      paidAmount:
      (json["paidAmount"] ?? 0).toDouble(),

      dueAmount:
      (json["dueAmount"] ?? 0).toDouble(),

      remarks:
      json["remarks"],

      items:
      (json["items"] as List<dynamic>?)
          ?.map(
            (e) =>
            SalesOrderItemResponse
                .fromJson(e),
      )
          .toList()
          ??
          [],
    );
  }
}

class SalesOrderItemResponse {

  final int productId;

  final String productName;

  final int quantity;

  final double unitPrice;

  final double lineTotal;

  SalesOrderItemResponse({

    required this.productId,

    required this.productName,

    required this.quantity,

    required this.unitPrice,

    required this.lineTotal,
  });

  factory SalesOrderItemResponse.fromJson(
      Map<String, dynamic> json,
      ) {

    return SalesOrderItemResponse(

      productId:
      json["productId"] ?? 0,

      productName:
      json["productName"] ?? "",

      quantity:
      json["quantity"] ?? 0,

      unitPrice:
      (json["unitPrice"] ?? 0)
          .toDouble(),

      lineTotal:
      (json["lineTotal"] ?? 0)
          .toDouble(),
    );
  }
}