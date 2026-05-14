class AdminDashboardResponse {
  final AdminDashboardSummary summary;
  final List<AdminDashboardTrendPoint> salesProfitTrend;
  final List<AdminDashboardTrendPoint> monthlySalesComparison;
  final List<AdminDashboardPaymentMethod> paymentMethodDistribution;
  final List<AdminDashboardLowStockItem> lowStockItems;
  final List<AdminDashboardActivity> recentActivities;
  final List<AdminDashboardTopCustomer> topCustomers;
  final List<AdminDashboardTopProduct> topProducts;

  AdminDashboardResponse({
    required this.summary,
    required this.salesProfitTrend,
    required this.monthlySalesComparison,
    required this.paymentMethodDistribution,
    required this.lowStockItems,
    required this.recentActivities,
    required this.topCustomers,
    required this.topProducts,
  });

  factory AdminDashboardResponse.fromJson(Map<String, dynamic> json) {
    return AdminDashboardResponse(
      summary: AdminDashboardSummary.fromJson(json['summary'] ?? {}),
      salesProfitTrend: (json['salesProfitTrend'] as List? ?? [])
          .map((e) => AdminDashboardTrendPoint.fromJson(e))
          .toList(),
      monthlySalesComparison: (json['monthlySalesComparison'] as List? ?? [])
          .map((e) => AdminDashboardTrendPoint.fromJson(e))
          .toList(),
      paymentMethodDistribution: (json['paymentMethodDistribution'] as List? ?? [])
          .map((e) => AdminDashboardPaymentMethod.fromJson(e))
          .toList(),
      lowStockItems: (json['lowStockItems'] as List? ?? [])
          .map((e) => AdminDashboardLowStockItem.fromJson(e))
          .toList(),
      recentActivities: (json['recentActivities'] as List? ?? [])
          .map((e) => AdminDashboardActivity.fromJson(e))
          .toList(),
      topCustomers: (json['topCustomers'] as List? ?? [])
          .map((e) => AdminDashboardTopCustomer.fromJson(e))
          .toList(),
      topProducts: (json['topProducts'] as List? ?? [])
          .map((e) => AdminDashboardTopProduct.fromJson(e))
          .toList(),
    );
  }
}

class AdminDashboardSummary {
  final double todaySales;
  final double monthSales;
  final double todayProfit;
  final double monthProfit;
  final double totalCustomerDue;
  final double totalSupplierPayable;
  final int lowStockCount;
  final int totalProducts;

  AdminDashboardSummary({
    required this.todaySales,
    required this.monthSales,
    required this.todayProfit,
    required this.monthProfit,
    required this.totalCustomerDue,
    required this.totalSupplierPayable,
    required this.lowStockCount,
    required this.totalProducts,
  });

  factory AdminDashboardSummary.fromJson(Map<String, dynamic> json) {
    return AdminDashboardSummary(
      todaySales: (json['todaySales'] ?? 0).toDouble(),
      monthSales: (json['monthSales'] ?? 0).toDouble(),
      todayProfit: (json['todayProfit'] ?? 0).toDouble(),
      monthProfit: (json['monthProfit'] ?? 0).toDouble(),
      totalCustomerDue: (json['totalCustomerDue'] ?? 0).toDouble(),
      totalSupplierPayable: (json['totalSupplierPayable'] ?? 0).toDouble(),
      lowStockCount: json['lowStockCount'] ?? 0,
      totalProducts: json['totalProducts'] ?? 0,
    );
  }
}

class AdminDashboardTrendPoint {
  final String label;
  final double sales;
  final double profit;

  AdminDashboardTrendPoint({
    required this.label,
    required this.sales,
    required this.profit,
  });

  factory AdminDashboardTrendPoint.fromJson(Map<String, dynamic> json) {
    return AdminDashboardTrendPoint(
      label: json['label'] ?? '',
      sales: (json['sales'] ?? 0).toDouble(),
      profit: (json['profit'] ?? 0).toDouble(),
    );
  }
}

class AdminDashboardPaymentMethod {
  final String paymentMethod;
  final double totalAmount;

  AdminDashboardPaymentMethod({
    required this.paymentMethod,
    required this.totalAmount,
  });

  factory AdminDashboardPaymentMethod.fromJson(Map<String, dynamic> json) {
    return AdminDashboardPaymentMethod(
      paymentMethod: json['paymentMethod'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
    );
  }
}

class AdminDashboardLowStockItem {
  final int productId;
  final String productName;
  final String sku;
  final int stock;
  final int minStockLevel;

  AdminDashboardLowStockItem({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.stock,
    required this.minStockLevel,
  });

  factory AdminDashboardLowStockItem.fromJson(Map<String, dynamic> json) {
    return AdminDashboardLowStockItem(
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      sku: json['sku'] ?? '',
      stock: json['stock'] ?? 0,
      minStockLevel: json['minStockLevel'] ?? 0,
    );
  }
}

class AdminDashboardActivity {
  final String type;
  final String title;
  final String? referenceNo;
  final double amount;
  final String date;

  AdminDashboardActivity({
    required this.type,
    required this.title,
    this.referenceNo,
    required this.amount,
    required this.date,
  });

  factory AdminDashboardActivity.fromJson(Map<String, dynamic> json) {
    return AdminDashboardActivity(
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      referenceNo: json['referenceNo'],
      amount: (json['amount'] ?? 0).toDouble(),
      date: json['date'] ?? '',
    );
  }
}

class AdminDashboardTopCustomer {
  final int customerId;
  final String customerName;
  final String mobileNumber;
  final double totalPurchaseAmount;

  AdminDashboardTopCustomer({
    required this.customerId,
    required this.customerName,
    required this.mobileNumber,
    required this.totalPurchaseAmount,
  });

  factory AdminDashboardTopCustomer.fromJson(Map<String, dynamic> json) {
    return AdminDashboardTopCustomer(
      customerId: json['customerId'] ?? 0,
      customerName: json['customerName'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      totalPurchaseAmount:
      (json['totalPurchaseAmount'] ?? 0).toDouble(),
    );
  }
}

class AdminDashboardTopProduct {
  final int productId;
  final String productName;
  final String sku;
  final int totalSoldQty;
  final double totalSoldAmount;

  AdminDashboardTopProduct({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.totalSoldQty,
    required this.totalSoldAmount,
  });

  factory AdminDashboardTopProduct.fromJson(Map<String, dynamic> json) {
    return AdminDashboardTopProduct(
      productId: json['productId'] ?? 0,
      productName: json['productName'] ?? '',
      sku: json['sku'] ?? '',
      totalSoldQty: json['totalSoldQty'] ?? 0,
      totalSoldAmount:
      (json['totalSoldAmount'] ?? 0).toDouble(),
    );
  }
}
