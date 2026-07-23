import 'package:flutter/material.dart';

import '../controllers/settings_controller.dart';
import '../core/app_colors.dart';
import '../widgets/neon_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SettingsController()..addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_refresh)
      ..dispose();
    super.dispose();
  }

  Future<void> _resetBestScore() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset best score?'),
          content: const Text('This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('CANCEL'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('RESET'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;
    await _controller.resetBestScore();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Best score reset')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = _controller.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('SETTINGS')),
      body: NeonBackground(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          children: [
            _SettingsTile(
              icon: Icons.volume_up_rounded,
              title: 'Sound effects',
              subtitle: 'Hits, perfect drops and game over',
              value: settings.soundEnabled,
              onChanged: _controller.setSound,
            ),
            _SettingsTile(
              icon: Icons.music_note_rounded,
              title: 'Music',
              subtitle: 'Prepared for future background tracks',
              value: settings.musicEnabled,
              onChanged: _controller.setMusic,
            ),
            _SettingsTile(
              icon: Icons.vibration_rounded,
              title: 'Haptics',
              subtitle: 'Vibration feedback while stacking',
              value: settings.hapticsEnabled,
              onChanged: _controller.setHaptics,
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: _resetBestScore,
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('RESET BEST SCORE'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.danger,
                side: BorderSide(
                  color: AppColors.danger.withValues(alpha: .45),
                ),
                minimumSize: const Size.fromHeight(54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon, color: AppColors.cyan),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}
