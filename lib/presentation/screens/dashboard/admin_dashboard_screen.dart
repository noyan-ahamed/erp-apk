import 'package:enterprise_resource_planning/data/models/admin_dashboard_model.dart';
import 'package:enterprise_resource_planning/data/repositories/admin_dashboard_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final service = AdminDashboardService();

  AdminDashboardResponse? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final res = await service.getDashboardData(filterType: 'MONTH');
      setState(() {
        data = res;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF6366F1))),
      );
    }

    if (data == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Failed to load dashboard data"),
              ElevatedButton(onPressed: loadData, child: const Text("Retry"))
            ],
          ),
        ),
      );
    }

    final summary = data!.summary;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: RefreshIndicator(
        onRefresh: loadData,
        color: const Color(0xFF6366F1),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _buildSectionHeader(""),
              // const SizedBox(height: 16),
              
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _summaryCard("Today Sales", summary.todaySales, Icons.trending_up, [Color(0xFF6366F1), Color(0xFF818CF8)]),
                  _summaryCard("Today Profit", summary.todayProfit, Icons.payments, [Color(0xFF10B981), Color(0xFF34D399)]),
                  _summaryCard("Month Sales", summary.monthSales, Icons.calendar_month, [Color(0xFFF59E0B), Color(0xFFFBBF24)]),
                  _summaryCard("Month Profit", summary.monthProfit, Icons.account_balance_wallet, [Color(0xFFEC4899), Color(0xFFF472B6)]),
                  _summaryCard("Customer Due", summary.totalCustomerDue, Icons.money_off, [Color(0xFFEF4444), Color(0xFFF87171)]),
                  _summaryCard("Supplier Payable", summary.totalSupplierPayable, Icons.request_quote, [Color(0xFF8B5CF6), Color(0xFFA78BFA)]),
                  _summaryCard("Low Stock", summary.lowStockCount.toDouble(), Icons.warning_amber_rounded, [Color(0xFF64748B), Color(0xFF94A3B8)]),
                  _summaryCard("Total Products", summary.totalProducts.toDouble(), Icons.inventory_2, [Color(0xFF0EA5E9), Color(0xFF38BDF8)]),
                ],
              ),

              const SizedBox(height: 32),
              _buildSectionHeader("Sales & Profit Trend"),
              const SizedBox(height: 16),
              _chartContainer(salesChart(data!.salesProfitTrend)),

              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Monthly Sales"),
                        const SizedBox(height: 16),
                        _chartContainer(barChart(data!.monthlySalesComparison), height: 250),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Payment Methods"),
                        const SizedBox(height: 16),
                        _chartContainer(pieChart(data!.paymentMethodDistribution), height: 250),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              _buildSectionHeader("Low Stock Alerts"),
              const SizedBox(height: 16),
              _lowStockTable(data!.lowStockItems),

              const SizedBox(height: 32),
              _buildSectionHeader("Recent Activities"),
              const SizedBox(height: 16),
              _activityList(data!.recentActivities),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B)),
        ),
        // Text(
        //   subtitle,
        //   style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        // ),
      ],
    );
  }

  Widget _summaryCard(String title, double value, IconData icon, List<Color> colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        boxShadow: [
          BoxShadow(color: colors[0].withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              FittedBox(
                child: Text(
                  title.contains("Stock") || title.contains("Products")
                    ? value.toInt().toString()
                    : "৳ ${value.toStringAsFixed(0)}",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chartContainer(Widget chart, {double height = 300}) {
    return Container(
      height: height,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: chart,
    );
  }

  Widget salesChart(List<AdminDashboardTrendPoint> list) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[100], strokeWidth: 1)),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (value, meta) {
            if (value.toInt() >= 0 && value.toInt() < list.length) {
              return Text(list[value.toInt()].label.substring(0, 3), style: const TextStyle(fontSize: 10, color: Colors.grey));
            }
            return const Text('');
          })),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: const Color(0xFF6366F1),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: const Color(0xFF6366F1).withOpacity(0.1)),
            spots: list.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.sales.toDouble())).toList(),
          ),
          LineChartBarData(
            isCurved: true,
            color: const Color(0xFF10B981),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: const Color(0xFF10B981).withOpacity(0.1)),
            spots: list.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.profit.toDouble())).toList(),
          ),
        ],
      ),
    );
  }

  Widget barChart(List<AdminDashboardTrendPoint> list) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: list.map((e) => e.sales.toDouble()).reduce((a, b) => a > b ? a : b) * 1.2,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(show: false),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: list.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.sales.toDouble(),
                color: const Color(0xFF6366F1),
                width: 12,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
              )
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget pieChart(List<AdminDashboardPaymentMethod> list) {
    final colors = [const Color(0xFF6366F1), const Color(0xFF10B981), const Color(0xFFF59E0B), const Color(0xFFEF4444)];
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: list.asMap().entries.map((e) {
          return PieChartSectionData(
            value: e.value.totalAmount.toDouble(),
            title: '',
            color: colors[e.key % colors.length],
            radius: 50,
          );
        }).toList(),
      ),
    );
  }

  Widget _lowStockTable(List<AdminDashboardLowStockItem> items) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(const Color(0xFFF1F5F9)),
        columns: [
          DataColumn(label: Text("Product", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
          DataColumn(label: Text("Stock", style: GoogleFonts.poppins(fontWeight: FontWeight.bold))),
        ],
        rows: items.map((e) {
          return DataRow(cells: [
            DataCell(Text(e.productName, style: GoogleFonts.poppins(fontSize: 13))),
            DataCell(Text(e.stock.toString(), style: GoogleFonts.poppins(fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold))),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _activityList(List<AdminDashboardActivity> list) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final e = list[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
              child: const Icon(Icons.history, color: Color(0xFF6366F1), size: 20),
            ),
            title: Text(e.title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
            subtitle: Text(e.date, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            trailing: Text("৳ ${e.amount}", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
          );
        },
      ),
    );
  }
}
