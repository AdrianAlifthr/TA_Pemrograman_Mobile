import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final String role;
  const DashboardScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard $role"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Selamat Bekerja, Javier", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                _statCard("Meja Terisi", "12/20"),
                const SizedBox(width: 15),
                _statCard("Orderan Aktif", "7"),
              ],
            ),
            const SizedBox(height: 25),
            const Text("Order Masuk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _orderListTile("Meja 2", "2 Burger, 2 Soda", "Baru", Colors.red),
            _orderListTile("Meja 6", "1 Pasta", "Diproses", Colors.orange),
            _orderListTile("Meja 3", "Family Set", "Siap", Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String val) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(val, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _orderListTile(String meja, String menu, String status, Color color) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(meja, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(menu),
        trailing: Chip(
          label: Text(status, style: const TextStyle(color: Colors.white, fontSize: 12)),
          backgroundColor: color,
        ),
      ),
    );
  }
}
