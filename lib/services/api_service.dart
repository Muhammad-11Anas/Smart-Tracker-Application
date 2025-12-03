import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/activity.dart';

class ApiService {
  // TODO: replace with your actual API base URL
  static const String _baseUrl = 'https://your-api-url-here.com';
  static const String _activitiesPath = '/activities';

  static Uri _buildUri([String? extraPath]) {
    if (extraPath != null) {
      return Uri.parse('$_baseUrl$_activitiesPath$extraPath');
    }
    return Uri.parse('$_baseUrl$_activitiesPath');
  }

  /// GET /activities
  static Future<List<Activity>> fetchActivities() async {
    final response = await http.get(_buildUri());

    if (response.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(response.body);
      return decoded
          .map((item) => Activity.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load activities: ${response.statusCode}');
    }
  }

  /// POST /activities
  static Future<Activity> createActivity(Activity activity) async {
    final response = await http.post(
      _buildUri(),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(activity.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> decoded =
          jsonDecode(response.body) as Map<String, dynamic>;
      return Activity.fromJson(decoded);
    } else {
      throw Exception('Failed to create activity: ${response.statusCode}');
    }
  }

  /// DELETE /activities/{id}
  static Future<void> deleteActivity(String id) async {
    final response = await http.delete(_buildUri('/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete activity: ${response.statusCode}');
    }
  }
}
