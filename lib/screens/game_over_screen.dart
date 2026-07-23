import 'dart:async';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../services/haptic_service.dart';
import '../services/sound_service.dart';
import '../widgets/neon_background.dart';
import '../widgets/neon_button.dart';
import 'game_screen.dart';
import 'home_screen.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({
    required this.score,
    required this.bestScore,
    super.key,
  });

  final int score;
  final int bestScore;

  void _buttonFeedback() {
    unawaited(HapticService.instance.selectionClick());
    unawaited(SoundService.instance.playButton());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NeonBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt_rounded, size: 76, color: AppColors.pink),
                const SizedBox(height: 18),
                Text(
                  'GAME OVER',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: _ScoreCard(
                        label: 'SCORE',
                        value: score,
                        color: AppColors.cyan,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _ScoreCard(
                        label: 'BEST',
                        value: bestScore,
                        color: AppColors.lime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                NeonButton(
                  label: 'PLAY AGAIN',
                  icon: Icons.refresh_rounded,
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => const GameScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {
                    _buttonFeedback();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute<void>(
                        builder: (_) => const HomeScreen(),
                      ),
                      (_) => false,
                    );
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('HOME'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: .28)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              letterSpacing: 1.7,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
