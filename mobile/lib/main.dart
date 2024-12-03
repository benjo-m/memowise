import 'package:flutter/material.dart';
import 'package:mobile/services/auth/firebase_auth_provider.dart';
import 'package:mobile/views/main_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseAuthProvider().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber)),
      home: const MainView(),
    );
  }
}
