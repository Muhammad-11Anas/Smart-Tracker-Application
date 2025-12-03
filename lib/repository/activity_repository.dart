import '../models/activity.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ActivityRepository {
  /// Load from API, but also store last 5 offline
  Future<List<Activity>> loadActivities() async {
    final activities = await ApiService.fetchActivities();
    await StorageService.saveRecentActivities(activities);
    return activities;
  }

  /// Load from offline cache only
  Future<List<Activity>> loadCachedActivities() {
    return StorageService.loadRecentActivities();
  }

  /// Create activity on server + update cache
  Future<Activity> createActivity(Activity activity) async {
    final created = await ApiService.createActivity(activity);

    // This should be called where you have the full list
    // For now repository just returns the created item.
    return created;
  }

  Future<void> deleteActivity(String id) {
    return ApiService.deleteActivity(id);
  }
}
