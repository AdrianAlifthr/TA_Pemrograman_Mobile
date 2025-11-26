import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pages/dashboard_page.dart';
import 'package:flutter_application_1/pages/table_layout.dart';
import 'package:flutter_application_1/pages/waiter_order_screen.dart';

class WaiterNavigation extends StatefulWidget {
  const WaiterNavigation({super.key});

  @override
  State<WaiterNavigation> createState() => _WaiterNavigationState();
}

class _WaiterNavigationState extends State<WaiterNavigation> {
  int _selectedIndex = 0;

  // Halaman untuk Waiters: Dashboard, Meja, Order Menu
  final List<Widget> _screens = [
    const DashboardScreen(role: "Waiter"),
    const TableLayoutScreen(),
    const WaiterOrderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        backgroundColor: AppColors.primary,
        indicatorColor: Colors.white24,

        height: 80,

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
            icon: Icon(Icons.receipt_long, color: Colors.white),
            label: 'Order',
          ),
        ],
      ),
    );
  }
}
