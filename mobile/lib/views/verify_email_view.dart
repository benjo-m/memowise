import 'package:flutter/material.dart';
import 'package:mobile/services/auth/firebase_auth_provider.dart';
import 'package:mobile/views/main_view.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Email verification"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Text(
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
                "An email verification link has been sent to $email."),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Resend"),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuthProvider().reloadUser();
                    if (FirebaseAuthProvider().currentUser!.emailVerified) {
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const MainView()),
                          (route) => false,
                        );
                      }
                    } else {
                      if (context.mounted) {
                        showEmailNotVerifiedDialog(context);
                      }
                    }
                  },
                  child: const Text("Continue"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showEmailNotVerifiedDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Email not verified"),
              content: const Text(
                "Verify your email by following the link sent to your email",
              ),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close")),
              ],
            ));
  }
}
