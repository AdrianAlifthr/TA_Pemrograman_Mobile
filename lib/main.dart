import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login_page.dart';

void main() {
  runApp(const RestaurantApp());
}

// --- 1. KONFIGURASI TEMA & WARNA ---
class AppColors {
  static const Color background = Color(0xFFF4F4DC); // Krem terang
  static const Color primary = Color(0xFF5D6D36); // Hijau Olive
  static const Color accentRed = Color(0xFF8B3A3A); 
  static const Color accentOrange = Color(0xFFD98E3E);
  static const Color accentGreen = Color(0xFF4E6B3E);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color cardWhite = Colors.white;
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant POS System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: const LoginScreen(),
    );
  }
}