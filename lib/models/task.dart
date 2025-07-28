class TaskModel {
  final String id;
  final String name;
  final String status;
  final String projectId;
  final String? color;
  final DateTime? dueDate;
  final List<String> attachments;

  TaskModel({
    required this.id,
    required this.name,
    required this.status,
    required this.projectId,
    this.color,
    this.dueDate,
    this.attachments = const [],
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json["_id"] ?? "",
      name: json["name_text"] ?? "",
      status: json["taskstatus_option_taskstatus"] ?? "Unknown",
      projectId: json["project_custom_project"] ?? "",
      color: json["task_colour_text"],
      dueDate: json["duedate_date"] != null
          ? DateTime.tryParse(json["duedate_date"])
          : null,
      attachments: json["attachment_list_custom_attachment"] != null
          ? List<String>.from(json["attachment_list_custom_attachment"])
          : [],
    );
  }
}
