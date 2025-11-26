import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';


class TableData {
  final String number;
  final String capacity;
  final String status; 

  TableData(this.number, this.capacity, this.status);
}


class TableLayoutScreen extends StatefulWidget {
  const TableLayoutScreen({super.key});

  @override
  State<TableLayoutScreen> createState() => _TableLayoutScreenState();
}

class _TableLayoutScreenState extends State<TableLayoutScreen> {
  String activeFilter = "All";

  
  final List<TableData> tables = [
    TableData("01", "4 Kursi", "ready"),
    TableData("02", "4 Kursi", "booked"),
    TableData("03", "2 Kursi", "booked"),
    TableData("04", "2 Kursi", "ready"),
    TableData("05", "4 Kursi", "cleanup"),
    TableData("06", "4 Kursi", "booked"),
  ];

  
  List<TableData> get filteredTables {
    if (activeFilter == "All") return tables;
    return tables
        .where((t) => t.status == activeFilter.toLowerCase())
        .toList();
  }

  
  Color getStatusColor(String status) {
    switch (status) {
      case "ready":
        return AppColors.accentGreen;
      case "booked":
        return AppColors.accentRed;
      case "cleanup":
        return AppColors.accentOrange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFE6EABD),
      body: SafeArea(
        child: Column(
          children: [
            // NAV BAR FILTER
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFilterChip("All"),
                  _buildFilterChip("Ready"),
                  _buildFilterChip("Booked"),
                  _buildFilterChip("Clean Up"),
                ],
              ),
            ),

            // LAYOUT MEJA
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      // GUNAKAN FILTER HASIL
                      ..._buildTableWidgets(constraints),
                    ],
                  );
                },
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
        setState(() {
          activeFilter = label;
        });
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
    final tablesToShow = filteredTables;

    return [
      if (tablesToShow.any((t) => t.number == "03"))
        Positioned(
          top: 50,
          left: c.maxWidth / 2 - 40,
          child: _buildRoundTable(
            "03",
            "2 Kursi",
            getStatusColor("booked"),
          ),
        ),

      if (tablesToShow.any((t) => t.number == "04"))
        Positioned(
          top: 250,
          left: c.maxWidth / 2 - 40,
          child: _buildRoundTable(
            "04",
            "2 Kursi",
            getStatusColor("ready"),
          ),
        ),

      if (tablesToShow.any((t) => t.number == "06"))
        Positioned(
          top: 150,
          left: 40,
          child: _buildRectTable(
            "06",
            "4 Kursi",
            getStatusColor("booked"),
          ),
        ),

      if (tablesToShow.any((t) => t.number == "02"))
        Positioned(
          top: 380,
          left: 40,
          child: _buildRectTable(
            "02",
            "4 Kursi",
            getStatusColor("booked"),
          ),
        ),

      if (tablesToShow.any((t) => t.number == "05"))
        Positioned(
          top: 150,
          right: 40,
          child: _buildRectTable(
            "05",
            "4 Kursi",
            getStatusColor("cleanup"),
          ),
        ),

      if (tablesToShow.any((t) => t.number == "01"))
        Positioned(
          top: 380,
          right: 40,
          child: _buildRectTable(
            "01",
            "4 Kursi",
            getStatusColor("ready"),
          ),
        ),
    ];
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
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
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
              fontSize: 18,
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
