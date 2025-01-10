import 'dart:developer';

import 'package:desktop/dto/login_request.dart';
import 'package:desktop/services/auth_service.dart';
import 'package:desktop/styles.dart';
import 'package:desktop/views/main_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Admin Login")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 50,
            right: MediaQuery.sizeOf(context).width * 0.35,
            left: MediaQuery.sizeOf(context).width * 0.35,
          ),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Username is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () async => await login(context),
                    style: blueButtonStyle,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.login_rounded),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Log in"),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var user = await AuthService().login(
        LoginRequest(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );

      if ((user == null || user.isAdmin == false) && context.mounted) {
        showInvalidCredentialsDialog(context);
      } else {
        log(user!.toJson().toString());
        if (context.mounted) {
          CurrentUser.userId = user.id;
          CurrentUser.isSuperAdmin = user.isSuperAdmin;
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainView()),
            (route) => false,
          );
        }
      }
    }
  }

  Future<dynamic> showInvalidCredentialsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
                title: const Text(
                  "Invalid credentials",
                  textAlign: TextAlign.center,
                ),
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Try again with different credentials.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Close"),
                      ),
                    ],
                  )
                ]));
  }
}
