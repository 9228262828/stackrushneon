import 'dart:async';

import 'package:flutter/material.dart';

import '../services/haptic_service.dart';
import '../services/sound_service.dart';

class NeonButton extends StatelessWidget {
  const NeonButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.compact = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = onPressed == null
        ? null
        : () {
            unawaited(HapticService.instance.selectionClick());
            unawaited(SoundService.instance.playButton());
            onPressed!();
          };

    final button = icon == null
        ? FilledButton(onPressed: effectiveOnPressed, child: Text(label))
        : FilledButton.icon(
            onPressed: effectiveOnPressed,
            icon: Icon(icon),
            label: Text(label),
          );

    if (!compact) return button;

    return SizedBox(height: 52, child: button);
  }
}
