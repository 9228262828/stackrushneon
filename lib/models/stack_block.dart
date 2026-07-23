import 'package:flutter/material.dart';

class StackBlock {
  const StackBlock({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.color,
  });

  final double x;
  final double y;
  final double width;
  final double height;
  final Color color;

  Rect get rect => Rect.fromLTWH(x, y, width, height);

  StackBlock copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    Color? color,
  }) {
    return StackBlock(
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      color: color ?? this.color,
    );
  }
}
