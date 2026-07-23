import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class NeonBackground extends StatelessWidget {
  const NeonBackground({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -.4),
                radius: 1.2,
                colors: [
                  Color(0xFF171744),
                  AppColors.background,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -90,
          right: -90,
          child: _GlowOrb(
            size: 280,
            color: AppColors.pink.withValues(alpha: .16),
          ),
        ),
        Positioned(
          bottom: -120,
          left: -100,
          child: _GlowOrb(
            size: 320,
            color: AppColors.cyan.withValues(alpha: .14),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
          ),
        ),
      ),
    );
  }
}
