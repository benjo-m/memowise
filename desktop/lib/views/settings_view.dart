import 'package:desktop/services/auth_service.dart';
import 'package:desktop/views/login_view.dart';
import 'package:flutter/material.dart';

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
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text("Settings"),
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              AuthService().logOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
              );
            },
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
