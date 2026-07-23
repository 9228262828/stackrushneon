import 'dart:async';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../services/haptic_service.dart';
import '../services/sound_service.dart';

class ScoreHud extends StatelessWidget {
  const ScoreHud({
    required this.score,
    required this.combo,
    required this.onPause,
    super.key,
  });

  final int score;
  final int combo;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HudItem(label: 'SCORE', value: '$score'),
        const SizedBox(width: 10),
        _HudItem(label: 'COMBO', value: 'x$combo'),
        const Spacer(),
        IconButton(
          onPressed: () {
            unawaited(HapticService.instance.selectionClick());
            unawaited(SoundService.instance.playButton());
            onPause();
          },
          icon: const Icon(Icons.pause_rounded),
        ),
      ],
    );
  }
}

class _HudItem extends StatelessWidget {
  const _HudItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cyan.withValues(alpha: .2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
