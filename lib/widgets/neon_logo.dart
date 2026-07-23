import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class NeonLogo extends StatelessWidget {
  const NeonLogo({
    this.size = 140,
    super.key,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * .88,
            height: size * .88,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * .24),
              border: Border.all(
                color: AppColors.cyan.withValues(alpha: .65),
              ),
              gradient: LinearGradient(
                colors: [
                  AppColors.cyan.withValues(alpha: .16),
                  AppColors.pink.withValues(alpha: .10),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: .25),
                  blurRadius: 34,
                  spreadRadius: 4,
                ),
              ],
            ),
          ),
          _Bar(
            width: size * .58,
            y: size * .19,
            color: AppColors.pink,
          ),
          _Bar(
            width: size * .45,
            y: 0,
            color: AppColors.cyan,
          ),
          _Bar(
            width: size * .31,
            y: -size * .19,
            color: AppColors.pink,
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.width,
    required this.y,
    required this.color,
  });

  final double width;
  final double y;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, y),
      child: Container(
        width: width,
        height: 18,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: .7),
              blurRadius: 16,
            ),
          ],
        ),
      ),
    );
  }
}
