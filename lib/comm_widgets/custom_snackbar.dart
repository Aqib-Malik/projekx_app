import 'package:flutter/material.dart';

enum SnackbarType { success, error }

void customTopSnackbar(
  BuildContext context,
  String title,
  String message,
  SnackbarType type,
) {
  final Color bgColor = type == SnackbarType.success
      ? const Color(0xFF4CAF50)
      : const Color(0xFFF44336);

  final IconData icon =
      type == SnackbarType.success ? Icons.check_circle : Icons.error;

  final snackBar = SnackBar(
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
    duration: const Duration(seconds: 3),
    content: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Future.delayed(Duration.zero, () {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  });
}
