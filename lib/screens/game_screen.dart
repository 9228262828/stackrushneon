import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../game/game_controller.dart';
import '../game/game_painter.dart';
import '../services/haptic_service.dart';
import '../services/sound_service.dart';
import '../services/storage_service.dart';
import '../widgets/score_hud.dart';
import 'game_over_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late final GameController _controller;
  late final Ticker _ticker;
  Duration? _lastElapsed;
  bool _gameOverShown = false;

  @override
  void initState() {
    super.initState();

    _controller = GameController(settings: StorageService.instance.settings)
      ..addListener(_onGameChanged);

    _ticker = createTicker(_tick)..start();
  }

  void _tick(Duration elapsed) {
    final previous = _lastElapsed;
    _lastElapsed = elapsed;
    if (previous == null) return;

    final dt = (elapsed - previous).inMicroseconds / 1000000;
    _controller.update(dt.clamp(0.0, .04));
  }

  void _onGameChanged() {
    if (!mounted) return;

    if (_controller.status == GameStatus.gameOver && !_gameOverShown) {
      _gameOverShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => GameOverScreen(
              score: _controller.score,
              bestScore: _controller.bestScore,
            ),
          ),
        );
      });
    }

    setState(() {});
  }

  void _buttonFeedback() {
    unawaited(HapticService.instance.selectionClick());
    unawaited(SoundService.instance.playButton());
  }

  @override
  void dispose() {
    _ticker.dispose();
    _controller
      ..removeListener(_onGameChanged)
      ..dispose();
    super.dispose();
  }

  Future<void> _showPauseDialog() async {
    _controller.pause();

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('PAUSED'),
          content: const Text('Take a breath, then continue the rush.'),
          actions: [
            TextButton(
              onPressed: () {
                _buttonFeedback();
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              child: const Text('HOME'),
            ),
            FilledButton(
              onPressed: () {
                _buttonFeedback();
                Navigator.of(context).pop();
                _controller.resume();
              },
              child: const Text('RESUME'),
            ),
          ],
        );
      },
    );

    if (mounted && _controller.status == GameStatus.paused) {
      _controller.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          _controller.configure(size);

          if (_controller.status == GameStatus.ready) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _controller.start();
            });
          }

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _controller.placeBlock,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: GamePainter(
                      blocks: _controller.blocks,
                      movingBlock: _controller.movingBlock,
                      particles: _controller.particles,
                      cameraShake: _controller.cameraShake,
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ScoreHud(
                      score: _controller.score,
                      combo: _controller.combo,
                      onPause: _showPauseDialog,
                    ),
                  ),
                ),
                if (_controller.lastWasPerfect &&
                    _controller.status == GameStatus.playing)
                  const Positioned(
                    top: 145,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'PERFECT!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                          color: Colors.white,
                          shadows: [
                            Shadow(color: Colors.cyanAccent, blurRadius: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                const Positioned(
                  bottom: 28,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'TAP TO DROP',
                      style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
