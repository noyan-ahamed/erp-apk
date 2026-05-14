import 'package:enterprise_resource_planning/data/models/login_request_model.dart';
import 'package:enterprise_resource_planning/data/repositories/auth_service.dart';
import 'package:enterprise_resource_planning/presentation/screens/dashboard/AdminLayoutScreen.dart';
import 'package:enterprise_resource_planning/presentation/screens/login/force_password_change_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  bool loading = false;

  final authService = AuthService();

  Future<void> login() async {

    try {

      setState(() => loading = true);

      final response =
      await authService.login(
        LoginRequestModel(
          userName:
          emailController.text,
          userPassword:
          passwordController.text,
        ),
      );

      if (!mounted) return;

      if(response.passwordChanged){

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

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

    } finally {

      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "ERP Login",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Username",
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                  loading ? null : login,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text("Login"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
