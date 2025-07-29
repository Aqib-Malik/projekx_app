import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projekx_app/comm_widgets/custom_snackbar.dart';
import 'package:projekx_app/models/task.dart';
import 'package:projekx_app/services/task_service.dart';

class TaskController extends GetxController {
  RxList<TaskModel> tasks = <TaskModel>[].obs; 
  RxList<TaskModel> myTasks = <TaskModel>[].obs; 
  RxBool isLoading = false.obs;

  Rx<Color> newTaskColor = Colors.blue.obs;
  RxString newTaskStatus = 'New'.obs;
  Rx<DateTime?> newTaskDueDate = Rx<DateTime?>(null);

  
  Future<void> fetchTasksForProject(String projectId) async {
    try {
      isLoading.value = true;
      final fetchedTasks = await TaskService.fetchTasksByProject(projectId);
      tasks.assignAll(fetchedTasks);
    } catch (e) {
      customTopSnackbar(
        Get.context!,
        "Error",
        e.toString(),
        SnackbarType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> fetchTasksAssignedOrCreatedByMe() async {
    try {
      isLoading.value = true;
      final fetchedMyTasks = await TaskService.fetchMyTasks();
      myTasks.assignAll(fetchedMyTasks);
      
    } catch (e) {
      print('Error fetching my tasks: $e');
      customTopSnackbar(
        Get.context!,
        "Error",
        e.toString(),
        SnackbarType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> addTask({
    required String name,
    required String projectId,
    String status = "New",
    String? color,
    DateTime? dueDate,
    String? asigned_to_user,
  }) async {
    try {
      isLoading.value = true;
      await TaskService.createTask(
        name: name,
        projectId: projectId,
        status: status,
        color: color,
        dueDate: dueDate,
        asigned_to_user: asigned_to_user,
      );
      await fetchTasksForProject(projectId);

      customTopSnackbar(
        Get.context!,
        "Success",
        'Task added successfully',
        SnackbarType.success,
      );
    } catch (e) {
      print('Error adding task: $e');
      customTopSnackbar(
        Get.context!,
        "Error",
        e.toString(),
        SnackbarType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> updateTaskFields({
    required String taskId,
    required Map<String, dynamic> fieldsToUpdate,
    required String projectId,
  }) async {
    if (fieldsToUpdate.isEmpty) return;
    try {
      isLoading.value = true;
      await TaskService.updateTask(taskId, fieldsToUpdate);
      await fetchTasksForProject(projectId);

      customTopSnackbar(
        Get.context!,
        "Success",
        'Task updated successfully',
        SnackbarType.success,
      );
    } catch (e) {
      print('Error updating task: $e');
      customTopSnackbar(
        Get.context!,
        "Error",
        e.toString(),
        SnackbarType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
