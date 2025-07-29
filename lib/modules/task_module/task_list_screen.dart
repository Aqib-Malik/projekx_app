import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/bouncing_entrances/bounce_in.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:projekx_app/comm_widgets/custom_snackbar.dart';
import 'package:projekx_app/comm_widgets/empty_state_widget.dart';
import 'package:projekx_app/comm_widgets/show_teammember_dialog.dart';
import 'package:projekx_app/common/colors.dart';
import 'package:projekx_app/models/task.dart';
import 'package:projekx_app/modules/task_module/task_controller.dart';

class TaskListView extends StatefulWidget {
  final String projectId;
  final List<String> userIds;

  TaskListView({required this.projectId, Key? key, required this.userIds})
    : super(key: key);

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final TaskController controller = Get.find<TaskController>();

  Rx<Color> newTaskColor = AppColors.primary.obs;

  RxString newTaskStatus = 'New'.obs;

  Rx<DateTime?> newTaskDueDate = Rx<DateTime?>(null);

  RxString assignedUserId = ''.obs;

  @override
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.fetchTasksForProject(widget.projectId);
  });
}
  Widget build(BuildContext context) {
    

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            icon: const Icon(Icons.add, size: 20),
            label: const Text(
              "Add New Task",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              _showAddTaskSheet(context);
            },
          ),
        ),
      ),

      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.tasks.isEmpty) {
          return Center(child: buildEmptyState(context, "No tasks found"));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.tasks.length,
            itemBuilder: (context, index) {
              final task = controller.tasks[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: BounceIn(
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadowColor: AppColors.primary.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: task.color != null
                                      ? Color(_hexToColor(task.color!))
                                      : AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),

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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: task.status == "Completed"
                                            ? Colors.green.withOpacity(0.12)
                                            : task.status == "In progress"
                                            ? Colors.orange.withOpacity(0.12)
                                            : AppColors.primary.withOpacity(
                                                0.12,
                                              ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        task.status,
                                        style: TextStyle(
                                          fontSize: 12,
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

                          if (task.dueDate != null)
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
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

                          if (task.attachments.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_file,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${task.attachments.length} attachment${task.attachments.length > 1 ? 's' : ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 12),

                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                if (task.assignedToUser == null) {
                                  _showAssignUserDialog(context, task.id);
                                } else {
                                  showTeamMemberDialog(
                                    context,
                                    task.assignedToUser!,
                                  );
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                side: BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: Icon(
                                task.assignedToUser == null
                                    ? Icons.person_add_alt_1
                                    : Icons.visibility,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              label: Text(
                                task.assignedToUser == null
                                    ? "Assign User"
                                    : "View Assigned User",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }

  int _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return int.parse(hex, radix: 16);
  }

  void _showAddTaskSheet(BuildContext context) {
    final nameController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const Text(
                  "Create New Task",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Task Name *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    const Text('Pick Color:'),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () async {
                        Color? picked = await showDialog<Color>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Select Color'),
                            content: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  [
                                    Colors.red,
                                    Colors.green,
                                    Colors.blue,
                                    Colors.orange,
                                    Colors.purple,
                                    Colors.teal,
                                  ].map((color) {
                                    return GestureDetector(
                                      onTap: () =>
                                          Navigator.of(context).pop(color),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        );
                        if (picked != null) {
                          controller.newTaskColor.value = picked;
                        }
                      },
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: controller.newTaskColor.value,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.newTaskDueDate.value != null
                            ? "Due Date: ${controller.newTaskDueDate.value!.toLocal().toString().split(' ')[0]}"
                            : "No due date selected *",
                        style: TextStyle(
                          fontSize: 13,
                          color: controller.newTaskDueDate.value != null
                              ? Colors.black87
                              : Colors.redAccent,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),

                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppColors.primary,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black87,
                                ),
                                dialogBackgroundColor: Colors.white,
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
                        if (picked != null) {
                          controller.newTaskDueDate.value = picked;
                        }
                      },

                      icon: const Icon(Icons.date_range, size: 18),
                      label: const Text("Pick Date"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      if (nameController.text.trim().isEmpty) {
                        customTopSnackbar(
                          Get.context!,
                          "Error",
                          'Task name is required',
                          SnackbarType.error,
                        );
                        return;
                      }
                      if (controller.newTaskDueDate.value == null) {
                        customTopSnackbar(
                          Get.context!,
                          "Error",
                          'Please select a due date',
                          SnackbarType.error,
                        );

                        return;
                      }

                      await controller.addTask(
                        name: nameController.text.trim(),
                        projectId: widget.projectId,
                        status: controller.newTaskStatus.value,
                        color:
                            '#${controller.newTaskColor.value.value.toRadixString(16).substring(2)}',
                        dueDate: controller.newTaskDueDate.value,
                        asigned_to_user: assignedUserId.value.isNotEmpty
                            ? assignedUserId.value
                            : null,
                      );
                      Get.back();
                    },
                    child: const Text(
                      "Add Task",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showAssignUserDialog(BuildContext context, String taskId) {
    RxString selectedUserId = ''.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Text(
                "Assign Task to Team Member",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.userIds.length,
                itemBuilder: (context, index) {
                  final userId = widget.userIds[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: selectedUserId.value == userId
                          ? AppColors.primary.withOpacity(0.08)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selectedUserId.value == userId
                            ? AppColors.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      title: Text(
                        "Team Member ${index + 1}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        userId,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          showTeamMemberDialog(context, userId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "View",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      onTap: () {
                        selectedUserId.value = userId;
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedUserId.value.isEmpty
                      ? null
                      : () async {
                          await controller.updateTaskFields(
                            taskId: taskId,
                            projectId: widget.projectId,
                            fieldsToUpdate: {
                              "asigned_to_user": selectedUserId.value,
                            },
                          );

                          await controller.fetchTasksForProject(widget.projectId);
                          Get.back();

                          customTopSnackbar(
                            Get.context!,
                            "Success",
                            'User assigned successfully',
                            SnackbarType.success,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Assign',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
