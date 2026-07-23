import 'package:flutter/material.dart';

import '../core/app_constants.dart';
import '../widgets/neon_background.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LegalPage(
      title: 'PRIVACY POLICY',
      updated: AppConstants.privacyUpdated,
      sections: [
        _LegalSection(
          heading: 'Overview',
          body:
              'Stack Rush Neon is an offline arcade game. The app is designed to work without an account, server, analytics platform, advertising network, or online profile.',
        ),
        _LegalSection(
          heading: 'Data stored on your device',
          body:
              'The app stores your best score and local preferences such as sound, music, and haptic settings. This information remains on your device using SharedPreferences.',
        ),
        _LegalSection(
          heading: 'Data collection',
          body:
              'The app does not collect, transmit, sell, rent, or share personal information. It does not request your name, email address, contacts, location, photos, microphone, camera, or payment details.',
        ),
        _LegalSection(
          heading: 'Children',
          body:
              'The app does not knowingly collect personal information from children or adults. The gameplay is local and does not include chat, user-generated content, or online interaction.',
        ),
        _LegalSection(
          heading: 'Changes',
          body:
              'This policy may be updated if the app features change. The current version remains available inside the app.',
        ),
      ],
    );
  }
}

class _LegalPage extends StatelessWidget {
  const _LegalPage({
    required this.title,
    required this.updated,
    required this.sections,
  });

  final String title;
  final String updated;
  final List<_LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: NeonBackground(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            Text(
              'Last updated: $updated',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            for (final section in sections) ...[
              Text(
                section.heading,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(section.body),
              const SizedBox(height: 22),
            ],
          ],
        ),
      ),
    );
  }
}

class _LegalSection {
  const _LegalSection({required this.heading, required this.body});

  final String heading;
  final String body;
}
