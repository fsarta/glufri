import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/monetization/presentation/providers/monetization_provider.dart';
import 'package:glufri/features/monetization/presentation/widgets/ad_banner_widget.dart';
import 'package:glufri/features/purchase/presentation/providers/cart_provider.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_filter_provider.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_providers.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_detail_screen.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_session_screen.dart';
import 'package:glufri/features/purchase/presentation/widgets/filtered_purchase_item_card.dart';
import 'package:glufri/features/settings/presentation/screens/settings_screen.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Osserva i provider necessari per la build della UI.
    // `purchaseListProvider` contiene i dati (o lo stato di caricamento/errore).
    final purchasesAsyncValue = ref.watch(purchaseListProvider);
    // `isProUserProvider` determina se mostrare le funzionalità premium (es. nascondere ads).
    final isPro = ref.watch(isProUserProvider);
    final filters = ref.watch(purchaseFilterProvider);
    final searchQuery = filters.searchQuery;
    final bool isSearchActive = searchQuery.isNotEmpty;

    // `l10n` per le stringhe tradotte.
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.purchaseHistory),
        actions: [
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
                      // Questa è la vecchia visualizzazione (ListTile semplice)
                      return ListTile(
                        title: Text(purchase.smartTitle),
                        subtitle: Text(
                          DateFormat(
                            'dd/MM/yyyy HH:mm:ss',
                          ).format(purchase.date),
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        trailing: Text(
                          '${purchase.total.toStringAsFixed(2)} ${purchase.currency}',
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  PurchaseDetailScreen(purchase: purchase),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                // Altrimenti, costruisci la lista con `ListView.builder`.
                return ListView.builder(
                  itemCount: purchases.length,
                  itemBuilder: (context, index) {
                    final purchase = purchases[index];
                    /* return ListTile(
                      title: Text(purchase.store ?? 'Acquisto Sconosciuto'),
                      subtitle: Text(
                        DateFormat.yMMMd(l10n.localeName).format(purchase.date),
                      ),
                      trailing: Text(
                        '${purchase.total.toStringAsFixed(2)} ${purchase.currency}',
                      ),
                      onTap: () {
                        // Naviga alla schermata di dettaglio passando l'oggetto `purchase`.
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) =>
                                PurchaseDetailScreen(purchase: purchase),
                          ),
                        );
                      },
                    ); */
                    return GestureDetector(
                      onTap: () {
                        // Permette di cliccare sulla card per vedere i dettagli
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
