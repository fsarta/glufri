// lib/main.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:glufri/features/backup/domain/sync_service.dart';
import 'package:glufri/features/budget/data/models/budget_model.dart';
import 'package:glufri/features/favorites/data/models/favorite_product_model.dart';
import 'package:glufri/features/shopping_list/data/models/shopping_list_item_model.dart';
import 'package:glufri/features/shopping_list/data/models/shopping_list_model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'firebase_options.dart'; // Generato da FlutterFire CLI

Future<void> _initializeGoogleSignInIfNeeded() async {
  // Sostituisci con il tuo web client id se necessario.
  const String webOrServerClientId =
      '640788715599-ets61k004urmk0mo1f69rh8hq8s8ribk.apps.googleusercontent.com';

  try {
    if (kIsWeb) {
      // Su web passiamo clientId
      await GoogleSignIn.instance.initialize(
        clientId: webOrServerClientId,
        serverClientId:
            webOrServerClientId, // non fa male fornirlo anche per web
      );
      debugPrint(
        'GoogleSignIn.initialized (web) with clientId/serverClientId.',
      );
    } else {
      // Su Android/iOS passiamo serverClientId (richiesto su Android per authenticate())
      await GoogleSignIn.instance.initialize(
        serverClientId: webOrServerClientId,
      );
      debugPrint('GoogleSignIn.initialized (mobile) with serverClientId.');
    }
  } catch (e, st) {
    // Non blocchiamo l'app completamente: logghiamo e proseguiamo.
    debugPrint('Warning: GoogleSignIn.initialize failed: $e\n$st');
  }
}

Future<void> main() async {
  // Assicurati che il binding Flutter sia inizializzato
  WidgetsFlutterBinding.ensureInitialized();

  // Esegui in parallelo le inizializzazioni principali:
  //    - Firebase
  //    - Hive
  //    - Mobile Ads
  //    - GoogleSignIn (necessario per google_sign_in >= 7.x)
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    Hive.initFlutter(),
    MobileAds.instance.initialize(),
    _initializeGoogleSignInIfNeeded(),
    initializeDateFormatting(),
    SharedPreferences.getInstance(),
  ]);

  // Registra gli adapters di Hive prima di aprire le box
  Hive.registerAdapter(PurchaseModelAdapter());
  Hive.registerAdapter(PurchaseItemModelAdapter());
  Hive.registerAdapter(BudgetModelAdapter());
  Hive.registerAdapter(FavoriteProductModelAdapter());
  Hive.registerAdapter(ShoppingListItemModelAdapter());
  Hive.registerAdapter(ShoppingListModelAdapter());

  // Apriremo i box dell'utente dinamicamente. Quello che DOBBIAMO fare qui
  // è aprire i box per l'utente "ospite" (`localUserId`).
  const String localUserId = 'local'; // Potrebbe essere importato
  await Hive.openBox<PurchaseModel>('purchases_$localUserId');
  await Hive.openBox<ShoppingListModel>('shopping_lists_$localUserId');
  await Hive.openBox<ShoppingListItemModel>('shopping_list_items_$localUserId');
  await Hive.openBox<BudgetModel>('budgets_$localUserId');
  await Hive.openBox<FavoriteProductModel>('favorites_$localUserId');

  // Controlla se l'utente ha già visto l'onboarding
  final prefs = await SharedPreferences.getInstance();
  final bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  // Imposta il locale di default per tutta l'app
  Intl.defaultLocale = WidgetsBinding.instance.platformDispatcher.locale
      .toLanguageTag();

  // Esegui l'app avvolta in ProviderScope (Riverpod)
  runApp(ProviderScope(child: GlufriApp(hasSeenOnboarding: hasSeenOnboarding)));
}
