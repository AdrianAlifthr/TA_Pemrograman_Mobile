import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_config.dart';
import 'package:flutter_application_1/main.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _msg = "";
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFE6EABD)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: const Text(
                    "Resto Management",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                // Form Login Sederhana
                _buildLabel("Username"),
                _buildTextField(
                  Icons.person,
                  "Enter your username",
                  _usernameController,
                ),
                const SizedBox(height: 20),
                _buildLabel("Password"),
                _buildTextField(
                  Icons.lock,
                  "Enter your password",
                  _passwordController,
                  isObscure: true,
                ),
                const SizedBox(height: 35),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {
                      login();
                    },
                    child: const Text("Login"),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(_msg, style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  Widget _buildTextField(
    IconData icon,
    String hint,
    control, {
    bool isObscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: control,
        obscureText: isObscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primary),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  void login() async {
    String url = ApiConfig.login;

    final Map<String, dynamic> queryParams = {
      "username": _usernameController.text,
      "password": _passwordController.text,
    };

    try {
      http.Response response = await http.get(
        Uri.parse(url).replace(queryParameters: queryParams),
      );

      if (!mounted) return; // ⬅️ tambah ini

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == "success") {
          final role = data["user"]["role"];

          if (role == "chef") {
            Navigator.pushReplacementNamed(context, '/chefNavigation');
          } else if (role == "waiter") {
            Navigator.pushReplacementNamed(context, '/waiterNavigation');
          } else {
            setState(() {
              _msg = "Role tidak dikenal";
            });
          }
        } else {
          setState(() {
            _msg = data["message"];
          });
        }
      } else {
        debugPrint("HTTP ERROR : ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("ERROR : $e");
    }
  }
}
