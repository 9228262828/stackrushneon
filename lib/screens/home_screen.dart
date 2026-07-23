import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../services/storage_service.dart';
import '../widgets/neon_background.dart';
import '../widgets/neon_button.dart';
import '../widgets/neon_logo.dart';
import 'game_screen.dart';
import 'privacy_screen.dart';
import 'settings_screen.dart';
import 'terms_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int get bestScore => StorageService.instance.bestScore;

  Future<void> _open(Widget screen) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NeonBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              children: [
                const Spacer(),
                const NeonLogo(size: 128),
                const SizedBox(height: 24),
                Text(
                  'STACK RUSH',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        letterSpacing: 3.5,
                      ),
                ),
                const Text(
                  'NEON',
                  style: TextStyle(
                    color: AppColors.pink,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 9,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.cyan.withValues(alpha: .18),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.emoji_events_rounded,
                        color: AppColors.lime,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'BEST  $bestScore',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                NeonButton(
                  label: 'PLAY',
                  icon: Icons.play_arrow_rounded,
                  onPressed: () => _open(const GameScreen()),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () => _open(const SettingsScreen()),
                  icon: const Icon(Icons.tune_rounded),
                  label: const Text('SETTINGS'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    side: BorderSide(
                      color: AppColors.cyan.withValues(alpha: .35),
                    ),
                  ),
                ),
                const Spacer(),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  children: [
                    TextButton(
                      onPressed: () => _open(const PrivacyScreen()),
                      child: const Text('Privacy'),
                    ),
                    TextButton(
                      onPressed: () => _open(const TermsScreen()),
                      child: const Text('Terms'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
