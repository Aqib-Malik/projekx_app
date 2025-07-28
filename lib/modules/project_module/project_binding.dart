import 'package:get/get.dart';
import 'package:projekx_app/modules/project_module/project_controller.dart';

class ProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectController>(() => ProjectController());
  }
}
