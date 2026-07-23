import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();

  static const _tapAsset = 'audio/tap.wav';
  static const _buttonAsset = 'audio/button.wav';
  static const _perfectAsset = 'audio/perfect.wav';
  static const _gameOverAsset = 'audio/game_over.wav';
  static const _backgroundMusicAsset = 'audio/background_music.wav';

  static const _effectPlayerCount = 4;

  final AudioPlayer _musicPlayer = AudioPlayer();
  final List<AudioPlayer> _effectPlayers = List.generate(
    _effectPlayerCount,
    (_) => AudioPlayer(),
  );
  final Map<String, bool> _assetAvailable = HashMap();

  int _nextEffectPlayer = 0;
  bool _initialized = false;
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _musicRequested = false;
  bool _musicPaused = false;
  bool _musicStarted = false;

  Future<void> initialize() async {
    if (_initialized) return;

    _initialized = true;

    await _safeCall(() async {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    });

    for (final player in _effectPlayers) {
      await _safeCall(() async {
        await player.setPlayerMode(PlayerMode.lowLatency);
        await player.setReleaseMode(ReleaseMode.stop);
      });
    }

    await Future.wait([
      _cacheAssetAvailability(_tapAsset),
      _cacheAssetAvailability(_buttonAsset),
      _cacheAssetAvailability(_perfectAsset),
      _cacheAssetAvailability(_gameOverAsset),
      _cacheAssetAvailability(_backgroundMusicAsset),
    ]);
  }

  Future<void> playTap() => _playEffect(_tapAsset);

  Future<void> playButton() => _playEffect(_buttonAsset);

  Future<void> playPerfect() => _playEffect(_perfectAsset);

  Future<void> playGameOver() => _playEffect(_gameOverAsset);

  Future<void> startMusic() async {
    _musicRequested = true;
    _musicPaused = false;
    _musicStarted = false;
    await _playMusic(restart: true);
  }

  Future<void> pauseMusic() async {
    if (!_musicRequested) return;
    _musicPaused = true;

    await _safeCall(() async {
      await _musicPlayer.pause();
    });
  }

  Future<void> resumeMusic() async {
    if (!_musicRequested) return;
    _musicPaused = false;
    await _playMusic();
  }

  Future<void> stopMusic() async {
    _musicRequested = false;
    _musicPaused = false;
    _musicStarted = false;

    await _safeCall(() async {
      await _musicPlayer.stop();
    });
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
  }

  Future<void> setMusicEnabled(bool value) async {
    if (_musicEnabled == value) return;

    _musicEnabled = value;

    if (!_musicEnabled) {
      await _safeCall(() async {
        await _musicPlayer.pause();
      });
      return;
    }

    if (_musicRequested && !_musicPaused) {
      await _playMusic();
    }
  }

  Future<void> dispose() async {
    await _safeCall(() async {
      await _musicPlayer.dispose();
    });

    for (final player in _effectPlayers) {
      await _safeCall(() async {
        await player.dispose();
      });
    }
  }

  Future<void> _playEffect(String asset) async {
    if (!_soundEnabled) return;
    await _ensureInitialized();

    if (!(_assetAvailable[asset] ?? false)) return;

    final player = _effectPlayers[_nextEffectPlayer];
    _nextEffectPlayer = (_nextEffectPlayer + 1) % _effectPlayers.length;

    await _safeCall(() async {
      await player.stop();
      await player.play(AssetSource(asset));
    });
  }

  Future<void> _playMusic({bool restart = false}) async {
    if (!_musicEnabled || _musicPaused) return;
    await _ensureInitialized();

    if (!(_assetAvailable[_backgroundMusicAsset] ?? false)) return;

    await _safeCall(() async {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);

      if (restart || !_musicStarted) {
        await _musicPlayer.play(AssetSource(_backgroundMusicAsset));
      } else {
        await _musicPlayer.resume();
      }

      _musicStarted = true;
    });
  }

  Future<void> _cacheAssetAvailability(String asset) async {
    _assetAvailable[asset] = await _assetExists(asset);
  }

  Future<bool> _assetExists(String asset) async {
    try {
      await rootBundle.load('assets/$asset');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await initialize();
  }

  Future<void> _safeCall(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      // Audio is optional feedback; missing files or platform issues must not
      // interrupt gameplay.
    }
  }
}
