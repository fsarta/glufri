// lib/features/settings/presentation/screens/privacy_policy_screen.dart

import 'package:flutter/material.dart';
import 'package:glufri/core/l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: const Text('Informativa Privacy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(l10n.privacyPolicyBody),
      ),
    );
  }
}
