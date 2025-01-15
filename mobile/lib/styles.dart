import 'package:flutter/material.dart';

Color primaryBackgroundColor = const Color.fromARGB(255, 232, 244, 252);
Color primaryBorderColor = const Color.fromARGB(255, 217, 234, 247);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    centerTitle: true,
  ),
  inputDecorationTheme: InputDecorationTheme(
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 197, 197, 197),
        width: 3,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 197, 197, 197),
        width: 3,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 197, 197, 197),
        width: 3,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 3,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 3,
      ),
    ),
    floatingLabelStyle: const TextStyle(
      fontSize: 20,
      color: Colors.black,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  scaffoldBackgroundColor: Colors.grey,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 0, 102, 255),
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    centerTitle: true,
  ),
  inputDecorationTheme: InputDecorationTheme(
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 197, 197, 197),
        width: 3,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 197, 197, 197),
        width: 3,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 197, 197, 197),
        width: 3,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 3,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 3,
      ),
    ),
    floatingLabelStyle: const TextStyle(
      fontSize: 20,
      color: Colors.black,
    ),
  ),
);
