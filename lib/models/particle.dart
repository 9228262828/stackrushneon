import 'package:flutter/material.dart';

class Particle {
  Particle({
    required this.position,
    required this.velocity,
    required this.life,
    required this.radius,
    required this.color,
  });

  Offset position;
  Offset velocity;
  double life;
  final double radius;
  final Color color;
}
