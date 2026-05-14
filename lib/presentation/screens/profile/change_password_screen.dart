import 'package:enterprise_resource_planning/data/models/change_password_model.dart';
import 'package:enterprise_resource_planning/data/repositories/user_service.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen
    extends StatefulWidget {

  const ChangePasswordScreen({
    super.key,
  });

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {

  final currentController =
  TextEditingController();

  final newController =
  TextEditingController();

  final confirmController =
  TextEditingController();

  bool loading = false;

  Future<void> changePassword() async {

    if(newController.text !=
        confirmController.text){

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Passwords do not match",
          ),
        ),
      );

      return;
    }

    try{

      setState(() {
        loading = true;
      });

      await UserService.changePassword(
        ChangePasswordModel(
          currentPassword:
          currentController.text,

          newPassword:
          newController.text,

          confirmPassword:
          confirmController.text,
        ),
      );

      if(!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Password changed successfully",
          ),
        ),
      );

      Navigator.pop(context);

    }catch(e){

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );

    }finally{

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Password",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: currentController,
              obscureText: true,

              decoration:
              const InputDecoration(
                labelText:
                "Current Password",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: newController,
              obscureText: true,

              decoration:
              const InputDecoration(
                labelText:
                "New Password",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: confirmController,
              obscureText: true,

              decoration:
              const InputDecoration(
                labelText:
                "Confirm Password",
              ),
            ),

            const SizedBox(height: 30),

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
                  "Update Password",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}