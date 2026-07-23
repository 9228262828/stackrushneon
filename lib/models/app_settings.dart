class AppSettings {
  const AppSettings({
    required this.soundEnabled,
    required this.musicEnabled,
    required this.hapticsEnabled,
  });

  final bool soundEnabled;
  final bool musicEnabled;
  final bool hapticsEnabled;

  AppSettings copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    bool? hapticsEnabled,
  }) {
    return AppSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }

  static const defaults = AppSettings(
    soundEnabled: true,
    musicEnabled: true,
    hapticsEnabled: true,
  );
}
