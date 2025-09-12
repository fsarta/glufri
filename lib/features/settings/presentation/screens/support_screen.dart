// lib/features/settings/presentation/screens/support_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/settings/presentation/providers/support_providers.dart';
import 'package:glufri/features/settings/presentation/screens/report_issue_screen.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final faqs = ref.watch(filteredFaqProvider);
    final faqsAsync = ref.watch(faqListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Aiuto & Supporto"), // TODO: Localizza
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) =>
                  ref.read(faqSearchQueryProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: "Cerca una domanda...", // TODO: Localizza
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: faqsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) =>
                  Center(child: Text("Errore nel caricare le FAQ")), // TODO
              data: (_) {
                if (faqs.isEmpty &&
                    ref.watch(faqSearchQueryProvider).isNotEmpty) {
                  return const Center(
                    child: Text("Nessuna risposta trovata."),
                  ); //TODO
                }
                return ListView.builder(
                  itemCount: faqs.length,
                  itemBuilder: (context, index) {
                    final faq = faqs[index];
                    return ExpansionTile(
                      title: Text(faq.question),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            faq.answer,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          // Pulsante per passare al Livello 2
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text("Non hai trovato la risposta?"), // TODO
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ReportIssueScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.contact_support_outlined),
                    label: const Text("Contatta il supporto"), // TODO
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
