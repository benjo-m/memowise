import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/dtos/login_request.dart';
import 'package:mobile/services/auth/auth_service.dart';
import 'package:mobile/views/main_view.dart';
import 'package:mobile/views/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Login")),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
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
                ElevatedButton(
                  onPressed: () async {
                    await login(context);
                  },
                  child: const Text("Log in"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterView()),
                      (route) => false,
                    );
                  },
                  child: const Text("Don't have an account? Register here."),
                ),
                ElevatedButton(
                  onPressed: () {
                    log(FirebaseAuth.instance.currentUser.toString());
                  },
                  child: const Text("Current user"),
                ),
              ],
            ),
          )),
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

      // TODO: Store inside secureStorage
      if (user == null && context.mounted) {
        showWrongCredentialsDialog(context);
      } else {
        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainView()),
            (route) => false,
          );
        }
      }
    }
  }

  Future<dynamic> showWrongCredentialsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Wrong credentials"),
              content: const Text(
                  "Try again with different credentials or create a new account."),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                          return const RegisterView();
                        }),
                        (route) => false,
                      );
                    },
                    child: const Text("Register")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Close"))
              ],
            ));
  }
}
