// lib/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/config/app_theme.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/core/utils/navigator_key.dart';
import 'package:glufri/features/backup/domain/sync_service.dart';
import 'package:glufri/features/backup/domain/user_model.dart';
import 'package:glufri/features/backup/presentation/providers/sync_providers.dart';
import 'package:glufri/features/backup/presentation/providers/user_provider.dart';
import 'package:glufri/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:glufri/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:glufri/features/purchase/data/datasources/purchase_local_datasource.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_providers.dart';
import 'package:glufri/features/settings/presentation/providers/settings_provider.dart';
import 'package:glufri/features/shell/presentation/screens/main_shell_screen.dart';
import 'package:glufri/features/backup/domain/sync_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthWrapper extends ConsumerWidget {
  final bool hasInitiallySeenOnboarding; // Rinominato per chiarezza
  const AuthWrapper({super.key, required this.hasInitiallySeenOnboarding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. 'Osserva' lo stato del provider, non il suo notifier.
    final hasCompletedOnboarding = ref.watch(onboardingCompletedProvider);

    // 2. Determina lo stato finale: se uno dei due è true, l'onboarding è 'fatto'.
    final shouldShowMainScreen =
        hasCompletedOnboarding || hasInitiallySeenOnboarding;

    if (shouldShowMainScreen) {
      return const MainShellScreen();
    } else {
      return const OnboardingScreen();
    }
  }
}

class GlufriApp extends ConsumerStatefulWidget {
  final bool hasSeenOnboarding;
  const GlufriApp({super.key, required this.hasSeenOnboarding});

  @override
  ConsumerState<GlufriApp> createState() => _GlufriAppState();
}

class _GlufriAppState extends ConsumerState<GlufriApp> {
  @override
  void initState() {
    super.initState();
    // Imposta il listener una sola volta all'avvio dell'app.
    // Usare initState è la pratica migliore per i listener che devono
    // durare per l'intero ciclo di vita dell'app.
    _setupAuthListener();
  }

