import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile/services/auth/auth_exceptions.dart';
import 'package:mobile/services/auth/firebase_auth_provider.dart';
import 'package:mobile/views/login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _emailValidationText = "";
  String _passwordValidationText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Register")),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    } else if (_emailValidationText != "") {
                      return _emailValidationText;
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
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    } else if (_passwordValidationText != "") {
                      return _passwordValidationText;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _emailValidationText = "";
                      _passwordValidationText = "";
                    });
                    if (_formKey.currentState!.validate()) {
                      try {
                        await FirebaseAuthProvider().register(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      } on EmailAlreadyInUseAuthException {
                        setState(() {
                          _emailValidationText = "Email already in use";
                        });
                        _formKey.currentState!.validate();
                      } on InvalidEmailAuthException {
                        setState(() {
                          _emailValidationText = "Invalid email";
                        });
                        _formKey.currentState!.validate();
                      } on WeakPasswordAuthException {
                        setState(() {
                          _passwordValidationText = "Weak password";
                        });
                        _formKey.currentState!.validate();
                      } catch (e) {
                        log(e.toString());
                      }
                    }
                  },
                  child: const Text("Register"),
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
                    child:
                        const Text("Already have an account? Log in instead."))
              ],
            ),
          )),
    );
  }
}
