import 'package:flutter/material.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_history_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // Funzione chiamata quando l'onboarding è completato o saltato
  void _onIntroEnd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true); // Salva la preferenza

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PurchaseHistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Benvenuto in Glufri!",
          body:
              "La tua app per tracciare gli acquisti senza glutine in modo semplice e veloce.",
          image: const Center(
            child: Icon(Icons.shopping_cart_checkout, size: 100),
          ),
        ),
        PageViewModel(
          title: "Scansiona e Aggiungi",
          body:
              "Usa la fotocamera per scansionare il codice a barre dei prodotti e aggiungerli al tuo carrello.",
          image: const Center(child: Icon(Icons.qr_code_scanner, size: 100)),
        ),
        PageViewModel(
          title: "Tieni Tutto Sotto Controllo",
          body:
              "Salva i tuoi acquisti e consulta la cronologia per analizzare le tue spese.",
          image: const Center(child: Icon(Icons.receipt_long, size: 100)),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // Permette di saltare
      showSkipButton: true,
      skip: const Text('Salta'),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Inizia", style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
