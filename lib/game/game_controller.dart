import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_constants.dart';
import '../models/app_settings.dart';
import '../models/particle.dart';
import '../models/stack_block.dart';
import '../services/haptic_service.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';

enum GameStatus { ready, playing, paused, gameOver }

class GameController extends ChangeNotifier {
  GameController({
    required this.settings,
    StorageService? storage,
    HapticService? haptics,
    SoundService? sound,
  }) : _storage = storage ?? StorageService.instance,
       _haptics = haptics ?? HapticService.instance,
       _sound = sound ?? SoundService.instance;

  final AppSettings settings;
  final StorageService _storage;
  final HapticService _haptics;
  final SoundService _sound;
  final Random _random = Random();

  final List<StackBlock> blocks = [];
  final List<Particle> particles = [];

  GameStatus status = GameStatus.ready;
  int score = 0;
  int combo = 0;
  int bestScore = 0;
  double speed = AppConstants.initialSpeed;
  double direction = 1;
  double cameraShake = 0;
  bool lastWasPerfect = false;
  double _perfectMessageTime = 0;

  Size _boardSize = Size.zero;
  StackBlock? movingBlock;

  void configure(Size size) {
    if (size == Size.zero || size == _boardSize) return;
    _boardSize = size;
    if (blocks.isEmpty) {
      _resetBoard();
    }
  }

  void start() {
    if (_boardSize == Size.zero) return;
    score = 0;
    combo = 0;
    speed = AppConstants.initialSpeed;
    direction = 1;
    bestScore = _storage.bestScore;
    particles.clear();
    _resetBoard();
    lastWasPerfect = false;
    _perfectMessageTime = 0;
    status = GameStatus.playing;
    unawaited(_sound.startMusic());
    notifyListeners();
  }

  void pause() {
    if (status != GameStatus.playing) return;
    status = GameStatus.paused;
    unawaited(_sound.pauseMusic());
    notifyListeners();
  }

  void resume() {
    if (status != GameStatus.paused) return;
    status = GameStatus.playing;
    unawaited(_sound.resumeMusic());
    notifyListeners();
  }

  void update(double dt) {
    if (status != GameStatus.playing || movingBlock == null) return;

    var nextX = movingBlock!.x + speed * direction * dt;
    final maxX = _boardSize.width - movingBlock!.width;

    if (nextX <= 0) {
      nextX = 0;
      direction = 1;
    } else if (nextX >= maxX) {
      nextX = maxX;
      direction = -1;
    }

    movingBlock = movingBlock!.copyWith(x: nextX);

    for (final particle in particles) {
      particle.position += particle.velocity * dt;
      particle.velocity += const Offset(0, 180) * dt;
      particle.life -= dt;
    }
    particles.removeWhere((p) => p.life <= 0);

    cameraShake = max(0, cameraShake - 28 * dt);

    if (_perfectMessageTime > 0) {
      _perfectMessageTime = max(0, _perfectMessageTime - dt);
      if (_perfectMessageTime == 0) {
        lastWasPerfect = false;
      }
    }

    notifyListeners();
  }

  Future<void> placeBlock() async {
    if (status != GameStatus.playing || movingBlock == null) return;

    final previous = blocks.last;
    final current = movingBlock!;

    final overlapLeft = max(previous.x, current.x);
    final overlapRight = min(
      previous.x + previous.width,
      current.x + current.width,
    );
    final overlap = overlapRight - overlapLeft;

    if (overlap <= 0) {
      await _endGame();
      return;
    }

    final offset = (current.x - previous.x).abs();
    final perfect = offset <= AppConstants.perfectThreshold;
    lastWasPerfect = perfect;
    _perfectMessageTime = perfect ? .65 : 0;

    double placedX = overlapLeft;
    double placedWidth = overlap;

    if (perfect) {
      placedX = previous.x;
      placedWidth = previous.width;
      combo += 1;
      score += 2 + combo;
      cameraShake = 5;
      await _haptics.mediumImpact();
      await _sound.playPerfect();
    } else {
      combo = 0;
      score += 1;
      cameraShake = 2;
      await _haptics.lightImpact();
      await _sound.playTap();
    }

    final placed = current.copyWith(x: placedX, width: placedWidth);

    blocks.add(placed);
    _spawnParticles(placed, perfect);

    speed = min(
      AppConstants.maxSpeed,
      AppConstants.initialSpeed + blocks.length * 7.5,
    );

    _spawnMovingBlock(placed);
    notifyListeners();
  }

  Future<void> _endGame() async {
    status = GameStatus.gameOver;
    movingBlock = null;
    combo = 0;
    lastWasPerfect = false;
    _perfectMessageTime = 0;
    cameraShake = 9;
    await _sound.stopMusic();
    await _haptics.heavyImpact();
    await _sound.playGameOver();

    if (score > bestScore) {
      bestScore = score;
      await _storage.saveBestScore(score);
    }

    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_sound.stopMusic());
    super.dispose();
  }

  void _resetBoard() {
    blocks
      ..clear()
      ..add(
        StackBlock(
          x: (_boardSize.width - AppConstants.initialBlockWidth) / 2,
          y: _boardSize.height - 88,
          width: AppConstants.initialBlockWidth,
          height: AppConstants.blockHeight,
          color: AppColors.purple,
        ),
      );

    movingBlock = StackBlock(
      x: 0,
      y: _boardSize.height - 88 - AppConstants.blockHeight - 8,
      width: AppConstants.initialBlockWidth,
      height: AppConstants.blockHeight,
      color: AppColors.cyan,
    );
  }

  void _spawnMovingBlock(StackBlock previous) {
    final y = previous.y - AppConstants.blockHeight - 8;
    final color = _palette[blocks.length % _palette.length];

    movingBlock = StackBlock(
      x: direction > 0 ? 0 : _boardSize.width - previous.width,
      y: y,
      width: previous.width,
      height: AppConstants.blockHeight,
      color: color,
    );
  }

  void _spawnParticles(StackBlock block, bool perfect) {
    final count = perfect ? 20 : 9;
    final center = Offset(block.x + block.width / 2, block.y);

    for (var i = 0; i < count; i++) {
      particles.add(
        Particle(
          position: center,
          velocity: Offset(
            (_random.nextDouble() - .5) * 210,
            -40 - _random.nextDouble() * 170,
          ),
          life: .55 + _random.nextDouble() * .5,
          radius: 2 + _random.nextDouble() * 3,
          color: block.color,
        ),
      );
    }
  }

  static const _palette = [
    AppColors.cyan,
    AppColors.pink,
    AppColors.purple,
    AppColors.lime,
  ];
}
