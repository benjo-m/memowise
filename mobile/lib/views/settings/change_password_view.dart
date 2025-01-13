import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/dtos/change_password_request.dart';
import 'package:mobile/services/auth/auth_exceptions.dart';
import 'package:mobile/services/auth/current_user.dart';
import 'package:mobile/services/user_service.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  String? _currentPasswordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    errorText: _currentPasswordError,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters long";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final currentPassword =
                          _currentPasswordController.text.trim();
                      final newPassword = _newPasswordController.text.trim();
                      final changePasswordRequest = ChangePasswordRequest(
                        currentPassword: currentPassword,
                        newPassword: newPassword,
                      );
                      try {
                        await UserService()
                            .changePassword(changePasswordRequest);
                        CurrentUser.password = newPassword;
                        CurrentUser.authHeader =
                            "Basic ${base64Encode(utf8.encode('${CurrentUser.username}:${CurrentUser.password}'))}";
                        if (context.mounted) {
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                            msg: "Password Changed!",
                            gravity: ToastGravity.CENTER,
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor:
                                const Color.fromARGB(255, 188, 234, 255),
                            textColor: Colors.black,
                            fontSize: 16,
                          );
                        }
                      } on WrongPasswordException catch (_) {
                        setState(() {
                          _currentPasswordError = "Wrong Password";
                        });
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        const WidgetStatePropertyAll(Colors.lightBlue),
                    foregroundColor: const WidgetStatePropertyAll(Colors.white),
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.all(MediaQuery.sizeOf(context).height * 0.014),
                    ),
                    fixedSize: WidgetStatePropertyAll(
                      Size.fromWidth(
                        MediaQuery.sizeOf(context).width * 0.4,
                      ),
                    ),
                  ),
                  child: const Text("Change Password"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
