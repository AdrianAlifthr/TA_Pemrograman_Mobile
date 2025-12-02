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

  @override
  void initState() {
    super.initState();
    fetchKitchen();
  }

  Future fetchKitchen() async {
    final res = await http.get(Uri.parse(ApiConfig.kitchenTaks));
    final json = jsonDecode(res.body);

    if (json["success"]) {
      setState(() {
        kitchenData = json["data"];
      });
    }
  }

  Future updateStatus(String task, String status) async {
    await http.post(
      Uri.parse(ApiConfig.updateKitchen),
      body: {"task_number": task, "status": status},
    );

    fetchKitchen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kitchen Tasks"),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFFE6EABD),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [for (var data in kitchenData) _kitchenCard(data)],
      ),
    );
  }

  Widget _kitchenCard(Map data) {
    String meja = (data["TABLE_ID"] ?? "T_?").toString().replaceAll("T_", "");

    String status = data['KITCHEN_STATUS'];

    List items = data["ITEMS"].split(", ");

    Color headerColor = status == 'ready'
        ? Colors.green
        : status == 'cooking'
        ? Colors.orange
        : AppColors.primary;

    String timeText = "IN";

    if (status == 'waiting') {
      timeText = data["ORDER_CREATED_DATE"];
    } else if (status == 'cooking') {
      timeText = "Start: ${data["STARTED_AT"]}";
    } else if (status == 'ready') {
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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

          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                ...items.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(e)],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                if (status != 'ready')
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: status == "waiting"
                              ? () => updateStatus(
                                  data["TASK_NUMBER"].toString(),
                                  "cooking",
                                )
                              : null,
                          child: const Text("Cooking"),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: status == "cooking"
                              ? () => updateStatus(
                                  data["TASK_NUMBER"].toString(),
                                  "ready",
                                )
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
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
