import 'package:enterprise_resource_planning/core/services/token_service.dart';
import 'package:enterprise_resource_planning/presentation/screens/category/product_category_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/dashboard_home.dart';
import 'package:enterprise_resource_planning/presentation/screens/department/department_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/designation/designation_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/employee/employee_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/login/force_password_change_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/product/product_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/purchase/purchase_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/supplier/supplier_screen.dart';
import 'package:enterprise_resource_planning/presentation/widgets/side_nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminLayoutScreen extends StatefulWidget {
  const AdminLayoutScreen({super.key});

  @override
  State<AdminLayoutScreen> createState() => _AdminLayoutScreen();
}

class _AdminLayoutScreen extends State<AdminLayoutScreen> {
  List<String> roles = [];
  bool loadingRoles = true;

  String selectedMenu = "";
  // String selectedMenu = "dashboard";

  @override
  void initState() {
    super.initState();
    validatePasswordStatus();
    loadRoles();
  }
  Future<void> loadRoles() async {

    final savedRoles =
    await TokenService.getRoles();

    String defaultMenu = "dashboard";

    if(savedRoles.contains("EMPLOYEE")){
      defaultMenu = "new_sale";
    }

    setState(() {
      roles = savedRoles;
      selectedMenu = defaultMenu;
      loadingRoles = false;
    });
  }
  //helper
  bool isAdmin() => roles.contains("ADMIN");

  bool isEmployee() => roles.contains("EMPLOYEE");


  Widget getScreen() {
    //admin pages for security
    final adminOnlyMenus = [
      "employee",
      "department",
      "designation",
      "suppliers",
      "category",
      "products",
      "purchase"
    ];

    // other user trying to access admin pages
    if (
    adminOnlyMenus.contains(selectedMenu)
        &&
        !isAdmin()
    ) {

      return const Center(
        child: Text("Access Denied"),
      );
    }
    switch (selectedMenu) {
      case "suppliers":
        return const SupplierScreen();
      case "category":
        return const ProductCategoryScreen();
      case "products":
        return const ProductScreen();
      case "department":
        return const DepartmentScreen();

      case "designation":
        return const DesignationScreen();

      case "employee":
        return const EmployeeScreen();
      case "purchase":
        return const PurchaseScreen();

    // for employee
      case "new_sale":
        return const Center(
          child: Text("New Sale Entry Page"),
        );
      default:
        return DashboardHome();
    }
  }

  String getTitle() {
    switch (selectedMenu) {
      case "suppliers":
        return "Suppliers";
      case "category":
        return "Product Categories";
      case "products":
        return "Products";
      case "department":
        return "Departments";
      case "designation":
        return "Designations";
      case "purchase":
        return "Purchase Order";

      case "employee":
        return "Employees";
      default:
        return "Dashboard Overview";
    }
  }


  Future<void> validatePasswordStatus() async {

    final changed =
    await TokenService
        .isPasswordChanged();

    if(!changed && mounted){

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const ForcePasswordChangeScreen(),
        ),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
          title: Text(
            getTitle(),
            style: GoogleFonts.poppins(
              color: const Color(0xFF1E293B),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
      IconButton(
      icon: const Icon(Icons.notifications_none_rounded,
          color: Color(0xFF64748B)),
      onPressed: () {},
    ),
    // const Padding(
    // padding: EdgeInsets.only(right: 16.0),
    // child: CircleAvatar(
    // radius: 16,
    // // backgroundImage: userImageUrl != null
    // // ? NetworkImage(userImageUrl)
    // //     : null,
    // // child: userImageUrl == null
    // // ? Icon(Icons.person)
    // //     : null,
    // ),
    // ),
    const Padding(
    padding: EdgeInsets.only(right: 16.0),
    child: CircleAvatar(
    radius: 16,
    backgroundColor: Color(0xFFE2E8F0),
    child: Icon(
    Icons.person,
    size: 18,
    color: Color(0xFF64748B),
    ),
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
    );
  }
}
