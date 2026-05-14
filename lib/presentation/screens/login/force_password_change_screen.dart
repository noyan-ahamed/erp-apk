import 'package:enterprise_resource_planning/data/models/first_password_change_request.dart';
import 'package:enterprise_resource_planning/data/repositories/password_service.dart';
import 'package:enterprise_resource_planning/presentation/screens/dashboard/AdminLayoutScreen.dart';
import 'package:flutter/material.dart';

class ForcePasswordChangeScreen
    extends StatefulWidget {

  const ForcePasswordChangeScreen({
    super.key,
  });

  @override
  State<ForcePasswordChangeScreen>
  createState() =>
      _ForcePasswordChangeScreenState();
}

class _ForcePasswordChangeScreenState
    extends State<
        ForcePasswordChangeScreen> {

  final newPasswordController =
  TextEditingController();

  final confirmPasswordController =
  TextEditingController();

  bool loading = false;

  final passwordService =
  PasswordService();

  Future<void> changePassword() async {

    if(newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty){

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
              "All fields required"
          ),
        ),
      );

      return;
    }

    if(newPasswordController.text !=
        confirmPasswordController.text){

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
              "Passwords do not match"
          ),
        ),
      );

      return;
    }

    try {

      setState(() => loading = true);

      await passwordService
          .firstPasswordChange(
        FirstPasswordChangeRequest(
          newPassword:
          newPasswordController.text,
          confirmPassword:
          confirmPasswordController.text,
        ),
      );

      if(!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const AdminLayoutScreen(),
        ),
            (route) => false,
      );

    } catch(e){

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
              e.toString()
          ),
        ),
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
          padding:
          const EdgeInsets.all(24),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [

              const Text(
                "Change Password",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                  height: 10),

              const Text(
                "You must change your password before continuing",
                textAlign:
                TextAlign.center,
              ),

              const SizedBox(
                  height: 30),

              TextField(
                controller:
                newPasswordController,
                obscureText: true,
                decoration:
                const InputDecoration(
                  labelText:
                  "New Password",
                ),
              ),

              const SizedBox(
                  height: 20),

              TextField(
                controller:
                confirmPasswordController,
                obscureText: true,
                decoration:
                const InputDecoration(
                  labelText:
                  "Confirm Password",
                ),
              ),

              const SizedBox(
                  height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                  loading
                      ? null
                      : changePassword,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text(
                      "Change Password"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}