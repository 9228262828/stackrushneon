import 'package:flutter/foundation.dart';

import '../models/app_settings.dart';
import '../services/haptic_service.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({
    StorageService? storage,
    SoundService? sound,
    HapticService? haptics,
  }) : _storage = storage ?? StorageService.instance {
    _sound = sound ?? SoundService.instance;
    _haptics = haptics ?? HapticService.instance;
    _settings = _storage.settings;
  }

  final StorageService _storage;
  late final SoundService _sound;
  late final HapticService _haptics;
  late AppSettings _settings;

  AppSettings get settings => _settings;

  Future<void> setSound(bool value) async {
    _settings = _settings.copyWith(soundEnabled: value);
    await _sound.setSoundEnabled(value);
    notifyListeners();
    await _storage.saveSettings(_settings);
  }

  Future<void> setMusic(bool value) async {
    _settings = _settings.copyWith(musicEnabled: value);
    await _sound.setMusicEnabled(value);
    notifyListeners();
    await _storage.saveSettings(_settings);
  }

  Future<void> setHaptics(bool value) async {
    _settings = _settings.copyWith(hapticsEnabled: value);
    _haptics.setEnabled(value);
    notifyListeners();
    await _storage.saveSettings(_settings);
  }

  Future<void> resetBestScore() async {
    await _storage.resetBestScore();
    notifyListeners();
  }
}
