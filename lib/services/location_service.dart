import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> _ensurePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled.
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  static Future<Position?> getCurrentPosition() async {
    bool ok = await _ensurePermission();
    if (!ok) {
      return null;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      return null;
    }
  }
}
