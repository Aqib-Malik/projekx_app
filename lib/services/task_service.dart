import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projekx_app/models/task.dart';

class TaskService {
  static const String baseUrl = 'https://projekx.bubbleapps.io/api/1.1/obj/task';

  /// Fetch tasks for a specific project
  static Future<List<TaskModel>> fetchTasksByProject(String projectId) async {
    try {
      final url = Uri.parse('$baseUrl?constraints=[{"key":"project_custom_project","constraint_type":"equals","value":"$projectId"}]');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['response']['results'];
        return results.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  /// Create a new task
  static Future<void> createTask({
    required String name,
    required String projectId,
    String status = "New",
    String? color,
    DateTime? dueDate,
  }) async {
    try {
      final body = {
        "name_text": name,
        "project_custom_project": projectId,
        "taskstatus_option_taskstatus": status,
      };

      if (color != null) body["task_colour_text"] = color;
      if (dueDate != null) body["duedate_date"] = dueDate.toUtc().toIso8601String();

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }
}
