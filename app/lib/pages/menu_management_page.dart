import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/main.dart';

class MenuItemModel {
  final String id;
  final String name;
  final String category;
  final int price;
  bool available;
  final String image;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.available,
    required this.image,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['menu_id'],
      name: json['menu_name'],
      category: json['category_id'],
      price: json['price'],
      available: json['available'].toString() == "1",
      image: json['path'],
    );
  }
}

class ChefMenuManagementScreen extends StatefulWidget {
  const ChefMenuManagementScreen({super.key});

  @override
  State<ChefMenuManagementScreen> createState() =>
      _ChefMenuManagementScreenState();
}

class _ChefMenuManagementScreenState extends State<ChefMenuManagementScreen> {
  TextEditingController searchController = TextEditingController();

  String activeCategory = "All";

  List<MenuItemModel> menus = [];

  @override
  void initState() {
    super.initState();
    fetchMenus();
  }

  // ================= FETCH MENU ====================
  Future<void> fetchMenus({String search = ""}) async {
    try {
      String url =
          "${ApiConfig.menuList}?category=${activeCategory == "All" ? "" : activeCategory}&search=$search";

      final res = await http.get(Uri.parse(url));

      debugPrint("API => $url");
      debugPrint("RESP => ${res.body}");

      final data = json.decode(res.body);

      if (data["success"] == true) {
        setState(() {
          menus = (data["data"] as List)
              .map((e) => MenuItemModel.fromJson(e))
              .toList();
        });
      }
    } catch (e) {
      debugPrint("API ERROR => $e");
    }
  }

  // ================= UPDATE MENU ====================
  Future<void> updateMenuAvailability(MenuItemModel menu, bool val) async {
    menu.available = val;
    setState(() {});

    try {
      await http.post(
        Uri.parse(ApiConfig.menuUpdate),
        body: {"menu_id": menu.id, "available": val ? "1" : "0"},
      );
    } catch (e) {
      debugPrint("UPDATE ERROR => $e");
    }
  }

  // ================= UI =============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Management"),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFFE6EABD),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: "Search menu...",
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        fetchMenus(search: val);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // FILTER CATEGORY
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip("All"),
                _filterChip("MainCourse"),
                _filterChip("Dessert"),
                _filterChip("Drinks"),
                _filterChip("Appetizer"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // GRID MENU
          Expanded(
            child: menus.isEmpty
                ? const Center(child: Text("Menu kosong"))
                : GridView.builder(
                    padding: const EdgeInsets.all(15),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: menus.length,
                    itemBuilder: (context, i) {
                      return _menuCard(menus[i]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String cat) {
    bool active = activeCategory == cat;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ChoiceChip(
        label: Text(cat),
        selected: active,
        selectedColor: AppColors.primary,
        onSelected: (_) {
          setState(() {
            activeCategory = cat;
          });
          fetchMenus(search: searchController.text);
        },
      ),
    );
  }

  // ================= CARD MENU ======================
  Widget _menuCard(MenuItemModel menu) {
    return Opacity(
      opacity: menu.available ? 1 : 0.5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.network(
                  menu.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),
            ),

            // INFO
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menu.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(menu.category, style: const TextStyle(fontSize: 11)),
                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        menu.available ? "Available" : "Not Available",
                        style: TextStyle(
                          color: menu.available
                              ? Colors.green
                              : Colors.redAccent,
                        ),
                      ),

                      Switch(
                        value: menu.available,
                        activeColor: AppColors.primary,
                        onChanged: (val) => updateMenuAvailability(menu, val),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
