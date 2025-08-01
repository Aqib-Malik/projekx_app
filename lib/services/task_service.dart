import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projekx_app/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  static const String baseUrl = 'https://projekx.bubbleapps.io/api/1.1/obj/task';

  static Future<List<TaskModel>> fetchTasksByProject(String projectId) async {
    try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token') ?? '';
      final url = Uri.parse('$baseUrl?constraints=[{"key":"project_custom_project","constraint_type":"equals","value":"$projectId"}]');
      final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },);

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
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final userId = prefs.getString('user_id') ?? '';

    if (userId.isEmpty) {
      throw Exception('No user_id found in local storage');
    }

    final urlAssigned = Uri.parse(
      '$baseUrl?constraints=[{"key":"asigned_to_user","constraint_type":"equals","value":"$userId"}]'
    );

    final urlCreated = Uri.parse(
      '$baseUrl?constraints=[{"key":"Created By","constraint_type":"equals","value":"$userId"}]'
    );

    final responses = await Future.wait([
      http.get(urlAssigned, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }),
      http.get(urlCreated, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }),
    ]);

    List<TaskModel> tasks = [];

    for (var response in responses) {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['response']['results'];
        tasks.addAll(results.map((json) => TaskModel.fromJson(json)));
      } else {
        print('⚠ Failed to load some tasks: ${response.statusCode}');
      }
    }

    final uniqueTasks = { for (var task in tasks) task.id : task }.values.toList();

    return uniqueTasks;
  } catch (e) {
    throw Exception('Error fetching my tasks: $e');
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
    
      final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token') ?? '';
      final body = {
        "name_text": name,
        "project_custom_project": projectId,
        "taskstatus_option_taskstatus": status,
        // "Created By": user_id,
      };

      if (color != null) body["task_colour_text"] = color;
      // if (description != null) body["description"] = description;
      if (asigned_to_user != null) body["asigned_to_user"] = asigned_to_user;
      if (dueDate != null) body["duedate_date"] = dueDate.toUtc().toIso8601String();

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
        body: json.encode(body),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error creating task: $e');
    }
  }

 static Future<void> updateTask(String taskId, Map<String, dynamic> fieldsToUpdate) async {
  if (fieldsToUpdate.isEmpty) return;

  try {
    final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token') ?? '';
    final response = await http.patch(
      Uri.parse('$baseUrl/$taskId'),
      headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
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
