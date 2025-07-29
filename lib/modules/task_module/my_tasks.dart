import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projekx_app/modules/task_module/task_card.dart' show TaskCard;
import 'package:projekx_app/modules/task_module/task_controller.dart';
import 'package:projekx_app/common/colors.dart';
import 'package:projekx_app/modules/task_module/task_detail_view.dart';

class MyTasksView extends StatelessWidget {
  final TaskController controller = Get.put(TaskController());

  MyTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchTasksAssignedOrCreatedByMe();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar:AppBar(
        title: const Text(
          "My Tasks",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 2,
        centerTitle: true,
      
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.myTasks.isEmpty) {
          return const Center(child: Text("No tasks found."));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          itemCount: controller.myTasks.length,
          itemBuilder: (_, index) {
            final task = controller.myTasks[index];
            return TaskCard(
              task: task,
              onTap: () {
    Get.to(() => TaskDetailsView(
      taskTitle: task.name ?? 'Untitled Task',
      assignee: task.assignedToUser ?? 'Unassigned',
      dueDate: task.dueDate ?? DateTime.now(),
      description: task.description ?? '',
      taskId: task.id,
      projectId: task.projectId,
    ));
  },
              onEdit: () {},
              onDelete: () {},
            );
          },
        );
      }),
    );
  }
}
