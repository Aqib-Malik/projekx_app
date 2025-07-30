import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:projekx_app/comm_widgets/custom_snackbar.dart';
import 'package:projekx_app/comm_widgets/delete_dialog.dart';
import 'package:projekx_app/comm_widgets/empty_state_widget.dart';
import 'package:projekx_app/common/colors.dart';
import 'package:projekx_app/modules/account_module/account_controler.dart';
import 'package:projekx_app/modules/account_module/account_screen.dart';
import 'package:projekx_app/modules/project_module/project_controller.dart';
import 'package:projekx_app/modules/project_module/project_detail_view.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:lottie/lottie.dart';

class ProjectListView extends StatelessWidget {
  final controller = Get.put(ProjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "My Projects",
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {

                showDeleteDialog(context, 'logout', 'Are you sure you want to logout?', onConfirm: (){
                  Get.find<AccountController>().logout();
                });
                
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.logOut,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerList();
        }

        if (controller.projects.isEmpty) {
          return buildEmptyState(context, "No projects found");
        }

        return _buildProjectList();
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProjectSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Project", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (_, __) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Container(height: 100),
      ),
    );
  }

  Widget _buildProjectList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      itemCount: controller.projects.length,
      itemBuilder: (context, index) {
        final project = controller.projects[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: BounceIn(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BounceIn(
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: AppColors.primary.withOpacity(0.08),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Get.to(ProjectDetailView(project: project));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: AppColors.primary
                                        .withOpacity(0.1),
                                    child: const Icon(
                                      LucideIcons.folderKanban,
                                      color: AppColors.primary,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          project.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.text,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          project.description.isNotEmpty
                                              ? project.description
                                              : "No description",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: project.status == "Active"
                                          ? AppColors.primary.withOpacity(0.12)
                                          : AppColors.error.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      project.status,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: project.status == "Active"
                                            ? AppColors.primary
                                            : AppColors.error,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primary,
                                          AppColors.primary.withOpacity(0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "ID: ${project.id.substring(0, 6)}",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (project.votesQty > 5)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        "Top Voted",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  const Icon(
                                    LucideIcons.vote,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${project.votesQty} votes',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.text,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      LucideIcons.trash2,
                                      size: 18,
                                      color: Colors.redAccent,
                                    ),
                                    tooltip: 'Delete',
                                    onPressed: () => showDeleteDialog(
                                      context,
                                      "Delete Project",
                                      "Are you sure you want to delete this project? This action cannot be undone.",
                                      onConfirm: () {
                                        controller.deleteProject(project.id);
                                        Get.offAll(ProjectListView());
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              if (project.userIds == null ||
                                  project.userIds.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: GestureDetector(
                                    onTap: () => _showAddMembersSheet(
                                      context,
                                      project.id,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(
                                          0.07,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            LucideIcons.userPlus,
                                            size: 16,
                                            color: AppColors.primary,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "Add Team Members",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddProjectSheet(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final AccountController accountController = Get.find<AccountController>();
    RxSet<String> selectedTeamIds = <String>{}.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF7F7F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Add New Project",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(nameController, "Project Name"),
              const SizedBox(height: 12),
              _buildTextField(descController, "Description", maxLines: 3),
              const SizedBox(height: 16),
              const Text(
                "Select Team Members",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Obx(
                () => accountController.myTeam.isEmpty
                    ? const Text(
                        "No team members available.",
                        style: TextStyle(color: Colors.grey),
                      )
                    : Column(
                        children: accountController.myTeam.map((member) {
                          return Obx(
                            () => CheckboxListTile(
                              value: selectedTeamIds.contains(member.id),
                              title: Text(member.name),
                              subtitle: Text(
                                member.email,
                                style: const TextStyle(fontSize: 12),
                              ),
                              onChanged: (bool? selected) {
                                if (selected == true) {
                                  selectedTeamIds.add(member.id);
                                } else {
                                  selectedTeamIds.remove(member.id);
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Add Project"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (nameController.text.trim().isEmpty ||
                      descController.text.trim().isEmpty) {
                    customTopSnackbar(
                      Get.context!,
                      "Missing Info",
                      "Project name and description cannot be empty",
                      SnackbarType.error,
                    );
                    return;
                  }

                  Get.back();
                  await controller.addProject(
                    name: nameController.text.trim(),
                    description: descController.text.trim(),
                    logoUrl: "",
                    teamIds: selectedTeamIds.toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showAddMembersSheet(BuildContext context, String projectId) {
    final AccountController accountController = Get.find<AccountController>();
    RxSet<String> selectedUserIds = <String>{}.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                "Add Team Members",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              accountController.myTeam.isEmpty
                  ? const Text(
                      "No team members available.",
                      style: TextStyle(color: Colors.grey),
                    )
                  : Column(
                      children: accountController.myTeam.map((member) {
                        return CheckboxListTile(
                          value: selectedUserIds.contains(member.id),
                          title: Text(member.name),
                          subtitle: Text(
                            member.email,
                            style: const TextStyle(fontSize: 12),
                          ),
                          onChanged: (bool? selected) {
                            if (selected == true) {
                              selectedUserIds.add(member.id);
                            } else {
                              selectedUserIds.remove(member.id);
                            }
                          },
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  if (selectedUserIds.isEmpty) {
                    customTopSnackbar(
                      Get.context!,
                      "Select members",
                      "Please select at least one member",
                      SnackbarType.error,
                    );
                    return;
                  }
                  Get.back();
                  await controller.updateProject(
                    projId: projectId,
                    fieldsToUpdate: {
                      "users_list_user": selectedUserIds.toList(),
                    },
                  );
                },
                icon: const Icon(LucideIcons.userPlus, size: 16),
                label: const Text("Add Selected Members"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      isScrollControlled: true,
    );
  }
}