  /// Imposta un listener che reagisce ai cambiamenti di stato dell'utente (login/logout).
  void _setupAuthListener() {
    // Usiamo `ref.listenManual` perché il listener è in initState e non deve
    // essere ricreato ad ogni build.
    ref.listenManual<UserModel?>(userProvider, (previous, next) {
      final navigatorContext = navigatorKey.currentContext;
      if (navigatorContext == null) return;
      final l10n = AppLocalizations.of(navigatorContext)!;

      // --- CASO LOGIN: l'utente passa da 'null' (sloggato) a un utente valido.
      if (previous == null && next != null) {
        debugPrint(
          '--- [Auth Listener] LOGIN RILEVATO per utente: ${next.uid} ---',
        );

        // Mostra una notifica di benvenuto
        ScaffoldMessenger.of(navigatorContext).showSnackBar(
          SnackBar(
            content: Text(l10n.loginSuccess),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        debugPrint('[Auth Listener] Chiamo _handlePostLoginFlow...');

        // `popUntil` chiude tutte le schermate una sopra l'altra
        // fino a quando non trova una rotta che soddisfa la condizione.
        // La condizione `(route) => route.isFirst` è vera solo per la
        // primissima schermata dell'app (la nostra MainShellScreen/AuthWrapper).
        Navigator.of(navigatorContext).popUntil((route) => route.isFirst);

        // Il flusso di sync viene avviato subito dopo, mentre l'utente
        // è già stato riportato alla home.
        _handlePostLoginFlow(navigatorContext, next.uid);
      }
      // --- CASO LOGOUT: l'utente passa da uno stato valido a 'null'.
      else if (previous != null && next == null) {
        debugPrint('--- [Auth Listener] LOGOUT RILEVATO ---');
        ScaffoldMessenger.of(navigatorContext).showSnackBar(
          SnackBar(
            content: Text(l10n.logoutSuccess),
            backgroundColor: Theme.of(navigatorContext).colorScheme.primary,
          ),
        );
        // Anche dopo il logout, assicuriamoci di tornare alla home.
        Navigator.of(navigatorContext).popUntil((route) => route.isFirst);
      }
    });
  }

  /// Orchestra le operazioni da eseguire dopo un login (ripristino/migrazione).
  Future<void> _handlePostLoginFlow(BuildContext context, String userId) async {
    final l10n = AppLocalizations.of(context)!;
    ref.read(syncInProgressProvider.notifier).state = true;
    debugPrint('[Sync & Migration] Avvio del flusso post-login...');

    try {
      // --- STEP 1: GESTIONE MIGRAZIONE DATI OSPITE ---
      // Questa è la priorità. Lo facciamo prima del sync intelligente.
      // Chiamiamo il dialogo, e la funzione interna ora restituirà `true`
      // se l'utente ha scelto di unire i dati.
      final bool didMergeAndBackup = await _showMigrationDialog(userId);

      // --- STEP 2: SYNC INTELLIGENTE ---
      // Eseguiamo il sync intelligente solo se NON abbiamo appena fatto una migrazione
      // con backup, per evitare operazioni ridondanti.
      if (!didMergeAndBackup) {
        final syncService = ref.read(syncServiceProvider);

        final futures = await Future.wait([
          syncService.getLatestPurchaseDateFromLocal(),
          syncService.getLatestPurchaseDateFromCloud(),
        ]);
        final localLatestDate = futures[0];
        final cloudLatestDate = futures[1];

        debugPrint(
          '[Sync] Data locale più recente (utente loggato): $localLatestDate',
        );
        debugPrint('[Sync] Data cloud più recente: $cloudLatestDate');

        // Logica decisionale (invariata, ma ora eseguita nel momento giusto)
        if (localLatestDate == null && cloudLatestDate == null) {
          debugPrint('[Sync] Decisione: Nessun dato da sincronizzare.');
        } else if (localLatestDate == null ||
            (cloudLatestDate != null &&
                cloudLatestDate.isAfter(localLatestDate))) {
          debugPrint(
            '[Sync] Decisione: Dati cloud più recenti. Avvio RESTORE...',
          );
          await syncService.restoreFromCloudAndGetCount();
          if (mounted)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Dati sincronizzati dal cloud.")),
            );
          ref.invalidate(purchaseListProvider);
        } else if (cloudLatestDate == null ||
            localLatestDate!.isAfter(cloudLatestDate)) {
          debugPrint(
            '[Sync] Decisione: Dati locali più recenti. Avvio BACKUP...',
          );
          await syncService.backupToCloud();
          if (mounted)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Le modifiche offline sono state salvate nel cloud.",
                ),
              ),
            );
          ref.invalidate(purchaseListProvider);
        } else {
          debugPrint('[Sync] Decisione: Dati già sincronizzati.');
        }
      }
    } catch (e) {
      debugPrint('[Sync & Migration] *** ERRORE CATTURATO: $e ***');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.syncError), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        ref.read(syncInProgressProvider.notifier).state = false;
        debugPrint('[Sync & Migration] Flusso terminato.');
      }
    }
  }

  /// Controlla i dati "ospite" e chiede all'utente come gestirli.
  /// Restituisce `true` se i dati sono stati uniti e backuppati, `false` altrimenti.
  Future<bool> _showMigrationDialog(String newUserId) async {
    final context = navigatorKey.currentContext;
    if (context == null) return false;

    final l10n = AppLocalizations.of(context)!;
    final localBoxName = 'purchases_$localUserId';

    // Assicuriamoci di ritornare `false` di default se non facciamo nulla.
    bool didMergeAndBackup = false;

    if (await Hive.boxExists(localBoxName)) {
      final localBox = await Hive.openBox<PurchaseModel>(localBoxName);

      try {
        // Usiamo un blocco try-finally per garantire la chiusura della box
        if (localBox.isNotEmpty && context.mounted) {
          final choice = await showDialog<String>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: Text(l10n.migrationDialogTitle),
              content: Text(l10n.migrationDialogBody(localBox.length)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop('delete'),
                  child: Text(l10n.migrationDialogActionDelete),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop('ignore'),
                  child: Text(l10n.migrationDialogActionIgnore),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop('merge'),
                  child: Text(l10n.migrationDialogActionMerge),
                ),
              ],
            ),
          );

          if (choice == 'merge') {
            debugPrint("[Migration] Scelta: UNISCI. Avvio migrazione...");

            final userBox = await Hive.openBox<PurchaseModel>(
              'purchases_$newUserId',
            );

            // --- INIZIO LOGICA DI CLONAZIONE ---

            // 1. Creiamo una mappa vuota per ospitare le copie.
            //    La chiave sarà l'ID dell'acquisto (String), il valore l'oggetto clonato (PurchaseModel).
            final Map<String, PurchaseModel> itemsToMigrate = {};

            // 2. Iteriamo su ogni acquisto nel box "ospite".
            for (final oldPurchase in localBox.values) {
              // 3. Creiamo una NUOVA lista di PurchaseItemModel, clonando ogni item.
              final newItems = oldPurchase.items.map((oldItem) {
                return PurchaseItemModel(
                  id: oldItem.id,
                  name: oldItem.name,
                  unitPrice: oldItem.unitPrice,
                  quantity: oldItem.quantity,
                  barcode: oldItem.barcode,
                  imagePath: oldItem.imagePath,
                  isGlutenFree: oldItem.isGlutenFree,
                  unitValue: oldItem.unitValue,
                  unitOfMeasure: oldItem.unitOfMeasure,
                );
              }).toList();

              // 4. Creiamo un NUOVO PurchaseModel usando i dati del vecchio e la nuova lista di item.
              //    Questa è l'istanza "orfana", senza legami con il vecchio box.
              final newPurchase = PurchaseModel(
                id: oldPurchase.id,
                date: oldPurchase.date,
                store: oldPurchase.store,
                total: oldPurchase.total,
                items: newItems,
                currency: oldPurchase.currency,
              );

              // 5. Aggiungiamo il clone alla nostra mappa.
              itemsToMigrate[newPurchase.id] = newPurchase;
            }

            // 6. Ora salviamo la mappa di oggetti CLONATI nel box dell'utente.
            if (itemsToMigrate.isNotEmpty) {
              await userBox.putAll(itemsToMigrate);
            }

            // --- FINE LOGICA DI CLONAZIONE ---

            await localBox.clear();

            debugPrint(
              "[Migration] Dati uniti localmente. Avvio backup sul cloud...",
            );
            await ref.read(syncServiceProvider).backupToCloud();

            ref.invalidate(purchaseListProvider);

            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.migrationSuccess)));
            }
            debugPrint("[Migration] Migrazione completata e backup eseguito.");

            didMergeAndBackup = true;
          } else if (choice == 'delete') {
            debugPrint(
              "[Migration] Scelta: ELIMINA. Cancellazione dati ospite...",
            );
            await localBox.clear();
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.migrationDeleted)));
            }
          } else {
            // 'ignore' o dialogo chiuso
            debugPrint(
              "[Migration] Scelta: IGNORA. Nessuna azione intrapresa.",
            );
          }
        } else {
          debugPrint(
            "[Migration] Box 'purchases_local' trovata ma vuota. Nessuna migrazione necessaria.",
          );
        }
      } finally {
        // Questa parte viene eseguita SEMPRE, sia in caso di successo che di errore.
        if (localBox.isOpen) {
          await localBox.close();
        }
      }
    } else {
      debugPrint(
        "[Migration] Nessuna box 'purchases_local' trovata. Nessuna migrazione necessaria.",
      );
    }

    // A prescindere dal percorso, la funzione ora restituisce sempre un booleano.
    return didMergeAndBackup;
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Glufri',
      navigatorKey:
          navigatorKey, // Fondamentale per accedere al context globale
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // La 'home' è ora sempre il nostro AuthWrapper.
      // `Navigator.pushReplacement` dall'onboarding non distruggerà più
      // il contesto del MaterialApp, rendendo il layout più stabile.
      home: AuthWrapper(hasInitiallySeenOnboarding: widget.hasSeenOnboarding),
      debugShowCheckedModeBanner: false,
    );
  }
}
