// lib/features/settings/presentation/screens/report_issue_screen.dart

import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/backup/presentation/providers/user_provider.dart';
import 'package:glufri/features/monetization/presentation/providers/monetization_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportIssueScreen extends ConsumerStatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  ConsumerState<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends ConsumerState<ReportIssueScreen> {
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Problema Tecnico'; // TODO: Localizza
  bool _attachDebugInfo = true;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _sendSupportEmail() async {
    // 1. Raccogli i dati di debug
    final packageInfo = await PackageInfo.fromPlatform();
    final appVersion = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;
    final os = Platform.operatingSystem;
    final osVersion = Platform.operatingSystemVersion;
    final userId = ref.read(userProvider)?.uid ?? "Guest";
    final isPro = ref.read(isProUserProvider);
    final userMessage = _descriptionController.text.trim();

    String debugInfo = "";
    if (_attachDebugInfo) {
      debugInfo =
          """
      -------------------------------------------
      Non modificare le informazioni sottostanti.
      App Version: $appVersion ($buildNumber)
      OS: $os $osVersion
      User ID: $userId
      Is Pro: $isPro
      Categoria: $_selectedCategory
      -------------------------------------------
      """;
    }

    final String emailBody =
        """
    Descrivi qui il tuo problema o suggerimento:

    $userMessage
    
    $debugInfo
    """;

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      // path: 'tuo.supporto@esempio.com', // <-- INSERISCI LA TUA EMAIL REALE
      path: 'frasar86@gmail.com',
      query:
          'subject=${Uri.encodeComponent('Supporto Glufri: [$_selectedCategory]')}&body=${Uri.encodeComponent(emailBody)}',
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        throw 'Could not launch $emailLaunchUri';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Impossibile aprire l'app di posta. Contattaci a tuo.supporto@esempio.com",
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contatta il Supporto"), // TODO: Localizza
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Scegli una categoria per aiutarci a capire meglio il problema.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items:
                  [
                        'Problema Tecnico', // TODO
                        'Domanda su una feature',
                        'Suggerimento',
                        'Altro',
                      ]
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedCategory = value);
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 24),
            const Text(
              "Descrivi il tuo problema o suggerimento nel dettaglio.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 8,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Più dettagli fornisci, meglio potremo aiutarti...",
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text("Allega informazioni di debug"),
              subtitle: const Text(
                "Aiuta a risolvere il problema più velocemente.",
              ),
              value: _attachDebugInfo,
              onChanged: (value) => setState(() => _attachDebugInfo = value),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _sendSupportEmail,
              child: const Text("Invia Report tramite Email"),
            ),
          ],
        ),
      ),
    );
  }
}
