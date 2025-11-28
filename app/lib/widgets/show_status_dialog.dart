import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';

Future<void> showStatusDialog({
  required BuildContext context,
  required Map<String, dynamic> table,
  required int tableNumber,
  required Function(String newStatus) onUpdate,
}) {
  final String currentStatus = table['status'];

  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(
          "Update Meja $tableNumber",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              statusButton(
                "AVAILABLE",
                currentStatus,
                onUpdate,
                Color(0xFF7EB936),
              ),
              const SizedBox(height: 10),
              statusButton(
                "BOOKED",
                currentStatus,
                onUpdate,
                Color(0xFF893942),
              ),
              const SizedBox(height: 10),
              statusButton(
                "CLEANING",
                currentStatus,
                onUpdate,
                Color(0xFFB9AE36),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget statusButton(
  String label,
  String currentStatus,
  Function(String) onUpdate,
  color,
) {
  return ElevatedButton(
    onPressed: (label == currentStatus) ? null : () => onUpdate(label),
    style: ElevatedButton.styleFrom(backgroundColor: color),
    child: Text(
      label,
      style: TextStyle(color: Color(0xFFF5F5F5), fontWeight: FontWeight.w600),
    ),
  );
}
