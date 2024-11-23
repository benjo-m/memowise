import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/user.dart';
import 'dart:convert';
import 'package:mobile/views/decks_view.dart';
import 'package:mobile/views/register_view.dart';

Future<User> login(String username, String password) async {
  final response = await http.post(
    Uri.parse('https://localhost:7251/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Login failed.');
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  Future? _loginFuture;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const DecksView()),
                      //   (route) => false, // Remove all previous routes
                      // );
                      // login(_usernameController.text, _passwordController.text);
                      setState(() {
                        _loginFuture = login(
                            _usernameController.text, _passwordController.text);
                      });

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Scaffold(
                                  body: buildFutureBuilder(),
                                )),
                        (route) => false, // Remove all previous routes
                      );
                    }
                  },
                  child: const Text("Log in"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterView()),
                      (route) => false, // Remove all previous routes
                    );
                  },
                  child:
                      const Text("Don't have an account? Create a new account"),
                )
              ],
            ),
          )),
    );
  }

  FutureBuilder buildFutureBuilder() {
    return FutureBuilder(
      future: _loginFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.username);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
