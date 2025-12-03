import 'package:camera/camera.dart';

class CameraService {
  /// Opens the first available camera, takes one picture,
  /// then closes the camera and returns the file.
  static Future<XFile?> takePicture() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        return null;
      }

      final firstCamera = cameras.first;

      final controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();

      final file = await controller.takePicture();

      await controller.dispose();
      return file;
    } catch (e) {
      // In real app you might log this
      return null;
    }
  }
}
