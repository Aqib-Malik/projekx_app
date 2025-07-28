import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projekx_app/models/task.dart';
import 'package:projekx_app/services/task_service.dart';

class TaskController extends GetxController {
  RxList<TaskModel> tasks = <TaskModel>[].obs;
  RxBool isLoading = false.obs;

  /// NEW: Reactive fields for add task form
  Rx<Color> newTaskColor = Colors.blue.obs; // default color
  RxString newTaskStatus = 'New'.obs;
  Rx<DateTime?> newTaskDueDate = Rx<DateTime?>(null);

  /// Fetch tasks filtered by project ID
  Future<void> fetchTasksForProject(String projectId) async {
    try {
      isLoading.value = true;
      final fetchedTasks = await TaskService.fetchTasksByProject(projectId);
      tasks.assignAll(fetchedTasks);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Add new task
  Future<void> addTask({
    required String name,
    required String projectId,
    String status = "New",
    String? color,
    DateTime? dueDate,
  }) async {
    try {
      isLoading.value = true;
      await TaskService.createTask(
        name: name,
        projectId: projectId,
        status: status,
        color: color,
        dueDate: dueDate,
      );
      await fetchTasksForProject(projectId); // refresh list
      Get.snackbar('Success', 'Task added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Get.theme.scaffoldBackgroundColor);
    } catch (e) {
      print('Error adding task: $e');
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
