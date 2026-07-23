import 'package:flutter/services.dart';

class HapticService {
  const HapticService();

  Future<void> light(bool enabled) async {
    if (!enabled) return;
    await HapticFeedback.lightImpact();
  }

  Future<void> medium(bool enabled) async {
    if (!enabled) return;
    await HapticFeedback.mediumImpact();
  }

  Future<void> error(bool enabled) async {
    if (!enabled) return;
    await HapticFeedback.heavyImpact();
  }
}
