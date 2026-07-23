import 'package:flutter/foundation.dart';

import '../models/app_settings.dart';
import '../services/storage_service.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({
    StorageService? storage,
  }) : _storage = storage ?? StorageService.instance {
    _settings = _storage.settings;
  }

  final StorageService _storage;
  late AppSettings _settings;

  AppSettings get settings => _settings;

  Future<void> setSound(bool value) async {
    _settings = _settings.copyWith(soundEnabled: value);
    notifyListeners();
    await _storage.saveSettings(_settings);
  }

  Future<void> setMusic(bool value) async {
    _settings = _settings.copyWith(musicEnabled: value);
    notifyListeners();
    await _storage.saveSettings(_settings);
  }

  Future<void> setHaptics(bool value) async {
    _settings = _settings.copyWith(hapticsEnabled: value);
    notifyListeners();
    await _storage.saveSettings(_settings);
  }

  Future<void> resetBestScore() async {
    await _storage.resetBestScore();
    notifyListeners();
  }
}
