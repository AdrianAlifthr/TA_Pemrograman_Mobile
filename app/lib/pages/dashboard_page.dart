import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_config.dart';
import 'package:flutter_application_1/main.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  final String role;
  const DashboardScreen({super.key, required this.role});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalTables = 0;
  int bookedTables = 0;
  int activeOrders = 0;
  List<Map<String, dynamic>> tables = [];

  @override
  void initState() {
    super.initState();
    fetchTableStatus();
    fetchActiveOrders();
    fetchTables();
  }

  Future<void> fetchTableStatus() async {
    final url = Uri.parse(ApiConfig.countTables);
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      setState(() {
        totalTables = json["total"];
        bookedTables = json["booked"];
      });
    }
  }

  Future<void> fetchActiveOrders() async {
    final url = Uri.parse(ApiConfig.activeOrder);
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        activeOrders = data["active_orders"];
      });
    }
  }

  Future<void> fetchTables() async {
    try {
      final url = Uri.parse(ApiConfig.tablesStatus);
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final jsonBody = jsonDecode(res.body);
        if (jsonBody['success'] == true) {
          setState(() {
            tables = List<Map<String, dynamic>>.from(jsonBody['tables']);
          });
        }
      } else {
        // error handling ringan
        debugPrint('API error: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('Fetch error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard ${widget.role}"),
        backgroundColor: Color(0xFFE6EABD),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFE6EABD)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat Bekerja, ${widget.role}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _statCard("Meja Terisi", "$bookedTables/$totalTables"),
                  const SizedBox(width: 15),
                  _statCard("Orderan Aktif", "$activeOrders"),
                ],
              ),
              const SizedBox(height: 25),
              const Text(
                "Status Meja",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: tables.length, // gunakan jumlah dari API
                itemBuilder: (context, index) {
                  // data meja dari API
                  final table = tables[index];
                  final status =
                      table['status']; // pastikan huruf sama seperti API
                  final tableId = table['table_id'];

                  // pilih icon status
                  String iconPath = "assets/images/meja-hijau.png";
                  if (status == "BOOKED") {
                    iconPath = "assets/images/meja-merah.png";
                  } else if (status == "CLEANING") {
                    iconPath = "assets/images/meja-kuning.png";
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardWhite,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(iconPath, width: 40),
                        const SizedBox(width: 20),
                        Text(
                          "Meja $tableId",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),
              const Text(
                "Order Masuk",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _orderListTile("Meja 2", "2 Burger, 2 Soda", "Baru", Colors.red),
              _orderListTile("Meja 6", "1 Pasta", "Diproses", Colors.orange),
              _orderListTile("Meja 3", "Family Set", "Siap", Colors.green),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String val) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(
              val,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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
          label: Text(
            status,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          backgroundColor: color,
        ),
      ),
    );
  }
}
