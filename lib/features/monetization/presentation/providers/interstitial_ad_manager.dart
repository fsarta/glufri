// lib/features/monetization/presentation/providers/interstitial_ad_manager.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Usa SEMPRE gli ID di test durante lo sviluppo!
const String _testAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  int _saveCounter = 0; // Contatore per la frequenza
  final int _adFrequency = 3; // Mostra l'ad ogni 3 salvataggi

  /// Carica un nuovo annuncio in memoria.
  void loadAd() {
    // Se c'è già un annuncio caricato, non fare nulla.
    if (_interstitialAd != null) {
      return;
    }

    InterstitialAd.load(
      adUnitId: _testAdUnitId, // Sostituisci con il tuo vero ID in produzione
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('$ad caricato.');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  /// Mostra l'annuncio se è pronto E se le condizioni di frequenza sono soddisfatte.
  void showAdIfAvailable({VoidCallback? onAdDismissed}) {
    _saveCounter++;

    // Controlla se l'annuncio è pronto E se il contatore ha raggiunto la soglia
    if (_interstitialAd != null && _saveCounter % _adFrequency == 0) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose(); // Libera la memoria
          _interstitialAd = null;
          loadAd(); // Pre-carica il prossimo annuncio
          onAdDismissed?.call(); // Esegui la callback
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          loadAd();
          onAdDismissed?.call(); // Esegui la callback anche in caso di errore
        },
      );
      _interstitialAd!.show();
    } else {
      // Se non mostriamo l'annuncio, eseguiamo subito la callback.
      onAdDismissed?.call();
    }
  }
}

// Il provider Riverpod per accedere al nostro manager
final interstitialAdManagerProvider = Provider<InterstitialAdManager>((ref) {
  return InterstitialAdManager();
});
