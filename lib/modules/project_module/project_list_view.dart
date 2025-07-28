import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projekx_app/common/colors.dart';
import 'package:projekx_app/modules/account_module/account_controler.dart';
import 'package:projekx_app/modules/account_module/account_screen.dart';
import 'package:projekx_app/modules/project_module/project_controller.dart';
import 'package:projekx_app/modules/project_module/project_detail_view.dart';
import 'package:shimmer/shimmer.dart';

class ProjectListView extends StatelessWidget {
  final controller = Get.put(ProjectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Projects",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          InkWell(
              onTap: () => Get.to(AccountView()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.account_circle_rounded,
                    color: Colors.white, size: 35),
              ))
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerList();
        }

        if (controller.projects.isEmpty) {
          return _buildEmptyState(context);
        }

        return _buildProjectList();
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProjectSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add,color: Colors.white,),
        label: const Text("Add Project", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Container(height: 100),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder_open, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 12),
          const Text("No projects found",
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _showAddProjectSheet(context),
            icon: const Icon(Icons.add),
            label: const Text("Add your first project"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          )
        ],
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
          child: Card(
            
            color: Colors.white,
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            shadowColor: AppColors.primary.withOpacity(0.07),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                 Get.to(ProjectDetailView(project: project));
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          
                          child:
                               const Icon(Icons.work_outline,
                                  color: AppColors.primary, size: 28)
                              
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(project.name,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.text)),
                              const SizedBox(height: 4),
                              Text(
                                project.description.isNotEmpty
                                    ? project.description
                                    : "No description",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
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
                        Icon(Icons.how_to_vote,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text('${project.votesQty} votes',
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.text)),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.redAccent),
                          onPressed: () => controller.deleteProject(project.id),
                        ),
                      ],
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
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text("Add New Project",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
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
              const Text("Select Team Members",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 8),
              Obx(() => accountController.myTeam.isEmpty
                  ? const Text("No team members available.",
                      style: TextStyle(color: Colors.grey))
                  : Column(
                      children: accountController.myTeam.map((member) {
                        return Obx(() => CheckboxListTile(
                              value: selectedTeamIds.contains(member.id),
                              title: Text(member.name),
                              subtitle: Text(member.email,
                                  style: const TextStyle(fontSize: 12)),
                              onChanged: (bool? selected) {
                                if (selected == true) {
                                  selectedTeamIds.add(member.id);
                                } else {
                                  selectedTeamIds.remove(member.id);
                                }
                              },
                            ));
                      }).toList(),
                    )),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Add Project"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (nameController.text.trim().isEmpty ||
                      descController.text.trim().isEmpty) {
                    Get.snackbar("Missing Info",
                        "Project name and description cannot be empty",
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM);
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
              )
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
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
}
