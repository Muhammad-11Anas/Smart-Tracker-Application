import 'package:flutter/material.dart';

import '../models/activity.dart';

class ActivityProvider extends ChangeNotifier {
  final List<Activity> _activities = [];

  List<Activity> get activities => List.unmodifiable(_activities);

  void setActivities(List<Activity> items) {
    _activities
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  void addActivity(Activity activity) {
    _activities.insert(0, activity);
    notifyListeners();
  }

  void removeActivity(String id) {
    _activities.removeWhere((a) => a.id == id);
    notifyListeners();
  }
}
