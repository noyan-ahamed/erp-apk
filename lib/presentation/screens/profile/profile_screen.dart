import 'dart:convert';
import 'dart:io';

import 'package:enterprise_resource_planning/core/services/token_service.dart';
import 'package:enterprise_resource_planning/data/models/user_model.dart';
import 'package:enterprise_resource_planning/data/repositories/user_service.dart';
import 'package:enterprise_resource_planning/presentation/screens/profile/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  UserModel? user;

  bool loading = true;
  bool imageUploading = false;

  @override
  void initState() {
    super.initState();

    loadUser();
  }

  Future<void> loadUser() async {

    final currentUser =
    await UserService.getCurrentUser();

    if(currentUser != null){

      // update local cache
      await TokenService.saveUser(
        jsonEncode(currentUser.toJson()),
      );
    }

    setState(() {
      user = currentUser;
      loading = false;
    });
  }

  Future<void> pickImage() async {

    final picked =
    await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if(picked == null) return;

    try{

      setState(() {
        imageUploading = true;
      });

      await UserService.uploadProfileImage(
        File(picked.path),
      );

      // refresh profile
      await loadUser();

      if(!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Profile image updated",
          ),
        ),
      );

    }catch(e){

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    }finally{

      setState(() {
        imageUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if(loading){

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            CircleAvatar(
              radius: 55,

              backgroundImage:
              user?.imageBase64 != null
                  ? MemoryImage(
                base64Decode(
                  user!.imageBase64!,
                ),
              )
                  : null,

              child: user?.imageBase64 == null
                  ? const Icon(
                Icons.person,
                size: 50,
              )
                  : null,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed:
              imageUploading
                  ? null
                  : pickImage,

              icon: const Icon(Icons.upload),

              label: Text(
                imageUploading
                    ? "Uploading..."
                    : "Change Photo",
              ),
            ),

            const SizedBox(height: 30),

            _tile(
              "Name",
              user?.name ?? "",
            ),

            _tile(
              "Email",
              user?.email ?? "",
            ),

            _tile(
              "Username",
              user?.username ?? "",
            ),

            _tile(
              "Status",
              user?.status ?? "",
            ),

            _tile(
              "Created At",
              user?.createdAt ?? "",
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                icon: const Icon(Icons.lock_reset),

                label: const Text(
                  "Change Password",
                ),

                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const ChangePasswordScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(
      String title,
      String value,
      ) {

    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}