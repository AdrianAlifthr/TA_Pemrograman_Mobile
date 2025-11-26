import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class WaiterOrderScreen extends StatelessWidget {
  const WaiterOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Table Order"), backgroundColor: Colors.transparent),
      body: Column(
        children: [
          // Kategori
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                 Padding(padding: EdgeInsets.only(right: 20), child: Text("Main Course", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                 Padding(padding: EdgeInsets.only(right: 20), child: Text("Dessert", style: TextStyle(color: Colors.grey))),
                 Padding(padding: EdgeInsets.only(right: 20), child: Text("Drinks", style: TextStyle(color: Colors.grey))),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(20),
              childAspectRatio: 0.8,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _menuItemWaiter("Salmon", "\$16.00"),
                _menuItemWaiter("Burger", "\$8.00"),
                _menuItemWaiter("Salad", "\$12.00"),
                _menuItemWaiter("Tiramisu", "\$14.00"),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        label: const Text("Ringkasan (3)", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
    );
  }

  Widget _menuItemWaiter(String name, String price) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.fastfood, size: 50, color: Colors.orange),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(price),
          const SizedBox(height: 10),
          const CircleAvatar(radius: 15, backgroundColor: AppColors.primary, child: Icon(Icons.add, color: Colors.white, size: 16))
        ],
      ),
    );
  }
}