import 'package:flutter/services.dart';

class HapticService {
  HapticService._();

  static final HapticService instance = HapticService._();

  bool _enabled = true;

  void setEnabled(bool value) {
    _enabled = value;
  }

  Future<void> lightImpact() async {
    if (!_enabled) return;
    await _safeHaptic(HapticFeedback.lightImpact);
  }

  Future<void> mediumImpact() async {
    if (!_enabled) return;
    await _safeHaptic(HapticFeedback.mediumImpact);
  }

  Future<void> heavyImpact() async {
    if (!_enabled) return;
    await _safeHaptic(HapticFeedback.heavyImpact);
  }

  Future<void> selectionClick() async {
    if (!_enabled) return;
    await _safeHaptic(HapticFeedback.selectionClick);
  }

  Future<void> _safeHaptic(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      // Haptics are best-effort feedback and should never interrupt the app.
    }
  }
}
