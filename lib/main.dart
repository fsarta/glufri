import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'firebase_options.dart'; // Generato da FlutterFire CLI

Future<void> main() async {
  // 1. Assicurati che il binding Flutter sia inizializzato
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inizializza i servizi esterni in parallelo
  await Future.wait([
    // Inizializza Firebase
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    // Inizializza Hive per il database locale
    Hive.initFlutter(),
    // Inizializza il Mobile Ads SDK
    MobileAds.instance.initialize(),
  ]);

  // 3. Registra gli adapter di Hive per i modelli di dati
  Hive.registerAdapter(PurchaseModelAdapter());
  Hive.registerAdapter(PurchaseItemModelAdapter());
  await Hive.openBox<PurchaseModel>('purchases');

  // 4. Controlla se l'utente ha già visto l'onboarding
  final prefs = await SharedPreferences.getInstance();
  final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  // 5. Esegui l'app, avvolgendola nel ProviderScope di Riverpod
  runApp(ProviderScope(child: GlufriApp(hasSeenOnboarding: hasSeenOnboarding)));
}
