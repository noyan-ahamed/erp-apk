import 'dart:convert'; // base64Decode এর জন্য প্রয়োজন
import 'package:enterprise_resource_planning/core/services/token_service.dart';
import 'package:enterprise_resource_planning/data/models/user_model.dart'; // UserModel এর জন্য
import 'package:enterprise_resource_planning/presentation/screens/category/product_category_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/customer_payment/customer_payment_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/dashboard_home.dart';
import 'package:enterprise_resource_planning/presentation/screens/department/department_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/designation/designation_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/employee/employee_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/ledger/customer_ledger_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/customer_payment/approve_payment_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/ledger/supplier_ledger_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/login/force_password_change_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/product/product_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/purchase/purchase_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/sales/new_sale_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/sales/sales_history_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/supplier/supplier_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/settings/settings_screen.dart';
import 'package:enterprise_resource_planning/presentation/widgets/side_nav.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class AdminLayoutScreen extends StatefulWidget {
  const AdminLayoutScreen({super.key});

  @override
  State<AdminLayoutScreen> createState() => _AdminLayoutScreen();
}

class _AdminLayoutScreen extends State<AdminLayoutScreen> {
  List<String> roles = [];
  bool loadingRoles = true;
  String selectedMenu = "dashboard";


  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    validatePasswordStatus();
    loadRolesAndUser();
  }

  Future<void> loadRolesAndUser() async {

    final savedRoles = await TokenService.getRoles();

    final userJson = await TokenService.getUser();
    if (userJson != null) {
      currentUser = UserModel.fromJson(jsonDecode(userJson));
    }

    String defaultMenu = "dashboard";
    if (savedRoles.contains("EMPLOYEE")) {
      defaultMenu = "new_sale";
    }

    setState(() {
      roles = savedRoles;
      selectedMenu = defaultMenu;
      loadingRoles = false;
    });
  }

  bool isAdmin() => roles.contains("ADMIN");
  bool isEmployee() => roles.contains("EMPLOYEE");

  Widget getScreen() {
    final adminOnlyMenus = [
      "employee", "department", "designation", "suppliers",
      "category", "products", "purchase"
    ];

    if (adminOnlyMenus.contains(selectedMenu) && !isAdmin()) {
      return const Center(child: Text("Access Denied"));
    }

    switch (selectedMenu) {
      case "suppliers": return const SupplierScreen();
      case "category": return const ProductCategoryScreen();
      case "products": return const ProductScreen();
      case "department": return const DepartmentScreen();
      case "designation": return const DesignationScreen();
      case "employee": return const EmployeeScreen();
      case "purchase": return const PurchaseScreen();
      case "supplier_ledger": return const SupplierLedgerScreen();
      case "customer_ledger": return const CustomerLedgerScreen();
      case "approve_payments": return const ApprovePaymentScreen();
      case "new_sale": return const NewSaleScreen();
      case "sales_history": return const SalesHistoryScreen();
      case "submit_payment": return const CustomerPaymentScreen();
      case "settings": return const SettingsScreen();
      default: return DashboardHome();
    }
  }

  String getTitle() {
    switch (selectedMenu) {
      case "suppliers": return "Suppliers";
      case "category": return "Product Categories";
      case "products": return "Products";
      case "department": return "Departments";
      case "designation": return "Designations";
      case "purchase": return "Purchase Order";
      case "supplier_ledger": return "Supplier Ledger";
      case "approve_payments": return "Approve Payments";
      case "customer_ledger": return "Customer Ledger";
      case "employee": return "Employees";
      case "new_sale": return "New Sale Entry";
      case "sales_history": return "Sales History";
      case "submit_payment": return "Due Collection";
      case "settings": return "Settings";
      default: return "Dashboard Overview";
    }
  }

  Future<void> validatePasswordStatus() async {
    final changed = await TokenService.isPasswordChanged();
    if (!changed && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ForcePasswordChangeScreen()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String homeMenu = isAdmin() ? "dashboard" : "new_sale";
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        if (selectedMenu != homeMenu) {
          setState(() {
            selectedMenu = homeMenu;
          });
        } else {
          bool exit = false;
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            title: "Exit App",
            text: "Are you sure you want to exit?",
            showCancelBtn: true,
            confirmBtnText: "Yes",
            cancelBtnText: "No",
            onConfirmBtnTap: () {
              exit = true;
              Navigator.pop(context);
            },
          );
          if (exit) {
            if (context.mounted) Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          title: Text(
            getTitle(),
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                color: isDark ? Colors.white : const Color(0xFF64748B),
              ),
              onPressed: () {},
            ),


            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: isDark ? Colors.white10 : const Color(0xFFE2E8F0),

                backgroundImage: currentUser?.imageBase64 != null
                    ? MemoryImage(base64Decode(currentUser!.imageBase64!))
                    : null,

                child: currentUser?.imageBase64 == null
                    ? Icon(
                  Icons.person,
                  size: 18,
                  color: isDark ? Colors.white : const Color(0xFF64748B),
                )
                    : null,
              ),
            ),
          ],
        ),
        drawer: SideNav(
          onMenuSelect: (value) {
            setState(() {
              selectedMenu = value;
            });
            Navigator.pop(context);
          },
        ),
        body: getScreen(),
      ),
    );
  }
}