import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/monetization/presentation/providers/monetization_provider.dart';

class UpsellScreen extends ConsumerWidget {
  const UpsellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passa a Glufri Pro')),
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
              const Text(
                'Sblocca Funzionalità Potenti!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const ListTile(
                leading: Icon(Icons.cloud_upload_rounded),
                title: Text('Backup e Sync Multi-dispositivo'),
              ),
              const ListTile(
                leading: Icon(Icons.description_rounded),
                title: Text('Esportazioni illimitate in CSV'),
              ),
              const ListTile(
                leading: Icon(Icons.hdr_off_rounded),
                title: Text('Esperienza senza pubblicità'),
              ),
              const ListTile(
                leading: Icon(Icons.support_agent_rounded),
                title: Text('Supporto Prioritario'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Abbonati Ora (Prezzo Annuo)',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  ref.read(monetizationProvider.notifier).purchasePro();
                  // Aggiungere eventuale logica per gestire la chiusura della schermata
                },
              ),
              TextButton(
                child: const Text('Ripristina Acquisti'),
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
