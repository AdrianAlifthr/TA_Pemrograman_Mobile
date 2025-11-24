import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pages/chef_navigation.dart';
import 'package:flutter_application_1/pages/waiter_navigation.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("POS SYSTEM", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 50),
              // Form Login Sederhana
              _buildTextField(Icons.person, "Username"),
              const SizedBox(height: 20),
              _buildTextField(Icons.lock, "Password", isObscure: true),
              const SizedBox(height: 40),
              
              // SIMULASI LOGIN UNTUK 2 ROLE BERBEDA
              const Text("Simulasi Login Sebagai:", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        // Masuk sebagai Waiters (3 Navbar)
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WaiterNavigation()));
                      },
                      child: const Text("WAITER (3 Menu)"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        // Masuk sebagai Chef (4 Navbar)
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChefNavigation()));
                      },
                      child: const Text("CHEF (4 Menu)"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint, {bool isObscure = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        obscureText: isObscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primary),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}