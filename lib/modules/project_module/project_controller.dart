import 'package:get/get.dart';
import 'package:projekx_app/comm_widgets/custom_snackbar.dart';
import 'package:projekx_app/models/project_model.dart';
import 'package:projekx_app/modules/account_module/account_controler.dart';
import 'package:projekx_app/modules/project_module/project_list_view.dart';
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
      customTopSnackbar(
        Get.context!,
        'Error',
        "Failed to load projects",
        SnackbarType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProject({
    required String name,
    required String description,
    required String logoUrl,
    String status = "Active",
    List<String> teamIds = const [],
  }) async {
    isLoading.value = true;
    try {
      final success = await ProjectService.addProject(
        name: name,
        description: description,
        logoUrl: logoUrl,
        status: status,
        teamIds: teamIds,
      );

      if (success) {
        customTopSnackbar(
          Get.context!,
          'Success',
          "Project added successfully",
          SnackbarType.success,
        );
        await fetchProjects();
      } else {
        customTopSnackbar(
          Get.context!,
          'Error',
          "Failed to add project",
          SnackbarType.error,
        );
      }
    } catch (e) {
      print("Add project error: $e");

      customTopSnackbar(
        Get.context!,
        'Error',
        "Something went wrong",
        SnackbarType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProject({
    required String projId,
    required Map<String, dynamic> fieldsToUpdate,
  }) async {
    if (fieldsToUpdate.isEmpty) return;
    try {
      isLoading.value = true;
      await ProjectService.updateProject(projId, fieldsToUpdate);
      print('*************');
      customTopSnackbar(
          Get.context!,
          'Success',
          "Project added successfully",
          SnackbarType.success,
        );
        await fetchProjects();
        Get.offAll(ProjectListView());
      // c
      // await fetchProjects();
      
    } catch (e) {
      print('Error updating project: $e');

      // customTopSnackbar(
      //   Get.context!,
      //   'Error',
      //   e.toString(),
      //   SnackbarType.error,
      // );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProject(String projectId) async {
    isLoading.value = true;
    try {
      final success = await ProjectService.deleteProject(projectId);

      if (success) {
        customTopSnackbar(
          Get.context!,
          'Success',
          "Project deleted successfully",
          SnackbarType.success,
        );
        await fetchProjects();
      } else {
        customTopSnackbar(
          Get.context!,
          'Error',
          "Failed to delete project",
          SnackbarType.error,
        );
      }
    } catch (e) {
      print("Delete project error: $e");

      customTopSnackbar(
        Get.context!,
        'Error',
        "Something went wrong",
        SnackbarType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
