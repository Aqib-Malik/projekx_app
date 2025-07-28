import 'package:flutter/material.dart';
import 'package:projekx_app/models/task.dart';
import 'package:projekx_app/common/colors.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Task Details",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  task.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 8),

                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: task.status == "Completed"
                        ? Colors.green.withOpacity(0.12)
                        : task.status == "In progress"
                            ? Colors.orange.withOpacity(0.12)
                            : AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    task.status,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: task.status == "Completed"
                          ? Colors.green
                          : task.status == "In progress"
                              ? Colors.orange
                              : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Due date
                if (task.dueDate != null)
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}',
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                // Assigned to
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      task.assignedToUser ?? 'Unassigned',
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Attachments
                if (task.attachments.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Attachments",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...task.attachments.map((a) => Text(
                            "- $a",
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          )),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
