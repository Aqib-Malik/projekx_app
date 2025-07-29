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
  }) : descriptionController = TextEditingController(text: description),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    print(taskId);
    Rx<Color> selectedColor = Colors.orange.obs;
    Rx<DateTime?> selectedDueDate = dueDate.obs; // 🌟 store selected date

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
                  style: TextStyle(
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
                icon: Icon(LucideIcons.check, size: 16),
                label: Text("Complete"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // 🌟 Due date section
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
                        primary: AppColors.primary, // header color
                        onPrimary: Colors.white,    // header text
                        onSurface: Colors.black,    // body text
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary, // button text
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
            child: Obx(() => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.08),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(LucideIcons.calendar, size: 18, color: AppColors.primary),
                  SizedBox(width: 10),
                  Text(
                    selectedDueDate.value != null
                        ? DateFormat('dd MMM, yyyy').format(selectedDueDate.value!)
                        : "No date",
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.edit_calendar, color: AppColors.primary, size: 18),
                ],
              ),
            )),
          ),
          SizedBox(height: 20),

          // ... keep your description field etc below as you already had
          // (keeping same style)

          Text(
            "Description",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.08),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Enter description...",
                suffixIcon: IconButton(
                  icon: Icon(LucideIcons.send, color: AppColors.primary),
                  onPressed: () {
                    if (descriptionController.text.trim().isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Description cannot be empty",
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 14,
                ),
              ),
            ),
          ),
          // ... keep the rest unchanged
          SizedBox(height: 25),

          Text(
            "Add Comment",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.08),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write a comment...",
                suffixIcon: IconButton(
                  icon: Icon(LucideIcons.send, color: AppColors.primary),
                  onPressed: () {
                    if (commentController.text.trim().isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Comment cannot be empty",
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 14,
                ),
              ),
            ),
          ),
          SizedBox(height: 25),

          Row(
            children: [
              Text(
                "Task Color:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 12),
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
          SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(LucideIcons.trash, color: Colors.redAccent),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(LucideIcons.paperclip, color: Colors.grey[700]),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(LucideIcons.x, color: Colors.grey[700]),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
