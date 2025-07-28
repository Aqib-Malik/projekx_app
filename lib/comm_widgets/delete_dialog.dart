import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projekx_app/common/colors.dart';

void showDeleteDialog(
  BuildContext context,
  String title,
  String description, {
  required VoidCallback onConfirm,
}) {
  Get.defaultDialog(
    title: "",
    radius: 10,
    content: Column(
      children: [
        const Icon(
          Icons.warning_amber_rounded,
          color: Colors.redAccent,
          size: 50,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    ),
    confirm: ElevatedButton.icon(
      icon: const Icon(Icons.delete_outline, size: 18),
      label: const Text("Delete"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {
        Get.back(); // close the dialog
        onConfirm(); // run the callback
      },
    ),
    cancel: TextButton(
      onPressed: () => Get.back(),
      child: const Text("Cancel"),
    ),
  );
}
