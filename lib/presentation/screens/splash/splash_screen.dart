import 'package:enterprise_resource_planning/core/services/token_service.dart';
import 'package:enterprise_resource_planning/presentation/screens/dashboard/AdminLayoutScreen.dart';
import 'package:enterprise_resource_planning/presentation/screens/login/force_password_change_screen.dart';
import 'package:enterprise_resource_planning/presentation/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  Future<void> checkLogin() async {

    final loggedIn =
    await TokenService.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {

      final passwordChanged =
      await TokenService
          .isPasswordChanged();

      if(passwordChanged){

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
            const AdminLayoutScreen(),
          ),
        );

      } else {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
            const ForcePasswordChangeScreen(),
          ),
        );
      }

    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}