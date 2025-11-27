import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class ChefKitchenScreen extends StatefulWidget {
  const ChefKitchenScreen({super.key});

  @override
  State<ChefKitchenScreen> createState() => _ChefKitchenScreenState();
}

class _ChefKitchenScreenState extends State<ChefKitchenScreen> {
  
  List<Map<String, dynamic>> kitchenData = [
    {
      "title": "Meja 2",
      "time": "15:45 min",
      "items": ["2x Burger (No Onion)", "1x Soda"],
      "status": 0
    },
    {
      "title": "Meja 6",
      "time": "05:20 min",
      "items": ["2x Burger", "1x Soda"],
      "status": 0
    },
    {
      "title": "Meja 3",
      "time": "20:00 min",
      "items": ["2x Burger", "1x Soda"],
      "status": 2
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kitchen System"), backgroundColor: Colors.transparent),
      backgroundColor: const Color(0xFFE6EABD),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (var data in kitchenData)
            _kitchenCard(data),
        ],
      ),
    );
  }

  Widget _kitchenCard(Map<String, dynamic> data) {
    int status = data["status"];

    Color headerColor =
        status == 2 ? AppColors.primary : (status == 1 ? AppColors.accentRed : AppColors.primary.withOpacity(0.8));

    String timeText = status == 2 ? "Done" : data["time"];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data["title"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                  child: Text(timeText, style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

          
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...data["items"].map<Widget>((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e, style: const TextStyle(fontWeight: FontWeight.w500)),
                      const Text("Extra Ice", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                )),

                const SizedBox(height: 15),

                Row(
                  children: [
                    
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            data["status"] = 1; 
                          });
                        },
                        child: const Text("Cooking"),
                      ),
                    ),

                    const SizedBox(width: 10),

                    
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            data["status"] = 2;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Ready"),
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
