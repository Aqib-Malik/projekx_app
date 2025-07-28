import 'package:get/get.dart';
import 'package:projekx_app/models/project_model.dart';
import 'package:projekx_app/modules/account_module/account_controler.dart';
import 'package:projekx_app/services/project_service.dart';

class ProjectController extends GetxController {
  AccountController authController = Get.put(AccountController());
  var projects = <ProjectModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProjects(); 
  }

  Future<void> fetchProjects() async {
    isLoading.value = true;
    try {
      projects.value = await ProjectService.fetchProjects();
      authController.total_projec.value = projects.length.toString();

    } catch (e) {
      print("Error fetching projects: $e");
      Get.snackbar("Error", "Failed to load projects");
    } finally {
      isLoading.value = false;
    }
  }

 Future<void> addProject({
  required String name,
  required String description,
  required String logoUrl,
  String status = "Active",
  List<String> teamIds = const [], // ✅ new field
}) async {
  isLoading.value = true;
  try {
    final success = await ProjectService.addProject(
      name: name,
      description: description,
      logoUrl: logoUrl,
      status: status,
      teamIds: teamIds, // ✅ pass to service
    );

    if (success) {
      Get.snackbar("Success", "Project added successfully");
      await fetchProjects();
    } else {
      Get.snackbar("Error", "Failed to add project");
    }
  } catch (e) {
    print("Add project error: $e");
    Get.snackbar("Error", "Something went wrong");
  } finally {
    isLoading.value = false;
  }
}



  Future<void> deleteProject(String projectId) async {
  isLoading.value = true;
  try {
    final success = await ProjectService.deleteProject(projectId);

    if (success) {
      Get.snackbar("Success", "Project deleted successfully");
      await fetchProjects();
    } else {
      Get.snackbar("Error", "Failed to delete project");
    }
  } catch (e) {
    print("Delete project error: $e");
    Get.snackbar("Error", "Something went wrong");
  } finally {
    isLoading.value = false;
  }
}

  
}
