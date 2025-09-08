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
import 'package:glufri/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:glufri/features/purchase/data/datasources/purchase_local_datasource.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_providers.dart';
import 'package:glufri/features/settings/presentation/providers/settings_provider.dart';
import 'package:glufri/features/shell/presentation/screens/main_shell_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

        // Avvia il flusso post-login: ripristino cloud e/o migrazione locale.
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
      }
    });
  }

  /// Orchestra le operazioni da eseguire dopo un login (ripristino/migrazione).
  Future<void> _handlePostLoginFlow(BuildContext context, String userId) async {
    // 1. IMPOSTA LO STATO GLOBALE DI CARICAMENTO SU 'TRUE'
    // `.notifier` ci dà accesso al controller, `.state` lo modifica
    ref.read(syncInProgressProvider.notifier).state = true;

    debugPrint('[PostLoginFlow] syncInProgressProvider impostato a true');

    try {
      final restoredCount = await ref
          .read(syncServiceProvider)
          .restoreFromCloudAndGetCount();
      debugPrint(
        '[PostLoginFlow] Restore completato. Conteggio: $restoredCount',
      );

      ref.invalidate(purchaseListProvider);
      debugPrint('[PostLoginFlow] purchaseListProvider invalidato.');

      // La logica di migrazione rimane, ma non ha bisogno del context ora.
      if (restoredCount == 0) {
        debugPrint(
          '[PostLoginFlow] Nessun dato nel cloud. Controllo dati locali.',
        );
        await _showMigrationDialog(userId);
      } else {
        debugPrint(
          '[PostLoginFlow] Trovati dati nel cloud. Salto la migrazione locale.',
        );
      }
    } catch (e) {
      debugPrint('[PostLoginFlow] *** ERRORE CATTURATO: $e ***');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Errore di sincronizzazione."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // 2. IN OGNI CASO, ALLA FINE, RIPORTA LO STATO A 'FALSE'
      // `mounted` è un controllo di sicurezza per le operazioni async.
      if (mounted) {
        ref.read(syncInProgressProvider.notifier).state = false;
        debugPrint('[PostLoginFlow] syncInProgressProvider impostato a false');
      }
    }
  }

  /// Mostra il dialogo per la migrazione dei dati locali, se presenti.
  Future<void> _showMigrationDialog(String newUserId) async {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final l10n = AppLocalizations.of(context)!;
    final localBoxName = 'purchases_$localUserId';

    if (await Hive.boxExists(localBoxName)) {
      final localBox = await Hive.openBox<PurchaseModel>(localBoxName);
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
          // Logica di "deep copy" per evitare errori di Hive
          final userBox = await Hive.openBox<PurchaseModel>(
            'purchases_$newUserId',
          );
          final Map<String, PurchaseModel> itemsToMigrate = {};
          for (final purchase in localBox.values) {
            final newItems = purchase.items
                .map(
                  (item) => PurchaseItemModel(
                    id: item.id,
                    name: item.name,
                    unitPrice: item.unitPrice,
                    quantity: item.quantity,
                    barcode: item.barcode,
                    imagePath: item.imagePath,
                    isGlutenFree: item.isGlutenFree,
                  ),
                )
                .toList();
            final newPurchase = PurchaseModel(
              id: purchase.id,
              date: purchase.date,
              store: purchase.store,
              total: purchase.total,
              items: newItems,
              currency: purchase.currency,
            );
            itemsToMigrate[purchase.id] = newPurchase;
          }

          if (itemsToMigrate.isNotEmpty) {
            await userBox.putAll(itemsToMigrate);
          }
          await localBox.clear();

          if (context.mounted)
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.migrationSuccess)));

          ref.invalidate(purchaseListProvider);
        }

        if (choice == 'delete') {
          await localBox.clear();
          if (context.mounted)
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.migrationDeleted)));
        }
      }

      if (localBox.isOpen) {
        await localBox.close();
      }
    }
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
      // La schermata 'home' dipende da se l'utente ha già visto l'onboarding
      home: widget.hasSeenOnboarding
          ? const MainShellScreen()
          : const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
