import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile/services/auth/firebase_auth_provider.dart';
import 'package:mobile/views/main_view.dart';
import 'package:mobile/views/register_view.dart';
import 'package:mobile/views/verify_email_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
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
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
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
                    await logIn(context);
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
              ],
            ),
          )),
    );
  }

  Future<void> logIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuthProvider().logIn(
          email: _emailController.text,
          password: _passwordController.text,
        );

        var currentUser = FirebaseAuthProvider().currentUser;

        if (currentUser != null && context.mounted) {
          if (currentUser.emailVerified) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainView()),
              (route) => false,
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => VerifyEmailView(
                        email: _emailController.text,
                      )),
            );
            await FirebaseAuthProvider().sendEmailVerification();
          }
        }
      } catch (e) {
        log(e.toString());
        if (context.mounted) {
          showWrongCredentialsDialog(context);
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
