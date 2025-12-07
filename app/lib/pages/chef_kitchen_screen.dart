import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/api_config.dart';
import 'package:http/http.dart' as http;

class ChefKitchenScreen extends StatefulWidget {
  const ChefKitchenScreen({super.key});

  @override
  State<ChefKitchenScreen> createState() => _ChefKitchenScreenState();
}

class _ChefKitchenScreenState extends State<ChefKitchenScreen> {
  List kitchenData = [];

  // ✅ FILTER STATE
  String selectedFilter = "standby"; // standby | ready

  @override
  void initState() {
    super.initState();
    fetchKitchen();
  }

  Future fetchKitchen() async {
    try {
      final res = await http.get(Uri.parse(ApiConfig.kitchenTaks));
      final json = jsonDecode(res.body);

      if (json["success"] == true) {
        setState(() {
          kitchenData = json["data"];
        });
      }
    } catch (e) {
      debugPrint("Fetch kitchen error: $e");
    }
  }

  Future updateStatus(String taskNumber, String status) async {
    try {
      await http.post(
        Uri.parse(ApiConfig.updateKitchen),
        body: {"task_number": taskNumber, "status": status},
      );

      await fetchKitchen();
    } catch (e) {
      debugPrint("Update status failed: $e");
    }
  }

  // ✅ FILTER LOGIC
  List get filteredData {
    if (selectedFilter == "ready") {
      return kitchenData
          .where((e) => e["kitchen_status"].toString().toLowerCase() == "ready")
          .toList();
    }

    // standby: waiting + cooking
    return kitchenData.where((e) {
      final s = e["kitchen_status"].toString().toLowerCase();
      return s == "waiting" || s == "cooking";
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EABD),
      appBar: AppBar(
        title: const Text("Kitchen Tasks"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: kitchenData.isEmpty
          ? const Center(child: Text("Belum ada pesanan"))
          : Column(
              children: [
                // ================= FILTER CHIP =================
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilterChip(
                        label: const Text("Standby"),
                        selected: selectedFilter == "standby",
                        onSelected: (_) {
                          setState(() {
                            selectedFilter = "standby";
                          });
                        },
                        selectedColor: AppColors.primary.withOpacity(0.2),
                      ),

                      const SizedBox(width: 12),

                      FilterChip(
                        label: const Text("Ready"),
                        selected: selectedFilter == "ready",
                        onSelected: (_) {
                          setState(() {
                            selectedFilter = "ready";
                          });
                        },
                        selectedColor: Colors.green.withOpacity(0.2),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ================= LIST =================
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      for (var data in filteredData) _kitchenCard(data),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // ================= CARD =================
  Widget _kitchenCard(Map data) {
    // ✅ meja fix
    String meja = (data["table_id"] ?? "T_?").toString().replaceAll("T_", "");

    String status = (data["kitchen_status"] ?? "waiting").toString();

    String taskNumber = data["task_number"]?.toString() ?? "";

    // ✅ item fix
    List<String> items = [];
    if (data["items"] != null) {
      items = data["items"].toString().split(", ");
    }

    // ✅ warna header
    Color headerColor = status == "ready"
        ? Colors.green
        : status == "cooking"
        ? Colors.red
        : AppColors.accentOrange;

    // ✅ waktu/status text
    String timeText = "";
    if (status == "waiting") {
      timeText = data["order_created_date"]?.toString() ?? "-";
    } else if (status == "cooking") {
      timeText = "Start: ${data["started_at"] ?? "-"}";
    } else {
      timeText = "DONE";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // ================= HEADER =================
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Meja $meja",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(timeText, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),

          // ================= BODY =================
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...items.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(e, style: const TextStyle(fontSize: 14)),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                if (status != "ready")
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: status == "waiting"
                              ? () => updateStatus(taskNumber, "cooking")
                              : null,
                          child: const Text("Cooking"),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          onPressed: status == "cooking"
                              ? () => updateStatus(taskNumber, "ready")
                              : null,
                          child: const Text(
                            "Ready",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
