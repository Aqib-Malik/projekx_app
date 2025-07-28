// api_service.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://projekx.bubbleapps.io/api/1.1/wf';

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) {
    print('$baseUrl$endpoint');
    final url = Uri.parse('$baseUrl$endpoint');
    return http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }
}
