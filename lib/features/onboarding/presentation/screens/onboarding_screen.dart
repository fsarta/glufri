import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_history_screen.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  // Funzione chiamata quando l'onboarding è completato o saltato
  void _onIntroEnd(BuildContext context, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true); // Salva la preferenza

    // --- NON NAVIGHIAMO PIÙ ---
    // Invece, aggiorniamo lo stato del provider. Riverpod farà il resto.
    ref.read(onboardingCompletedProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: l10n.onboardingWelcomeTitle,
          body: l10n.onboardingWelcomeBody,
          image: const Center(
            child: Icon(Icons.shopping_cart_checkout, size: 100),
          ),
        ),
        PageViewModel(
          title: l10n.onboardingScanTitle,
          body: l10n.onboardingScanBody,
          image: const Center(child: Icon(Icons.qr_code_scanner, size: 100)),
        ),
        PageViewModel(
          title: l10n.onboardingTrackTitle,
          body: l10n.onboardingTrackBody,
          image: const Center(child: Icon(Icons.receipt_long, size: 100)),
        ),
      ],
      onDone: () => _onIntroEnd(context, ref), // Quando si preme 'Done'
      onSkip: () => _onIntroEnd(context, ref), // Permette di saltare
      showSkipButton: true,
      skip: Text(l10n.skip),
      next: const Icon(Icons.arrow_forward),
      done: Text(
        l10n.start,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
