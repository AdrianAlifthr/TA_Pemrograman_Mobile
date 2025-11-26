import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/chef_navigation.dart';
import 'package:flutter_application_1/pages/login_page.dart';
import 'package:flutter_application_1/pages/waiter_navigation.dart';

class AppColors {
  static const Color background = Color(0xFFF4F4DC);
  static const Color primary = Color(0xFF5D6D36);
  static const Color accentRed = Color(0xFF8B3A3A);
  static const Color accentOrange = Color(0xFFD98E3E);
  static const Color accentGreen = Color(0xFF4E6B3E);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color cardWhite = Colors.white;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/chefNavigation': (context) => const ChefNavigation(),
        '/waiterNavigation': (context) => const WaiterNavigation(),
      },
      home: LoginScreen(),
    );
  }
}
