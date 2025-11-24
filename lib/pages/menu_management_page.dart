import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class ChefMenuManagementScreen extends StatelessWidget {
  const ChefMenuManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu Management"), backgroundColor: Colors.transparent),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
               padding: const EdgeInsets.all(10),
               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
               child: const Row(children: [Icon(Icons.search), SizedBox(width: 10), Text("Search Menu")]),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              childAspectRatio: 0.75,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _menuItemAdmin("Salmon", true),
                _menuItemAdmin("Tiramisu", false),
                _menuItemAdmin("Burger", true),
                _menuItemAdmin("Salad", true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItemAdmin(String name, bool isAvailable) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEEE8AA), // Placeholder gambar
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: const Center(child: Icon(Icons.image, color: Colors.white)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(isAvailable ? "Available" : "Empty", style: TextStyle(fontSize: 12, color: isAvailable ? Colors.green : Colors.grey)),
                    Switch(
                      value: isAvailable, 
                      onChanged: (val){},
                      activeColor: AppColors.primary,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}