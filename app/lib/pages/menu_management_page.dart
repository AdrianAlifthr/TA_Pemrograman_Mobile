import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class ChefMenuManagementScreen extends StatefulWidget {
  const ChefMenuManagementScreen({super.key});

  @override
  State<ChefMenuManagementScreen> createState() => _ChefMenuManagementScreenState();
}

class _ChefMenuManagementScreenState extends State<ChefMenuManagementScreen> {
  TextEditingController searchController = TextEditingController();

  
  List<Map<String, dynamic>> menus = [
    {"name": "Salmon", "available": true},
    {"name": "Tiramisu", "available": false},
    {"name": "Burger", "available": true},
    {"name": "Salad", "available": true},
  ];

  @override
  Widget build(BuildContext context) {
    List filteredMenu = menus
        .where((m) => m["name"].toLowerCase().contains(searchController.text.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Menu Management"), backgroundColor: Colors.transparent),
      backgroundColor: Color(0xFFE6EABD),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Search Menu",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                ],
              ),
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
                for (var item in filteredMenu)
                  _menuItemAdmin(item["name"], item["available"]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItemAdmin(String name, bool isAvailable) {
    return Opacity(
      opacity: isAvailable ? 1.0 : 0.5, 
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFEEE8AA),
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
                      Text(
                        isAvailable ? "Available" : "Empty",
                        style: TextStyle(fontSize: 12, color: isAvailable ? Colors.green : Colors.grey),
                      ),

                      
                      Switch(
                        value: isAvailable,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            
                            int index = menus.indexWhere((m) => m["name"] == name);
                            menus[index]["available"] = val;
                          });
                        },
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
