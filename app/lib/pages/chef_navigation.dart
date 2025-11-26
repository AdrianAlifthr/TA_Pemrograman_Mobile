import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pages/chef_kitchen_screen.dart';
import 'package:flutter_application_1/pages/dashboard_page.dart';
import 'package:flutter_application_1/pages/menu_management_page.dart';
import 'package:flutter_application_1/pages/table_layout.dart';

class ChefNavigation extends StatefulWidget {
  const ChefNavigation({super.key});

  @override
  State<ChefNavigation> createState() => _ChefNavigationState();
}

class _ChefNavigationState extends State<ChefNavigation> {
  int _selectedIndex = 0;

  // Halaman untuk Chef: Dashboard, Meja, Kitchen System, Menu Management
  final List<Widget> _screens = [
    const DashboardScreen(role: "Chef"),
    const TableLayoutScreen(), // Shared
    const ChefKitchenScreen(), // Khusus Chef (Status Masak)
    const ChefMenuManagementScreen(), // Khusus Chef (Edit Stok)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        backgroundColor: AppColors.accentGreen, // Sedikit beda warna biar ketahuan bedanya
        indicatorColor: Colors.white24,
        height: 70,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home, color: Colors.white), 
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.table_restaurant, color: Colors.white), 
            label: 'Meja',
          ),
          NavigationDestination(
            icon: Icon(Icons.soup_kitchen, color: Colors.white), 
            label: 'Kitchen',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book, color: Colors.white), 
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}