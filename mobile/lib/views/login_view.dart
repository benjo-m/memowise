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
  bool _hidePassword = true;

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
                  const Text(
                    "Welcome back, log in to continue!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
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
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.password),
                      suffixIcon: _hidePassword
                          ? GestureDetector(
                              onTap: () => setState(
                                  () => _hidePassword = !_hidePassword),
                              child: const Icon(Icons.visibility))
                          : GestureDetector(
                              onTap: () => setState(
                                  () => _hidePassword = !_hidePassword),
                              child: const Icon(Icons.visibility_off)),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    obscureText: _hidePassword,
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
                    onPressed: () async => await login(context),
                    style: ButtonStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(Colors.lightBlue),
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.white),
                      padding: WidgetStatePropertyAll(
                        EdgeInsets.all(
                            MediaQuery.sizeOf(context).height * 0.013),
                      ),
                      fixedSize: WidgetStatePropertyAll(
                        Size.fromWidth(
                          MediaQuery.sizeOf(context).width * 0.4,
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
                  const SizedBox(height: 10),
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

      if ((user == null || user.isAdmin) && context.mounted) {
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
