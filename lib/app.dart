import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/core/utils/navigator_key.dart';
import 'package:glufri/features/backup/domain/user_model.dart';
import 'package:glufri/features/backup/presentation/providers/user_provider.dart';
import 'package:glufri/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:glufri/features/purchase/data/datasources/purchase_local_datasource.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_providers.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_history_screen.dart';
import 'package:glufri/features/settings/presentation/providers/settings_provider.dart';

// --- I due import che risolvono gli errori ---
import 'package:glufri/core/config/app_theme.dart';
import 'package:hive/hive.dart';
// ------------------------------------------

class GlufriApp extends ConsumerWidget {
  final bool hasSeenOnboarding;

  const GlufriApp({super.key, required this.hasSeenOnboarding});

  Future<void> _showMigrationDialog(WidgetRef ref, String newUserId) async {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return;

    bool localDataFound = false;
    final localBoxName = 'purchases_$localUserId';

    if (await Hive.boxExists(localBoxName)) {
      final localBox = await Hive.openBox<PurchaseModel>(localBoxName);
      if (localBox.isNotEmpty) {
        localDataFound = true;

        // Il resto della logica del dialogo è IDENTICA
        final choice = await showDialog<String>(
          context: navigator.context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Acquisti Locali Rilevati'),
            content: Text(
              'Hai ${localBox.length} acquisti salvati. Cosa vuoi fare?',
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(
                    navigator.context,
                  ).colorScheme.error,
                ),
                onPressed: () => Navigator.of(ctx).pop('delete'),
                child: const Text('ELIMINA'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop('ignore'),
                child: const Text('NO, LASCIA'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop('merge'),
                child: const Text('SÌ, UNISCI'),
              ),
            ],
          ),
        );

        switch (choice) {
          case 'merge':
            // Usa la logica di deep-copy che abbiamo corretto prima
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

            ScaffoldMessenger.of(navigator.context).showSnackBar(
              const SnackBar(
                content: Text("Acquisti locali uniti al tuo account!"),
              ),
            );
            ref.invalidate(purchaseListProvider);
            break;
          case 'delete':
            await localBox.clear();
            ScaffoldMessenger.of(navigator.context).showSnackBar(
              const SnackBar(
                content: Text("Dati locali eliminati con successo."),
              ),
            );
            break;
          case 'ignore':
          default:
            break;
        }
        if (localBox.isOpen) await localBox.close();
      } else {
        if (localBox.isOpen) await localBox.close();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<UserModel?>(userProvider, (previousUser, newUser) {
      if (previousUser == null && newUser != null) {
        Future.microtask(() => _showMigrationDialog(ref, newUser.uid));
      }
    });
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Glufri',
      navigatorKey: navigatorKey,
      // Ora `AppTheme` è definito e queste righe non danno più errore
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      locale: locale,

      // Ora `AppLocalizations` è definito e queste righe non danno più errore
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      home: hasSeenOnboarding
          ? const PurchaseHistoryScreen()
          : const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
