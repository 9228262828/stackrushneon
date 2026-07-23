class SoundService {
  const SoundService();

  Future<void> playTap({required bool enabled}) async {
    if (!enabled) return;
    // Add an audio package and asset later if sound files are provided.
  }

  Future<void> playPerfect({required bool enabled}) async {
    if (!enabled) return;
  }

  Future<void> playGameOver({required bool enabled}) async {
    if (!enabled) return;
  }
}
