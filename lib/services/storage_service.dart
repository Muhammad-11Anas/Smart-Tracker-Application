import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/activity.dart';

class StorageService {
  static const String _keyRecentActivities = 'recent_activities';

  /// Save last 5 activities as JSON in SharedPreferences
  static Future<void> saveRecentActivities(List<Activity> activities) async {
    final prefs = await SharedPreferences.getInstance();

    // keep only first 5
    final List<Activity> limited = activities.take(5).toList();

    final jsonList = limited.map((a) => a.toJson()).toList();
    final jsonString = jsonEncode(jsonList);

    await prefs.setString(_keyRecentActivities, jsonString);
  }

  /// Load cached activities (if any)
  static Future<List<Activity>> loadRecentActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyRecentActivities);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded
          .map((item) => Activity.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> clearRecentActivities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRecentActivities);
  }
}
