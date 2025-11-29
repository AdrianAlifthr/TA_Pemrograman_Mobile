import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/main.dart';

class TableData {
  final String number;
  final String capacity;
  final String status;

  TableData({
    required this.number,
    required this.capacity,
    required this.status,
  });

  factory TableData.fromJson(Map<String, dynamic> json) {
    return TableData(
      number: json['number'],
      capacity: json['capacity'],
      status: json['status'],
    );
  }
}

class TableLayoutScreen extends StatefulWidget {
  const TableLayoutScreen({super.key});

  @override
  State<TableLayoutScreen> createState() => _TableLayoutScreenState();
}

class _TableLayoutScreenState extends State<TableLayoutScreen> {
  String activeFilter = "All";
  List<TableData> tables = [];

  @override
  void initState() {
    super.initState();
    fetchTables();
  }

  Future<void> fetchTables() async {
    try {
      final res = await http.get(Uri.parse(ApiConfig.tablesView));
      final jsonData = json.decode(res.body);

      if (jsonData["success"] == true) {
        setState(() {
          tables = (jsonData["data"] as List)
              .map((e) => TableData.fromJson(e))
              .toList();
        });
      }
    } catch (e) {
      debugPrint("ERROR API: $e");
    }
  }

  List<TableData> get filteredTables {
    if (activeFilter == "All") return tables;
    return tables.where((t) => t.status == activeFilter.toLowerCase()).toList();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "available":
        return AppColors.accentGreen;
      case "booked":
        return AppColors.accentRed;
      case "cleaning":
        return AppColors.accentOrange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EABD),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFilterChip("All"),
                  _buildFilterChip("Available"),
                  _buildFilterChip("Booked"),
                  _buildFilterChip("Cleaning"),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: LayoutBuilder(
                  builder: (context, c) {
                    return SizedBox(
                      height: 800,
                      child: Stack(children: _buildTableWidgets(c)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isActive = activeFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() => activeFilter = label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.grey.shade400 : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.black : Colors.black54,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTableWidgets(BoxConstraints c) {
    final t = filteredTables;
    Widget? mejaStatus(String num, double top, double? left, {double? right}) {
      final table = t.where((x) => x.number == num).toList();
      if (table.isEmpty) return null;

      final data = table.first;
      final color = getStatusColor(data.status);

      return Positioned(
        top: top,
        left: left,
        right: right,
        child: num == "03" || num == "04"
            ? _buildRoundTable(num, data.capacity, color)
            : _buildRectTable(num, data.capacity, color),
      );
    }

    return [
      mejaStatus("03", 180, c.maxWidth / 2 - 40),
      mejaStatus("04", 510, c.maxWidth / 2 - 40),

      mejaStatus("06", 50, 40),
      mejaStatus("02", 300, 40),
      mejaStatus("07", 420, 40),
      mejaStatus("08", 630, 40),

      mejaStatus("05", 50, null, right: 40),
      mejaStatus("01", 300, null, right: 40),
      mejaStatus("09", 420, null, right: 40),
      mejaStatus("10", 630, null, right: 40),
    ].where((w) => w != null).map((e) => e!).toList();
  }

  Widget _buildRoundTable(String number, String capacity, Color color) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            capacity,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildRectTable(String number, String capacity, Color color) {
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            capacity,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
