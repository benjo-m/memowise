import 'package:desktop/services/auth_service.dart';
import 'package:desktop/styles.dart';
import 'package:desktop/views/login_view.dart';
import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text("Log Out?")),
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Are you sure you want to log out?"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      style: redButtonStyle,
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  const SizedBox(width: 20),
                  TextButton(
                      style: greyButtonStyle,
                      child: const Text("Log Out"),
                      onPressed: () {
                        AuthService().logOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginView()),
                          (route) => false,
                        );
                      }),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
