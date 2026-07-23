import 'dart:async';

import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../widgets/neon_background.dart';
import '../widgets/neon_logo.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();

    Timer(const Duration(milliseconds: 1900), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NeonBackground(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const NeonLogo(),
                  const SizedBox(height: 28),
                  Text(
                    'STACK RUSH',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      letterSpacing: 4,
                      shadows: [
                        Shadow(
                          color: AppColors.cyan.withValues(alpha: .8),
                          blurRadius: 18,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'NEON',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.pink,
                      letterSpacing: 10,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'TAP. STACK. RUSH.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
