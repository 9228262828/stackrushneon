import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  late SharedPreferences _prefs;

  static const _bestScoreKey = 'best_score';
  static const _soundKey = 'sound_enabled';
  static const _musicKey = 'music_enabled';
  static const _hapticsKey = 'haptics_enabled';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int get bestScore => _prefs.getInt(_bestScoreKey) ?? 0;

  Future<void> saveBestScore(int value) async {
    await _prefs.setInt(_bestScoreKey, value);
  }

  AppSettings get settings {
    return AppSettings(
      soundEnabled: _prefs.getBool(_soundKey) ?? true,
      musicEnabled: _prefs.getBool(_musicKey) ?? true,
      hapticsEnabled: _prefs.getBool(_hapticsKey) ?? true,
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    await Future.wait([
      _prefs.setBool(_soundKey, settings.soundEnabled),
      _prefs.setBool(_musicKey, settings.musicEnabled),
      _prefs.setBool(_hapticsKey, settings.hapticsEnabled),
    ]);
  }

  Future<void> resetBestScore() async {
    await _prefs.remove(_bestScoreKey);
  }
}
