import 'package:desktop/styles.dart';
import 'package:desktop/views/main_view.dart';
import 'package:flutter/material.dart';

void dataViewWarningDialog(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Center(
            child:
                Text("WARNING", style: TextStyle(fontWeight: FontWeight.bold))),
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Access to this screen is restricted to Super Admins only.\n\n"
              "This screen should ONLY be used for bug fixes and critical maintenance.\n\n"
              "Editing data from this screen is extremely dangerous because it allows the Super Admin to\ncreate, read, update and delete all application data at the database level "
              "and could lead to\nSERIOUS bugs, inaccurate analytics data "
              "or unexpected behavior for users.\n\nPlease ensure you fully understand the implications "
              "before making any changes.\n\n"
              "If you're not certain about the changes you need to make, it is advised to leave the data unchanged.\n",
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: redButtonStyle,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainView()),
                    (route) => false,
                  );
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(width: 20),
              TextButton(
                style: blueButtonStyle,
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "Proceed",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: false,
    );
  });
}
