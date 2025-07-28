import 'package:get/get.dart';
import 'package:projekx_app/modules/task_module/task_controller.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskController>(() => TaskController());
  }
}
