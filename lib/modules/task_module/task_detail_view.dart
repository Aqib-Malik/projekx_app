import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:projekx_app/common/colors.dart';
import 'package:projekx_app/modules/task_module/task_controller.dart';

class TaskDetailsView extends StatelessWidget {
  final String taskId;
  final String projectId;
  final String taskTitle;
  final String assignee;
  final DateTime dueDate;
  final String description;

  final TextEditingController descriptionController;
  final TextEditingController commentController = TextEditingController();

  final TaskController controller = Get.find<TaskController>();

  TaskDetailsView({
    required this.taskId,
    required this.projectId,
    required this.taskTitle,
    required this.assignee,
    required this.dueDate,
    required this.description,
    Key? key,
  })  : descriptionController = TextEditingController(text: description),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Rx<Color> selectedColor = Colors.orange.obs;
    Rx<DateTime?> selectedDueDate = dueDate.obs;

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      appBar: AppBar(
        title: const Text(
          "Task Details",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  taskTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  controller.updateTaskFields(
                    taskId: taskId,
                    projectId: projectId,
                    fieldsToUpdate: {"taskstatus_option_taskstatus": "Completed"},
                  );
                },
                icon: const Icon(LucideIcons.check, size: 16),
                label: const Text("Complete"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDueDate.value ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.primary,
                        onPrimary: Colors.white,
                        onSurface: Colors.black,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null && picked != selectedDueDate.value) {
                selectedDueDate.value = picked;
                controller.updateTaskFields(
                  taskId: taskId,
                  projectId: projectId,
                  fieldsToUpdate: {
                    "duedate_date": picked.toIso8601String(),
                  },
                );
              }
            },
            child: Obx(() => _infoTile(
              icon: LucideIcons.calendar,
              text: selectedDueDate.value != null
                  ? DateFormat('dd MMM, yyyy').format(selectedDueDate.value!)
                  : "No date",
              trailingIcon: Icons.edit_calendar,
            )),
          ),
          const SizedBox(height: 20),

          const Text(
            "Description",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          _editableTextField(
            controller: descriptionController,
            hint: "Enter description...",
            icon: LucideIcons.send,
            onSubmit: () {
              if (descriptionController.text.trim().isEmpty) {
                _showError("Description cannot be empty");
              } else {
                controller.updateTaskFields(
                  taskId: taskId,
                  projectId: projectId,
                  fieldsToUpdate: {
                    "description_text": descriptionController.text.trim(),
                  },
                );
              }
            },
          ),

          const SizedBox(height: 25),
          const Text(
            "Add Comment",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          _editableTextField(
            controller: commentController,
            hint: "Write a comment...",
            icon: LucideIcons.send,
            onSubmit: () {
              if (commentController.text.trim().isEmpty) {
                _showError("Comment cannot be empty");
              } else {
                Get.snackbar(
                  "Success",
                  "Comment added",
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
                commentController.clear();
              }
            },
          ),
          const SizedBox(height: 25),

          Row(
            children: [
              const Text(
                "Task Color:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12),
              Obx(
                () => GestureDetector(
                  onTap: () {
                    selectedColor.value = selectedColor.value == Colors.orange
                        ? Colors.purple
                        : Colors.orange;
                    controller.updateTaskFields(
                      taskId: taskId,
                      projectId: projectId,
                      fieldsToUpdate: {
                        "color": selectedColor.value.value.toRadixString(16),
                      },
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: selectedColor.value,
                    radius: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(LucideIcons.trash, color: Colors.redAccent),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(LucideIcons.paperclip, color: Colors.grey[700]),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(LucideIcons.x, color: Colors.grey[700]),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoTile({required IconData icon, required String text, IconData? trailingIcon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          if (trailingIcon != null)
            Icon(trailingIcon, color: AppColors.primary, size: 18),
        ],
      ),
    );
  }

  Widget _editableTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required VoidCallback onSubmit,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: IconButton(
            icon: Icon(icon, color: AppColors.primary),
            onPressed: onSubmit,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 14,
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
