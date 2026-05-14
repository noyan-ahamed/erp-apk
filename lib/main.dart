import 'package:enterprise_resource_planning/data/providers/approve_payment_provider.dart';
import 'package:enterprise_resource_planning/data/providers/sales_provider.dart';
import 'package:enterprise_resource_planning/data/providers/supplier_ledger_provider.dart';
import 'package:enterprise_resource_planning/data/repositories/customer_payment_service.dart';
import 'package:enterprise_resource_planning/data/repositories/customer_service.dart';
import 'package:enterprise_resource_planning/data/repositories/product_service.dart';
import 'package:enterprise_resource_planning/data/providers/customer_ledger_provider.dart';
import 'package:enterprise_resource_planning/data/repositories/customer_ledger_repository.dart';
import 'package:enterprise_resource_planning/data/repositories/sales_service.dart';
import 'package:enterprise_resource_planning/data/repositories/supplier_ledger_repository.dart';
import 'package:enterprise_resource_planning/data/repositories/supplier_service.dart';
import 'package:enterprise_resource_planning/presentation/screens/splash/splash_screen.dart';
import 'package:enterprise_resource_planning/core/providers/theme_provider.dart';
import 'package:enterprise_resource_planning/core/config/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => SalesProvider(
            salesService: SalesService(),
            productService: ProductService(),
            customerService: CustomerService(),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => SupplierLedgerProvider(
            ledgerRepository: SupplierLedgerRepository(),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => CustomerLedgerProvider(
            ledgerRepository: CustomerLedgerRepository(),
          )..loadCustomers(),
        ),

        ChangeNotifierProvider(
          create: (_) => ApprovePaymentProvider(
            service: CustomerPaymentService(),
          )..fetchPayments(),
        ),

        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const SplashScreen(),
        );
      },
    );
  }
}