import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

class ChefKitchenScreen extends StatelessWidget {
  const ChefKitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kitchen System"), backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _kitchenCard("Meja 2", "15:45 min", ["2x Burger (No Onion)", "1x Soda"], true),
          _kitchenCard("Meja 6", "05:20 min", ["2x Burger", "1x Soda"], false),
          _kitchenCard("Meja 3", "Done", ["2x Burger", "1x Soda"], false, isDone: true),
        ],
      ),
    );
  }

  Widget _kitchenCard(String title, String time, List<String> items, bool isUrgent, {bool isDone = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200)
      ),
      child: Column(
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: isDone ? AppColors.primary : (isUrgent ? AppColors.accentRed : AppColors.primary.withOpacity(0.8)),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                  child: Text(time, style: const TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...items.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(e, style: const TextStyle(fontWeight: FontWeight.w500)), const Text("Extra Ice", style: TextStyle(fontSize: 10, color: Colors.grey))],
                  ),
                )),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: OutlinedButton(onPressed: (){}, child: const Text("Cooking"))),
                    const SizedBox(width: 10),
                    Expanded(child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), child: const Text("Ready"))),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}