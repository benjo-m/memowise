import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/dtos/login_request.dart';
import 'package:mobile/dtos/login_response.dart';
import 'package:mobile/services/auth/auth_service.dart';
import 'package:mobile/services/auth/current_user.dart';
import 'package:mobile/views/main_view.dart';
import 'package:mobile/views/register_view.dart';

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
        title: const Center(child: Text("Login")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
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
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Color(0xff03AED2)),
                      foregroundColor: WidgetStatePropertyAll(Colors.white),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.all(
                            MediaQuery.sizeOf(context).height * 0.013),
                      ),
                      fixedSize: WidgetStatePropertyAll(
                        Size.fromWidth(
                          MediaQuery.sizeOf(context).width * 0.4,
                        ),
                      ),
                      side: WidgetStatePropertyAll(
                        BorderSide(
                          width: 2,
                          color: Colors.lightBlue,
                        ),
                      ),
                    ),
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

      if (user == null && context.mounted) {
        showWrongCredentialsDialog(context);
      } else {
        if (context.mounted) {
          setCurrentUser(user);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainView()),
            (route) => false,
          );
        }
      }
    }
  }

  void setCurrentUser(LoginResponse? user) {
    CurrentUser.userId = user!.id;
    CurrentUser.username = user.username;
    CurrentUser.email = user.email;
    CurrentUser.password = _passwordController.text;
    CurrentUser.authHeader =
        "Basic ${base64Encode(utf8.encode('${CurrentUser.username}:${CurrentUser.password}'))}";
    CurrentUser.isPremium = user.isPremium;
    CurrentUser.isAdmin = user.isAdmin;
  }

  Future<dynamic> showWrongCredentialsDialog(BuildContext context) {
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
                      "Try again with different credentials or create a new account.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                              return const RegisterView();
                            }),
                            (route) => false,
                          );
                        },
                        child: const Text("Register"),
                      ),
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
