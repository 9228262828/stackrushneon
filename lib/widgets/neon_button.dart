import 'package:flutter/material.dart';

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
    final button = icon == null
        ? FilledButton(
            onPressed: onPressed,
            child: Text(label),
          )
        : FilledButton.icon(
            onPressed: onPressed,
            icon: Icon(icon),
            label: Text(label),
          );

    if (!compact) return button;

    return SizedBox(
      height: 52,
      child: button,
    );
  }
}
