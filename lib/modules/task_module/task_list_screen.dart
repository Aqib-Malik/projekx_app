// views/task_list_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projekx_app/common/colors.dart';
import 'package:projekx_app/models/task.dart';
import 'package:projekx_app/modules/task_module/task_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


class TaskListView extends StatelessWidget {

  final String projectId;
  final TaskController controller = Get.find<TaskController>();
  Rx<Color> newTaskColor = AppColors.primary.obs;
RxString newTaskStatus = 'New'.obs;
Rx<DateTime?> newTaskDueDate = Rx<DateTime?>(null);


  TaskListView({required this.projectId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch when screen loads
    controller.fetchTasksForProject(projectId);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
  onPressed: () {
    _showAddTaskSheet(context);
  },
  backgroundColor: AppColors.primary,
  icon: const Icon(Icons.add, color: Colors.white),
  label: const Text("Add New Task", style: TextStyle(color: Colors.white)),
),

      appBar: AppBar(
        title: Text('Tasks',style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.tasks.isEmpty) {
          return Center(child: Text('No tasks found.'));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) {
              final task = controller.tasks[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal:  13.0),
                child: Card(
                  color: Colors.white,
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: AppColors.primary.withOpacity(0.08),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Top row: Task name + status badge
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Colored circle
                            Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: task.color != null
                      ? Color(_hexToColor(task.color!))
                      : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                            ),
                            const SizedBox(width: 10),
                            // Task name & status
                            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: task.status == "Completed"
                            ? Colors.green.withOpacity(0.12)
                            : task.status == "In progress"
                                ? Colors.orange.withOpacity(0.12)
                                : AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        task.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: task.status == "Completed"
                              ? Colors.green
                              : task.status == "In progress"
                                  ? Colors.orange
                                  : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                            ),
                          ],
                        ),
                
                        const SizedBox(height: 12),
                
                        /// Bottom row: Due date if exists
                        if (task.dueDate != null)
                          Row(
                            children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  'Due: ${task.dueDate!.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              )
;
            },
          );
        }
      }),
    );
  }

  /// Convert hex color string to int
  int _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return int.parse(hex, radix: 16);
  }



void _showAddTaskSheet(BuildContext context) {
  final nameController = TextEditingController();
  final TaskController controller = Get.find<TaskController>();

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Obx(() => Wrap(
        runSpacing: 12,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const Text("Add New Task",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Task Name'),
          ),
          DropdownButtonFormField<String>(
            value: controller.newTaskStatus.value,
            decoration: const InputDecoration(labelText: 'Status'),
            items: ['New', 'In progress', 'Completed']
                .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                .toList(),
            onChanged: (value) {
              if (value != null) controller.newTaskStatus.value = value;
            },
          ),
          Row(
            children: [
              const Text('Pick Color:'),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () async {
                  Color tempColor = controller.newTaskColor.value;
                  Color? picked = await showDialog<Color>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Select Color'),
                      content: BlockPicker(
                        pickerColor: tempColor,
                        onColorChanged: (c) => tempColor = c,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, tempColor),
                          child: const Text('Select'),
                        )
                      ],
                    ),
                  );
                  if (picked != null) controller.newTaskColor.value = picked;
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: controller.newTaskColor.value,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  controller.newTaskDueDate.value != null
                      ? "Due Date: ${controller.newTaskDueDate.value!.toLocal().toString().split(' ')[0]}"
                      : "No due date selected",
                  style: const TextStyle(fontSize: 13),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) controller.newTaskDueDate.value = picked;
                },
                child: const Text("Pick Date"),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  Get.snackbar('Error', 'Task name required', snackPosition: SnackPosition.BOTTOM);
                  return;
                }

                await controller.addTask(
                  name: nameController.text.trim(),
                  projectId: projectId,
                  status: controller.newTaskStatus.value,
                  color: '#${controller.newTaskColor.value.value.toRadixString(16).substring(2)}',
                  dueDate: controller.newTaskDueDate.value,
                );
                await controller.fetchTasksForProject(projectId);
                Get.back(); // close bottom sheet
              },
              child: const Text("Add Task"),
            ),
          ),
        ],
      )),
    ),
    isScrollControlled: true,
  );
}


}
