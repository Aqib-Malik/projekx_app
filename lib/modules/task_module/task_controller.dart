import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projekx_app/models/task.dart';
import 'package:projekx_app/services/task_service.dart';

class TaskController extends GetxController {
  RxList<TaskModel> tasks = <TaskModel>[].obs;
  RxList<TaskModel> myTasks = <TaskModel>[].obs;
  RxBool isLoading = false.obs;


  Rx<Color> newTaskColor = Colors.blue.obs;
  RxString newTaskStatus = 'New'.obs;
  Rx<DateTime?> newTaskDueDate = Rx<DateTime?>(null);


    Future<void> fetchMyTasks() async {
    try {
      isLoading.value = true;
      final fetchedTasks = await TaskService.fetchMyTasks();
      myTasks.assignAll(fetchedTasks);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }


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
      Get.snackbar(
        'Success',
        'Task added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.scaffoldBackgroundColor,
      );
    } catch (e) {
      print('Error adding task: $e');
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
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
      Get.snackbar(
        'Success',
        'Task updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.scaffoldBackgroundColor,
      );
    } catch (e) {
      print('Error updating task: $e');
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
