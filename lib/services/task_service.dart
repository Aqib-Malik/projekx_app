import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projekx_app/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  static const String baseUrl = 'https://projekx.bubbleapps.io/api/1.1/obj/task';

  static Future<List<TaskModel>> fetchTasksByProject(String projectId) async {
    try {
      final url = Uri.parse('$baseUrl?constraints=[{"key":"project_custom_project","constraint_type":"equals","value":"$projectId"}]');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['response']['results'];
        print(results);
        return results.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  

  static Future<List<TaskModel>> fetchMyTasks() async {
    final prefs = await SharedPreferences.getInstance();
  final user_id = prefs.getString('user_id') ?? '';
    try {
      final url = Uri.parse('$baseUrl?constraints=[{"key":"asigned_to_user","constraint_type":"equals","value":"$user_id"}]');
      final response = await http.get(url);
      print(response);
     

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['response']['results'];
        print(results);
        return results.map((json) => TaskModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
       print('Error fetching tasks: $e');
      throw Exception('Error fetching tasks: $e');
    }
  }

  
  static Future<void> createTask({
    required String name,
    required String projectId,
    String status = "New",
    String? color,
    DateTime? dueDate,
    String? asigned_to_user
  }) async {
    try {
      final body = {
        "name_text": name,
        "project_custom_project": projectId,
        "taskstatus_option_taskstatus": status,
      };

      if (color != null) body["task_colour_text"] = color;
      if (asigned_to_user != null) body["asigned_to_user"] = asigned_to_user;
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

 static Future<void> updateTask(String taskId, Map<String, dynamic> fieldsToUpdate) async {
  if (fieldsToUpdate.isEmpty) return;

  try {
    final response = await http.patch(
      Uri.parse('$baseUrl/$taskId'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(fieldsToUpdate),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update task: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error updating task: $e');
  }
}

}
