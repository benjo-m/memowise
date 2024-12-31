import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/dtos/delete_user_request.dart';
import 'package:mobile/dtos/update_user_request.dart';
import 'package:mobile/services/auth/auth_exceptions.dart';
import 'package:mobile/services/auth/auth_service.dart';
import 'package:mobile/services/auth/current_user.dart';
import 'package:mobile/services/user_service.dart';
import 'package:mobile/views/login_view.dart';
import 'package:mobile/views/settings/change_password_view.dart';
import 'package:mobile/views/settings/feedback_view.dart';
import 'package:mobile/views/settings/premium_upgrade_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _usernameError;
  String? _emailError;

  late FocusNode _usernameFocusNode;
  late FocusNode _emailFocusNode;

  @override
  void initState() {
    super.initState();
    _usernameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _usernameController.text = CurrentUser.username ?? "";
    _emailController.text = CurrentUser.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Account Settings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        focusNode: _usernameFocusNode,
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          errorText: _usernameError,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Username is required";
                          }
                          return null;
                        },
                        onEditingComplete: () async => updateUser(),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        focusNode: _emailFocusNode,
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          errorText: _emailError,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
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
                        onEditingComplete: () async => updateUser(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => showDeleteAccountDialog(),
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(
                            Color.fromARGB(255, 243, 83, 71)),
                        foregroundColor:
                            const WidgetStatePropertyAll(Colors.white),
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.all(
                              MediaQuery.sizeOf(context).height * 0.014),
                        ),
                        fixedSize: WidgetStatePropertyAll(
                          Size.fromWidth(
                            MediaQuery.sizeOf(context).width * 0.4,
                          ),
                        ),
                        side: const WidgetStatePropertyAll(
                          BorderSide(
                            width: 2,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      child: const Text("Delete Account"),
                    ),
                    TextButton(
                      onPressed: () async => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ChangePasswordView())),
                      style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(Color(0xff03AED2)),
                        foregroundColor:
                            const WidgetStatePropertyAll(Colors.white),
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.all(
                              MediaQuery.sizeOf(context).height * 0.014),
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
                      child: const Text("Change Password"),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Text(
                  "Application Settings",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (!CurrentUser.isPremium!) const SizedBox(height: 20),
                if (!CurrentUser.isPremium!)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        child: Text(
                          "Unlock the full experience with the Premium upgrade",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 85, 85, 85),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PremiumUpgradeView()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: const WidgetStatePropertyAll(
                            Color.fromARGB(255, 241, 183, 7),
                          ),
                          foregroundColor:
                              const WidgetStatePropertyAll(Colors.white),
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.all(
                                MediaQuery.sizeOf(context).height * 0.014),
                          ),
                          fixedSize: WidgetStatePropertyAll(
                            Size.fromWidth(
                              MediaQuery.sizeOf(context).width * 0.3,
                            ),
                          ),
                          side: const WidgetStatePropertyAll(
                            BorderSide(
                              width: 2,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        child: const Text("Upgrade"),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        "Delete all data and start fresh, your account remains intact!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 85, 85, 85),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: () async => deleteData(),
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(
                            Color.fromARGB(255, 243, 83, 71)),
                        foregroundColor:
                            const WidgetStatePropertyAll(Colors.white),
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.all(
                              MediaQuery.sizeOf(context).height * 0.014),
                        ),
                        fixedSize: WidgetStatePropertyAll(
                          Size.fromWidth(
                            MediaQuery.sizeOf(context).width * 0.3,
                          ),
                        ),
                        side: const WidgetStatePropertyAll(
                          BorderSide(
                            width: 2,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      child: const Text("Delete Data"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        "Encountered a bug or have a suggestion to improve the app?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 85, 85, 85),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: () async => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FeedbackView())),
                      style: ButtonStyle(
                        backgroundColor:
                            const WidgetStatePropertyAll(Color(0xff03AED2)),
                        foregroundColor:
                            const WidgetStatePropertyAll(Colors.white),
                        padding: WidgetStatePropertyAll(
                          EdgeInsets.all(
                              MediaQuery.sizeOf(context).height * 0.014),
                        ),
                        fixedSize: WidgetStatePropertyAll(
                          Size.fromWidth(
                            MediaQuery.sizeOf(context).width * 0.3,
                          ),
                        ),
                        side: const WidgetStatePropertyAll(
                          BorderSide(
                            width: 2,
                            color: Colors.lightBlue,
                          ),
                        ),
                      ),
                      child: const Text("Feedback"),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async => logout(),
                      style: ButtonStyle(
                        backgroundColor: const WidgetStatePropertyAll(
                          Color.fromARGB(255, 173, 173, 173),
                        ),
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
                            color: Color.fromARGB(255, 165, 165, 165),
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded),
                          SizedBox(
                            width: 8,
                          ),
                          Text("Log Out"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateUser() async {
    _usernameFocusNode.unfocus();
    _emailFocusNode.unfocus();

    setState(() {
      _usernameError = null;
      _emailError = null;
    });

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();

    if (username.isEmpty) {
      _usernameController.text = CurrentUser.username ?? "";
    }

    if (email.isEmpty) {
      _emailController.text = CurrentUser.email ?? "";
    }

    if (_formKey.currentState!.validate()) {
      final updateUserRequest = UpdateUserRequest(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
      );

      try {
        await UserService().updateUser(updateUserRequest);
        CurrentUser.username = _usernameController.text.trim();
        CurrentUser.email = _emailController.text.trim();
        CurrentUser.authHeader =
            "Basic ${base64Encode(utf8.encode('${CurrentUser.username}:${CurrentUser.password}'))}";
      } on UsernameTakenException catch (_) {
        setState(() {
          _usernameError = "Username taken";
        });
      } on EmailAlreadyInUseException catch (_) {
        setState(() {
          _emailError = "Email already in use";
        });
      }
    }
  }

  void logout() {
    AuthService().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );
  }

  showDeleteAccountDialog() {
    String? passwordError;

    showDialog(
      context: context,
      builder: (context) {
        final passwordController = TextEditingController();
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              title: const Center(child: Text("Delete Account")),
              children: [
                const Center(
                    child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("Are you sure you want to delete your account?"),
                )),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: passwordError,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (passwordController.text.trim().isEmpty) {
                          setState(() {
                            passwordError =
                                "You must enter your password to proceed";
                          });
                          return;
                        } else if (passwordController.text.trim() !=
                            CurrentUser.password) {
                          setState(() {
                            passwordError = "Wrong password";
                          });
                          return;
                        }

                        await UserService().deleteUser(DeleteUserRequest(
                            password: passwordController.text));

                        AuthService().logout();

                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const LoginView()),
                            (route) => false,
                          );
                        }
                      },
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  deleteData() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Center(child: Text("Delete Data")),
          children: [
            const Center(
              child: Text(
                "This action will delete all your decks, cards, and achievements.\nAre you sure you want to proceed?",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await UserService().deleteAllData();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Delete"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
