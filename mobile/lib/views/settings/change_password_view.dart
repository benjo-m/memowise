import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/dtos/change_password_request.dart';
import 'package:mobile/services/auth/auth_exceptions.dart';
import 'package:mobile/services/auth/auth_service.dart';
import 'package:mobile/services/auth/current_user.dart';

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
      body: Padding(
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
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextButton(
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
                      await AuthService().changePassword(changePasswordRequest);
                      CurrentUser.password = newPassword;
                      CurrentUser.authHeader =
                          "Basic ${base64Encode(utf8.encode('${CurrentUser.username}:${CurrentUser.password}'))}";
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } on WrongPasswordException catch (_) {
                      setState(() {
                        _currentPasswordError = "Wrong Password";
                      });
                    }
                  }
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0xff03AED2)),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  fixedSize: WidgetStatePropertyAll(Size(140, 45)),
                  side: WidgetStatePropertyAll(
                    BorderSide(
                      width: 2,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                child: const Text("Change Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
