class Activity {
  final String id;           // from API
  final double latitude;
  final double longitude;
  final String imageUrl;     // URL from API OR local path
  final DateTime timestamp;
  final String note;         // optional text by user

  Activity({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.timestamp,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'timestamp': timestamp.toIso8601String(),
      'note': note,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      note: json['note'] as String? ?? '',
    );
  }
}
