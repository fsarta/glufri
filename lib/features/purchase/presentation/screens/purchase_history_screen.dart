import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/backup/domain/user_model.dart';
import 'package:glufri/features/backup/presentation/providers/user_provider.dart';
import 'package:glufri/features/backup/presentation/screens/login_screen.dart';
import 'package:glufri/features/monetization/presentation/providers/monetization_provider.dart';
import 'package:glufri/features/monetization/presentation/widgets/ad_banner_widget.dart';
import 'package:glufri/features/purchase/data/datasources/purchase_local_datasource.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/presentation/providers/cart_provider.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_filter_provider.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_providers.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_detail_screen.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_session_screen.dart';
import 'package:glufri/features/purchase/presentation/widgets/filtered_purchase_item_card.dart';
import 'package:glufri/features/purchase/presentation/widgets/purchase_card.dart';
import 'package:glufri/features/settings/presentation/screens/settings_screen.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

/// La schermata principale dell'app che mostra la cronologia degli acquisti.
///
/// Funzionalità principali:
/// - Mostra una pubblicità banner per gli utenti del piano gratuito.
/// - Fornisce una barra di ricerca per filtrare gli acquisti.
/// - Visualizza la lista di acquisti recuperata dal database locale.
/// - Permette di navigare al dettaglio di un acquisto o di crearne uno nuovo.
class PurchaseHistoryScreen extends ConsumerWidget {
  const PurchaseHistoryScreen({super.key});

  // NUOVA VERSIONE DELLA FUNZIONE DI MIGRAZIONE
  Future<void> _showMigrationDialog(
    BuildContext context,
    WidgetRef ref,
    String newUserId,
  ) async {
    // 1. Controlla se esistono dati locali
    final localBoxName = 'purchases_$localUserId';
    if (!await Hive.boxExists(localBoxName))
      return; // Nessuna box, nessuna azione

    final localBox = await Hive.openBox<PurchaseModel>(localBoxName);

    // Controlla se la box locale contiene effettivamente dei dati
    if (localBox.isEmpty) {
      await localBox.close(); // Chiudi se vuota, nessuna azione
      return;
    }

    if (context.mounted) {
      // 2. Mostra il dialogo di scelta con 3 opzioni
      final choice = await showDialog<String>(
        context: context,
        barrierDismissible: false, // L'utente deve fare una scelta esplicita
        builder: (ctx) => AlertDialog(
          title: const Text('Acquisti Locali Rilevati'),
          content: Text(
            'Hai ${localBox.length} acquisti salvati su questo dispositivo. Cosa vuoi fare?',
          ),
          actions: <Widget>[
            // Tasto "ELIMINA"
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => Navigator.of(ctx).pop('delete'),
              child: const Text('ELIMINA'),
            ),
            const SizedBox(width: 8), // Un po' di spazio
            // Tasto "NO"
            TextButton(
              onPressed: () => Navigator.of(ctx).pop('ignore'),
              child: const Text('NO, LASCIA'),
            ),
            // Tasto "SI" (principale)
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop('merge'),
              child: const Text('SÌ, UNISCI'),
            ),
          ],
        ),
      );

