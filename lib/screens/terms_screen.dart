import 'package:flutter/material.dart';

import '../core/app_constants.dart';
import '../widgets/neon_background.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TERMS & CONDITIONS')),
      body: const NeonBackground(
        child: _TermsContent(),
      ),
    );
  }
}

class _TermsContent extends StatelessWidget {
  const _TermsContent();

  @override
  Widget build(BuildContext context) {
    const sections = [
      (
        'Acceptance',
        'By installing or using Stack Rush Neon, you agree to these terms. If you do not agree, uninstall and stop using the app.'
      ),
      (
        'License',
        'You receive a limited, personal, non-exclusive, and non-transferable right to use the app for lawful entertainment purposes.'
      ),
      (
        'Offline gameplay',
        'The app is designed for offline use. Scores and preferences are stored locally. Removing the app or clearing its data may delete saved information.'
      ),
      (
        'Prohibited use',
        'You may not reverse engineer, redistribute, sell, modify, exploit, or use the app in a way that violates applicable laws or the rights of others.'
      ),
      (
        'Availability',
        'The app is provided as available. Features may be improved, changed, or removed in future versions.'
      ),
      (
        'Disclaimer',
        'The app is provided without warranties to the maximum extent permitted by law. The developer is not responsible for indirect loss caused by use or inability to use the app.'
      ),
      (
        'Changes',
        'These terms may be updated when the app changes. Continued use after an update means you accept the revised terms.'
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        Text(
          'Last updated: ${AppConstants.termsUpdated}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 18),
        for (final section in sections) ...[
          Text(
            section.$1,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(section.$2),
          const SizedBox(height: 22),
        ],
      ],
    );
  }
}
