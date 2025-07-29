import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project_model.dart';
// https://projekx.bubbleapps.io/api/1.1/obj/project?constraints=[{"key":"Created By","constraint_type":"equals","value":"1753544673170x505399949150664000"}]
class ProjectService {

  static Future<List<ProjectModel>> fetchProjects() async {
    print("Fetching projects...");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final userId = prefs.getString('user_id') ?? '';

    if (token.isEmpty || userId.isEmpty) {
      throw Exception("No auth token or user ID found.");
    }

    final url =
        // 'https://projekx.bubbleapps.io/api/1.1/obj/project';
        'https://projekx.bubbleapps.io/api/1.1/obj/project?constraints=[{"key":"Created By","constraint_type":"equals","value":"$userId"}]';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final results = jsonData['response']['results'] as List;
      return results.map((e) => ProjectModel.fromJson(e)).toList();
    } else {
      print("Fetch Error: ${response.body}");
      throw Exception("Failed to load projects");
    }
  }

static Future<bool> addProject({
  required String name,
  required String description,
  required String logoUrl,
  String status = "Active",
  List<String> teamIds = const [],
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token') ?? '';
  final userId = prefs.getString('user_id') ?? '';

  if (token.isEmpty || userId.isEmpty) {
    throw Exception("Missing token or user ID");
  }

  final body = jsonEncode({
    "name_text": name,
    "description_text": description,
    "logo_image": logoUrl,
    "status_option_status": status,
    "users_list_user": teamIds, // ✅ add selected team members
    // "Created By": userId,      // ✅ make sure you set the creator
  });

  final response = await http.post(
    Uri.parse('https://projekx.bubbleapps.io/api/1.1/obj/project'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: body,
  );

  print("Add Project Response: ${response.body}");

  final resBody = jsonDecode(response.body);
  return resBody['status'] == 'success' || resBody['id'] != null;
}


  static Future<bool> deleteProject(String projectId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token') ?? '';

  if (token.isEmpty) {
    throw Exception("Missing token");
  }

  final url =
      'https://projekx.bubbleapps.io/api/1.1/obj/project/$projectId';

  final response = await http.delete(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  print("Delete status code: ${response.statusCode}");
  print("Delete response: ${response.body}");

  return response.statusCode == 204;
}


 static Future<void> updateProject(String projId, Map<String, dynamic> fieldsToUpdate) async {
  if (fieldsToUpdate.isEmpty) return;

  try {
    print(fieldsToUpdate);
    final response = await http.patch(
      Uri.parse('https://projekx.bubbleapps.io/api/1.1/obj/project/$projId'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(fieldsToUpdate),
    );
    print(response.statusCode);
    if (response.statusCode != 204) {
      throw Exception('Failed to update project: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error updating project: $e');
  }
}

}
