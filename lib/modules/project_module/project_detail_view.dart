import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:projekx_app/comm_widgets/delete_dialog.dart';
import 'package:projekx_app/comm_widgets/show_teammember_dialog.dart';
import 'package:projekx_app/common/colors.dart';
import 'package:projekx_app/models/project_model.dart';
import 'package:projekx_app/modules/account_module/account_controler.dart';
import 'package:projekx_app/modules/project_module/project_controller.dart';
import 'package:projekx_app/modules/project_module/project_list_view.dart';
import 'package:projekx_app/modules/task_module/task_binding.dart';
import 'package:projekx_app/modules/task_module/task_list_screen.dart';

class ProjectDetailView extends StatelessWidget {
  final controller = Get.put(ProjectController());
  final ProjectModel project;

  ProjectDetailView({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Project Details",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Logo & project name
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Icon(
                Icons.work_outline,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              project.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
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
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: project.status == "Active"
                          ? AppColors.primary
                          : AppColors.error,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.how_to_vote, color: AppColors.primary, size: 18),
                const SizedBox(width: 6),
                Text(
                  "${project.votesQty} votes",
                  style: const TextStyle(fontSize: 14, color: AppColors.text),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Description card
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project.description.isNotEmpty
                        ? project.description
                        : "No description available",
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Team members card
            _buildCard(
              child: project.userIds.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Team Members",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: project.userIds.asMap().entries.map((
                            entry,
                          ) {
                            int index = entry.key;
                            String userId = entry.value;

                            return ActionChip(
                              label: Text(
                                "View Member #${index + 1}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                ),
                              ),
                              backgroundColor: AppColors.primary.withOpacity(
                                0.08,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onPressed: () {
                                showTeamMemberDialog(context, userId);
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  : InkWell(
                      onTap: () {
                        // open bottom sheet to add/select team members
                        _showAddMembersSheet(context, project.id);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
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
                            SizedBox(width: 6),
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

            const SizedBox(height: 24),

            /// Actions row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Edit logic
                    },
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text("Mark Complete"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => showDeleteDialog(
                      context,
                      "Delete Project",
                      "Are you sure you want to delete this project? This action cannot be undone.",
                      onConfirm: () {
                        controller.deleteProject(project.id);
                        Get.offAll(ProjectListView());
                      },
                    ),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                    label: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// View Tasks button
            ElevatedButton.icon(
              onPressed: () {
                Get.to(
                  () => TaskListView(
                    projectId: project.id,
                    userIds: project.userIds,
                  ),
                  binding: TaskBinding(),
                );
              },
              icon: const Icon(Icons.view_list, size: 20),
              label: const Text("View Tasks"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper to build cards with consistent width & design
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
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
                  Get.snackbar(
                    "Select members",
                    "Please select at least one member",
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }

                // Close bottom sheet first
                Get.back();

                await controller.updateProject(
                  projId: projectId,
                  fieldsToUpdate: {
                    "users_list_user": selectedUserIds.toList(),
                  },
                );

                // Navigate back to previous page
                Get.offAllNamed('projects');
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
