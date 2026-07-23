import 'package:flutter/material.dart';

import 'app.dart';
import 'services/haptic_service.dart';
import 'services/sound_service.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.init();
  await SoundService.instance.initialize();

  final settings = StorageService.instance.settings;
  await SoundService.instance.setSoundEnabled(settings.soundEnabled);
  await SoundService.instance.setMusicEnabled(settings.musicEnabled);
  HapticService.instance.setEnabled(settings.hapticsEnabled);

  runApp(const StackRushNeonApp());
}
