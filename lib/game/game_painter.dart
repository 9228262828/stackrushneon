import 'dart:math';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/particle.dart';
import '../models/stack_block.dart';

class GamePainter extends CustomPainter {
  GamePainter({
    required this.blocks,
    required this.movingBlock,
    required this.particles,
    required this.cameraShake,
  });

  final List<StackBlock> blocks;
  final StackBlock? movingBlock;
  final List<Particle> particles;
  final double cameraShake;

  @override
  void paint(Canvas canvas, Size size) {
    _paintBackground(canvas, size);

    canvas.save();
    if (cameraShake > 0) {
      final phase = DateTime.now().millisecondsSinceEpoch / 28;
      canvas.translate(
        sin(phase) * cameraShake,
        cos(phase * 1.2) * cameraShake,
      );
    }

    for (final block in blocks) {
      _paintBlock(canvas, block);
    }

    if (movingBlock != null) {
      _paintBlock(canvas, movingBlock!);
    }

    _paintParticles(canvas, particles);
    canvas.restore();
  }

  void _paintBackground(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0, -.45),
        radius: 1.2,
        colors: [Color(0xFF171744), AppColors.background],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    final grid = Paint()
      ..color = Colors.white.withValues(alpha: .035)
      ..strokeWidth = 1;

    const gap = 32.0;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
  }

  void _paintBlock(Canvas canvas, StackBlock block) {
    final rect = RRect.fromRectAndRadius(block.rect, const Radius.circular(7));

    final glow = Paint()
      ..color = block.color.withValues(alpha: .35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          block.color.withValues(alpha: .95),
          block.color.withValues(alpha: .58),
        ],
      ).createShader(block.rect);

    canvas.drawRRect(rect, glow);
    canvas.drawRRect(rect, fill);

    final highlight = Paint()
      ..color = Colors.white.withValues(alpha: .28)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(block.x + 8, block.y + 4),
      Offset(block.x + block.width - 8, block.y + 4),
      highlight,
    );
  }

  void _paintParticles(Canvas canvas, List<Particle> particles) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withValues(
          alpha: particle.life.clamp(0.0, 1.0),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) => true;
}