      // 3. Esegui l'azione in base alla scelta
      switch (choice) {
        case 'merge':
          final userBox = await Hive.openBox<PurchaseModel>(
            'purchases_$newUserId',
          );
          final Map<String, PurchaseModel> itemsToMigrate = {};

          // Itera attraverso tutti gli acquisti nella box locale.
          for (final purchase in localBox.values) {
            // 1. Crea una copia "profonda" della lista di PurchaseItemModel.
            // Questo è CRUCIALE perché anche PurchaseItemModel estende HiveObject.
            final newItems = purchase.items
                .map(
                  (item) => PurchaseItemModel(
                    id: item.id,
                    name: item.name,
                    unitPrice: item.unitPrice,
                    quantity: item.quantity,
                    barcode: item.barcode,
                    imagePath: item.imagePath,
                  ),
                )
                .toList();

            // 2. Crea una NUOVA istanza di PurchaseModel usando i dati della vecchia.
            // Questo nuovo oggetto non ha nessuna associazione precedente con una box Hive.
            final newPurchase = PurchaseModel(
              id: purchase.id,
              date: purchase.date,
              store: purchase.store,
              total: purchase.total,
              items: newItems, // Usa la nuova lista di item!
              currency: purchase.currency,
            );

            // 3. Aggiungi il nuovo oggetto pulito alla mappa che verrà migrata.
            // Usiamo l'ID originale come chiave.
            itemsToMigrate[purchase.id] = newPurchase;
          }

          // 4. Ora inserisci tutti gli oggetti appena creati nella box dell'utente.
          // Questo funzionerà perché sono istanze nuove e non legate a nessuna box.
          if (itemsToMigrate.isNotEmpty) {
            await userBox.putAll(itemsToMigrate);
          }

          // Svuota la box locale dopo la migrazione per evitare di chiederlo di nuovo
          await localBox.clear();

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Acquisti locali uniti al tuo account!"),
              ),
            );
          }
          // Forza l'aggiornamento della UI per mostrare i nuovi dati
          ref.invalidate(purchaseListProvider);
          break;

        case 'delete':
          await localBox.clear();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Dati locali eliminati con successo."),
              ),
            );
          }
          break;

        case 'ignore':
        default:
          // Non facciamo nulla, i dati restano lì
          break;
      }
    }
    // Chiudiamo la box in ogni caso per liberare le risorse
    if (localBox.isOpen) {
      await localBox.close();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Aggiungiamo il listener per l'autenticazione
    ref.listen<UserModel?>(userProvider, (previousUser, newUser) {
      // Si attiva quando l'utente esegue il login (da stato null a uno stato con utente)
      if (previousUser == null && newUser != null) {
        // Avvia la logica di migrazione in modo asincrono
        // Usiamo un Future.microtask per assicurarci che la build corrente
        // sia completata prima di mostrare un dialogo.
        Future.microtask(() => _showMigrationDialog(context, ref, newUser.uid));
      }
    });
    // Osserva i provider necessari per la build della UI.
    // `purchaseListProvider` contiene i dati (o lo stato di caricamento/errore).
    final purchasesAsyncValue = ref.watch(purchaseListProvider);
    // `isProUserProvider` determina se mostrare le funzionalità premium (es. nascondere ads).
    final isPro = ref.watch(isProUserProvider);
    final filters = ref.watch(purchaseFilterProvider);
    final user = ref.watch(userProvider);
    final searchQuery = filters.searchQuery;
    final bool isSearchActive = searchQuery.isNotEmpty;

    // `l10n` per le stringhe tradotte.
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.purchaseHistory),
        actions: [
          IconButton(
            tooltip: user != null ? 'Account' : 'Accedi',
            icon: user != null
                ? const Icon(Icons.person_outline_rounded, color: Colors.white)
                : const Icon(Icons.login_rounded, color: Colors.white),
            onPressed: () {
              if (user != null) {
                // Naviga alla pagina dell'account, dove l'utente può fare logout, ecc.
                // Navigator.of(context).push(MaterialPageRoute(builder: (_) => AccountScreen()));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Loggato come ${user.email}')),
                );
              } else {
                // Naviga alla pagina di login/registrazione
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Impostazioni',
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Mostra il banner pubblicitario solo se l'utente NON è Pro.
          // Il widget `AdBannerWidget` gestisce internamente il caricamento
          // e la visualizzazione dell'annuncio.
          if (!isPro) const AdBannerWidget(),

          // 2. Barra di ricerca che aggiorna il provider dei filtri.
          // Ad ogni carattere digitato, `setSearchQuery` viene chiamato,
          // provocando la ri-esecuzione del `purchaseListProvider` con il
          // nuovo filtro di ricerca.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cerca per negozio o prodotto...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onChanged: (query) {
                ref.read(purchaseFilterProvider.notifier).setSearchQuery(query);
              },
            ),
          ),

          // 3. Lista degli acquisti, che occupa tutto lo spazio rimanente.
          // Il `when` di Riverpod gestisce elegantemente i diversi stati del Future.
          Expanded(
            child: purchasesAsyncValue.when(
              // STATO DATI: la lista è stata caricata con successo.
              data: (purchases) {
                // Se la lista è vuota, mostra un messaggio di benvenuto.
                if (purchases.isEmpty) {
                  return Center(
                    child: Text(
                      isSearchActive
                          ? 'Nessun prodotto trovato per "$searchQuery"'
                          : 'Nessun acquisto registrato.\nPremi "+" per iniziare!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                // Se la ricerca NON è attiva, mostra la lista normale
                if (!isSearchActive) {
                  return ListView.builder(
                    itemCount: purchases.length,
                    itemBuilder: (context, index) {
                      final purchase = purchases[index];
                      // Usiamo InkWell per un effetto visivo migliore. Avvolgiamo DIRETTAMENTE la card.
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  PurchaseDetailScreen(purchase: purchase),
                            ),
                          );
                        },
                        child: PurchaseCard(purchase: purchase),
                      );
                    },
                  );
                }

                // Altrimenti, costruisci la lista con `ListView.builder`.
                return ListView.builder(
                  itemCount: purchases.length,
                  itemBuilder: (context, index) {
                    final purchase = purchases[index];
                    // Se la ricerca È attiva, usiamo la `FilteredPurchaseItemCard`.
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) =>
                                PurchaseDetailScreen(purchase: purchase),
                          ),
                        );
                      },
                      child: FilteredPurchaseItemCard(
                        purchase: purchase,
                        searchQuery: searchQuery,
                      ),
                    );
                  },
                );
              },
              // STATO CARICAMENTO: mostra un indicatore di progresso.
              loading: () => const Center(child: CircularProgressIndicator()),
              // STATO ERRORE: mostra un messaggio di errore informativo.
              error: (error, stackTrace) => Center(
                child: Text(
                  'Si è verificato un errore:\n$error',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
      // Pulsante per creare una nuova sessione d'acquisto.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Fondamentale: resetta lo stato del carrello per iniziare una sessione pulita.
          ref.read(cartProvider.notifier).reset();
          // Naviga alla schermata della sessione d'acquisto.
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PurchaseSessionScreen(),
            ),
          );
        },
        label: Text(l10n.newPurchase),
        icon: const Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
