import 'package:flutter/material.dart';

class TableLayoutScreen extends StatelessWidget {
  const TableLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Denah Meja"), backgroundColor: Colors.transparent),
      body: Center(
        child: Stack(
          children: [
            // Simulasi layout meja (posisi absolute sederhana)
            Positioned(top: 50, left: 100, child: _roundTable("03", Colors.red)),
            Positioned(top: 200, left: 100, child: _roundTable("04", Colors.green)),
            Positioned(top: 100, left: 20, child: _rectTable("06", Colors.red)),
            Positioned(top: 100, right: 20, child: _rectTable("05", Colors.orange)),
          ],
        ),
      ),
    );
  }

  Widget _roundTable(String no, Color color) {
    return CircleAvatar(radius: 40, backgroundColor: color, child: Text(no, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));
  }

  Widget _rectTable(String no, Color color) {
    return Container(width: 80, height: 60, color: color, alignment: Alignment.center, child: Text(no, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));
  }
}