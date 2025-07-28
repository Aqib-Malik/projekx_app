import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projekx_app/common/colors.dart';
import 'package:projekx_app/models/project_model.dart';
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
      // final controller = Get.put(ProjectController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Project Details",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Logo
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary.withOpacity(0.1),
               
                child:
                    Icon(Icons.work_outline,
                        color: AppColors.primary, size: 36)
                    ,
              ),
            ),
            const SizedBox(height: 16),

            /// Name
            Center(
              child: Text(
                project.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),

            /// Status
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            ),
            const SizedBox(height: 20),

            /// Description card
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Description",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.text)),
                    const SizedBox(height: 8),
                    Text(
                      project.description.isNotEmpty
                          ? project.description
                          : "No description available",
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// Votes
            Row(
              children: [
                Icon(Icons.how_to_vote, color: AppColors.primary, size: 18),
                const SizedBox(width: 6),
                Text("${project.votesQty} votes",
                    style: const TextStyle(fontSize: 14, color: AppColors.text)),
              ],
            ),
            const SizedBox(height: 16),

            /// Team members card
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: project.userIds.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Team Members",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: AppColors.text)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: project.userIds.map((user) {
                              return Chip(
                                label: Text(user, overflow: TextOverflow.ellipsis),
                                backgroundColor:
                                    AppColors.primary.withOpacity(0.08),
                                labelStyle: const TextStyle(
                                    fontSize: 11, color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    : const Text("No team members added",
                        style: TextStyle(
                            fontSize: 13, color: AppColors.textSecondary)),
              ),
            ),
            const SizedBox(height: 24),

            /// Actions row: Edit - Delete - Add Task
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Edit logic
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text("Edit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showDeleteDialog(context);
                    },
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.redAccent, size: 18),
                    label: const Text("Delete",
                        style: TextStyle(color: Colors.redAccent)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.redAccent),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            /// Add Task button
            ElevatedButton.icon(
              onPressed: () {
               Get.to(() => TaskListView(projectId: project.id), binding: TaskBinding());

              },
              icon: const Icon(Icons.add_task, size: 20),
              label: const Text("View Tasks"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.95),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.defaultDialog(
      title: "",
      content: Column(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Colors.redAccent, size: 50),
          const SizedBox(height: 12),
          const Text(
            "Delete Project",
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.text),
          ),
          const SizedBox(height: 8),
          const Text(
            "Are you sure you want to delete this project? This action cannot be undone.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
      radius: 8,
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
        onPressed: () {
          // Get.find()<ProjectController>().deleteProject(project.id);
           controller.deleteProject(project.id);
          Get.offAll(ProjectListView());
        },
        child: const Text("Delete"),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      ),
    );
  }
}
