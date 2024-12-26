import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile/dtos/register_request.dart';
import 'package:mobile/dtos/register_response.dart';
import 'package:mobile/services/auth/auth_exceptions.dart';
import 'package:mobile/services/auth/auth_service.dart';
import 'package:mobile/services/auth/current_user.dart';
import 'package:mobile/views/login_view.dart';
import 'package:mobile/views/main_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _usernameError;
  String? _emailError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Register")),
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
                    decoration: InputDecoration(
                      labelText: 'Username',
                      errorText: _usernameError,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Username is required";
                      } else if (value.length > 50) {
                        return "Username must be 50 characters of fewer";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: _emailError,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email is required";
                      }
                      const pattern =
                          r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                      final regex = RegExp(pattern);
                      if (!regex.hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Password is required";
                      }
                      if (value != _confirmPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm password',
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () async => await register(context),
                    style: ButtonStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(Color(0xff03AED2)),
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
                      side: const WidgetStatePropertyAll(
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
                        Text("Register"),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginView()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                          "Already have an account? Log in instead.")),
                ],
              )),
        ),
      ),
    );
  }

  Future<void> register(BuildContext context) async {
    setState(() {
      _usernameError = null;
      _emailError = null;
    });

    if (_formKey.currentState!.validate()) {
      try {
        var user = await AuthService().register(
          RegisterRequest(
            username: _usernameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            passwordConfirmation: _passwordController.text,
          ),
        );

        setCurrentUser(user);

        if (context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainView()),
            (route) => false,
          );
        }
      } on UsernameTakenException {
        setState(() {
          _usernameError = "Username taken";
        });
      } on EmailAlreadyInUseException {
        setState(() {
          _emailError = "Email already in use";
        });
      } on InvalidEmailException {
        setState(() {
          _emailError = "Invalid email";
        });
      } catch (e) {
        log(e.toString());
      }
    }
  }

  setCurrentUser(RegisterResponse user) {
    CurrentUser.userId = user.id;
    CurrentUser.username = user.username;
    CurrentUser.email = user.email;
    CurrentUser.password = _passwordController.text;
    CurrentUser.authHeader =
        "Basic ${base64Encode(utf8.encode('${CurrentUser.username}:${CurrentUser.password}'))}";
    CurrentUser.isPremium = user.isPremium;
    CurrentUser.isAdmin = user.isAdmin;
  }
}
