import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile/services/auth/firebase_auth_provider.dart';
import 'package:mobile/views/login_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () =>
                  log(FirebaseAuthProvider().currentUser.toString()),
              child: const Text("Get current user")),
          ElevatedButton(
              onPressed: () {
                FirebaseAuthProvider().logOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              },
              child: const Text("Log out")),
        ],
      )),
    );
  }
}
