import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_config.dart';
import 'package:flutter_application_1/widgets/show_status_dialog.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  final String role;
  const DashboardScreen({super.key, required this.role});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

bool get isWaiterGlobal => false;

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

  bool get isWaiter => widget.role.toLowerCase() == "waiter";

  @override
  void initState() {
    super.initState();
    fetchTableStatus();
    fetchActiveOrders();
    fetchTables();
    fetchOrderList();
  }

  // ================= API =================

  Future<void> fetchTableStatus() async {
    final res = await http.get(Uri.parse(ApiConfig.countTables));

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      setState(() {
        totalTables = json["total"];
        bookedTables = json["booked"];
      });
    }
  }

  Future<void> fetchActiveOrders() async {
    final res = await http.get(Uri.parse(ApiConfig.activeOrder));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        activeOrders = data["active_orders"];
      });
    }
  }

  Future<void> fetchTables() async {
    try {
      final res = await http.get(Uri.parse(ApiConfig.tablesStatus));

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);

        if (json['success'] == true) {
          setState(() {
            tables = List<Map<String, dynamic>>.from(json['tables']);
          });
        }
      }
    } catch (e) {
      debugPrint("Fetch tables error: $e");
    }
  }

  Future<void> updateTableStatus(String tableId, String newStatus) async {
    if (!isWaiter) return; // lock non waiter

    final res = await http.post(
      Uri.parse(ApiConfig.updateTableStatus),
      body: {"table_id": tableId, "status": newStatus},
    );

    if (res.statusCode == 200) {
      fetchTables();
      fetchTableStatus();
    }
  }

  Future<void> fetchOrderList() async {
    final res = await http.get(Uri.parse(ApiConfig.orderList));

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);

      if (body["success"] == true) {
        setState(() {
          orderList = List<Map<String, dynamic>>.from(body["orders"]);
          sortOrders();
        });
      }
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    if (!isWaiter) return; // lock non waiter

    final res = await http.post(
      Uri.parse(ApiConfig.updateOrderStatus),
      body: {"order_id": orderId, "status": newStatus},
    );

    if (res.statusCode == 200) {
      await fetchOrderList();
    }
  }

  // ================= SORT =================

  void sortOrders() {
    const priority = {"READY": 0, "COOKING": 1, "WAITING": 2, "SERVED": 3};

    orderList.sort((a, b) {
      final sa = priority[a['order_status'].toString().toUpperCase()] ?? 99;
      final sb = priority[b['order_status'].toString().toUpperCase()] ?? 99;
      return sa.compareTo(sb);
    });
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EABD),
      appBar: AppBar(
        title: Text("Dashboard ${widget.role}"),
        backgroundColor: const Color(0xFFE6EABD),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            color: Colors.red,
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await fetchTableStatus();
          await fetchActiveOrders();
          await fetchTables();
          await fetchOrderList();
        },

        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              "Selamat Bekerja, ${widget.role}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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

            // ========= TABLE STATUS ==========
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Status Meja",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    _legend(const Color(0xFF893942), "Booked"),
                    _legend(const Color(0xFFB9AE36), "Cleaning"),
                    _legend(const Color(0xFF7EB936), "Available"),
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
              itemBuilder: (_, i) {
                final t = tables[i];
                final status = t['status'];

                String iconPath = "assets/images/meja-available.png";
                if (status == "BOOKED") {
                  iconPath = "assets/images/meja-booked.png";
                } else if (status == "CLEANING") {
                  iconPath = "assets/images/meja-cleaning.png";
                }

                return GestureDetector(
                  onTap: isWaiter
                      ? () {
                          showStatusDialog(
                            context: context,
                            table: t,
                            tableNumber: i + 1,
                            onUpdate: (newStatus) {
                              updateTableStatus(t['table_id'], newStatus);
                              Navigator.pop(context);
                            },
                          );
                        }
                      : null,

                  child: Opacity(
                    opacity: isWaiter ? 1 : 1,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Image.asset(iconPath, width: 40),
                          const SizedBox(width: 10),
                          Text(
                            "Meja ${i + 1}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            // ================= ORDER LIST ==================
            const Text(
              "Order Masuk",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Column(
              children: orderList.map((o) {
                final isReady =
                    o['order_status'].toString().toUpperCase() == "READY";

                return _orderListTile(
                  "Meja ${o['table_number']}",
                  o['menu_list'],
                  o['order_status'],
                  statusColor(o['order_status']),
                  isReady: isReady && isWaiter,
                  onServe: () {
                    updateOrderStatus(o['order_id'], "SERVED");
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ================= COMPONENT =================

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

  Widget _orderListTile(
    String meja,
    String menu,
    String status,
    Color color, {
    bool isReady = false,
    VoidCallback? onServe,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            title: Text(
              meja,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(menu),
            trailing: Chip(
              label: Text(
                status.toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: color,
            ),
          ),

          if (isReady)
            InkWell(
              onTap: onServe,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: const [
                    Text(
                      "Sajikan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.check_circle, color: Colors.green),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _legend(Color c, String t) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 5),
        Text(t),
        const SizedBox(width: 10),
      ],
    );
  }
}
