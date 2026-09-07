import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const AvootaApp());
}

class AvootaApp extends StatelessWidget {
  const AvootaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avoota Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}