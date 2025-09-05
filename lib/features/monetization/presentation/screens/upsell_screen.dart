import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/monetization/presentation/providers/monetization_provider.dart';

class UpsellScreen extends ConsumerWidget {
  const UpsellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.upsellTitle)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.star_purple500_outlined,
                size: 80,
                color: Colors.amber,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.upsellHeadline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(Icons.cloud_upload_rounded),
                title: Text(l10n.upsellFeature1),
              ),
              ListTile(
                leading: const Icon(Icons.description_rounded),
                title: Text(l10n.upsellFeature2),
              ),
              ListTile(
                leading: const Icon(Icons.hdr_off_rounded),
                title: Text(l10n.upsellFeature3),
              ),
              ListTile(
                leading: const Icon(Icons.support_agent_rounded),
                title: Text(l10n.upsellFeature4),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  l10n.upsellAction,
                  style: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  ref.read(monetizationProvider.notifier).purchasePro();
                  // Aggiungere eventuale logica per gestire la chiusura della schermata
                },
              ),
              TextButton(
                child: Text(l10n.upsellRestore),
                onPressed: () {
                  // Aggiungere logica di restore purchases
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
