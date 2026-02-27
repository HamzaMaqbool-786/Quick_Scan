import 'package:vibration/vibration.dart';

abstract class HapticService {
  static Future<void> scanSuccess() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      Vibration.vibrate(duration: 80, amplitude: 128);
    }
  }

  static Future<void> light() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      Vibration.vibrate(duration: 30, amplitude: 64);
    }
  }

  static Future<void> error() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (hasVibrator) {
      Vibration.vibrate(pattern: [0, 50, 80, 50], amplitude: 128);
    }
  }
}
