import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_config.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/widgets/show_status_dialog.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  final String role;
  const DashboardScreen({super.key, required this.role});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

Color statusColor(String s) {
  switch (s.toUpperCase()) {
    case "COOKING":
      return Colors.red;
    case "WAITING":
      return Colors.orange;
    case "READY":
      return Colors.green;
    case "SERVED":
      return Colors.blue;
    default:
      return Colors.grey;
  }
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalTables = 0;
  int bookedTables = 0;
  int activeOrders = 0;
  List<Map<String, dynamic>> tables = [];
  List<Map<String, dynamic>> orderList = [];

  @override
  void initState() {
    super.initState();
    fetchTableStatus();
    fetchActiveOrders();
    fetchTables();
    fetchOrderList();
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
        debugPrint('API error: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('Fetch error: $e');
    }
  }

  Future<void> updateTableStatus(String tableId, String newStatus) async {
    final response = await http.post(
      Uri.parse(ApiConfig.updateTableStatus),
      body: {"table_id": tableId, "status": newStatus},
    );

    if (response.statusCode == 200) {
      debugPrint("Update berhasil");
      fetchTables();
      fetchTableStatus();
    } else {
      debugPrint("Gagal update");
    }
  }

  Future<void> fetchOrderList() async {
    final url = Uri.parse(ApiConfig.orderList);
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);

      if (body["success"] == true) {
        setState(() {
          orderList = List<Map<String, dynamic>>.from(body["orders"]);
        });
      }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Status Meja",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Color(0xFF893942),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text('Booked'),
                        ],
                      ),
                      SizedBox(width: 5),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Color(0xFFB9AE36),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text('Cleaning'),
                        ],
                      ),
                      SizedBox(width: 5),
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Color(0xFF7EB936),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(width: 5),
                          Text('Available'),
                        ],
                      ),
                    ],
                  ),
                ],
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
                itemCount: tables.length,
                itemBuilder: (context, index) {
                  final table = tables[index];
                  final status = table['status'];

                  String iconPath = "assets/images/meja-available.png";
                  if (status == "BOOKED") {
                    iconPath = "assets/images/meja-booked.png";
                  } else if (status == "CLEANING") {
                    iconPath = "assets/images/meja-cleaning.png";
                  }

                  return GestureDetector(
                    onTap: () {
                      showStatusDialog(
                        context: context,
                        table: tables[index],
                        tableNumber: index + 1,
                        onUpdate: (newStatus) {
                          updateTableStatus(
                            tables[index]['table_id'],
                            newStatus,
                          );
                          Navigator.pop(context);
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Image.asset(iconPath, width: 40),
                          SizedBox(width: 10),
                          Text(
                            "Meja ${index + 1}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
              Column(
                children: orderList.map((o) {
                  return _orderListTile(
                    "Meja ${o['table_number']}", // T_10 → Meja 10
                    o['menu_list'], // Beef x1, Pasta x2
                    o['order_status'], // cooking / waiting / ready
                    statusColor(o['order_status']),
                  );
                }).toList(),
              ),
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
