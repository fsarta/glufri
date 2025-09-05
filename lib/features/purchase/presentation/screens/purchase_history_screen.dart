// lib/features/purchase/presentation/screens/purchase_history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/backup/presentation/providers/user_provider.dart';
import 'package:glufri/features/backup/presentation/screens/login_screen.dart';
import 'package:glufri/features/monetization/presentation/providers/monetization_provider.dart';
import 'package:glufri/features/monetization/presentation/widgets/ad_banner_widget.dart';
import 'package:glufri/features/purchase/presentation/models/purchase_group_models.dart';
import 'package:glufri/features/purchase/presentation/providers/cart_provider.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_filter_provider.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_providers.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_detail_screen.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_session_screen.dart';
import 'package:glufri/features/purchase/presentation/widgets/filtered_purchase_item_card.dart';
import 'package:glufri/features/purchase/presentation/widgets/purchase_card.dart';
import 'package:glufri/features/scanner/presentation/screens/barcode_scanner_screen.dart';
import 'package:glufri/features/settings/presentation/screens/settings_screen.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;

/// La schermata principale dell'app che mostra la cronologia degli acquisti.
///
/// Funzionalità principali:
/// - Mostra una pubblicità banner per gli utenti del piano gratuito.
/// - Fornisce una barra di ricerca per filtrare gli acquisti.
/// - Visualizza la lista di acquisti recuperata dal database locale.
/// - Permette di navigare al dettaglio di un acquisto o di crearne uno nuovo.
class PurchaseHistoryScreen extends ConsumerStatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  ConsumerState<PurchaseHistoryScreen> createState() =>
      _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends ConsumerState<PurchaseHistoryScreen> {
  // Creiamo un controller per poter modificare il testo programmaticamente
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Sincronizziamo lo stato del provider con il controller all'inizio
    _searchController.text = ref.read(purchaseFilterProvider).searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Osserva i provider necessari per la build della UI.
    // `purchaseListProvider` contiene i dati (o lo stato di caricamento/errore).
    final groupedPurchases = ref.watch(groupedPurchaseProvider);
    final purchasesAsyncValue = ref.watch(purchaseListProvider);
    // `isProUserProvider` determina se mostrare le funzionalità premium (es. nascondere ads).
    final isPro = ref.watch(isProUserProvider);
    final filters = ref.watch(purchaseFilterProvider);
    final user = ref.watch(userProvider);
    final searchQuery = filters.searchQuery;
    final bool isSearchActive = filters.searchQuery.isNotEmpty;
    final isDateFilterActive = filters.dateRange != null;

    // `l10n` per le stringhe tradotte.
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.purchaseHistory),
        actions: [
          IconButton(
            tooltip: 'Filtra per data', // TODO: Localizza questa stringa
            icon: badges.Badge(
              showBadge: isDateFilterActive,
              child: const Icon(Icons.calendar_month_outlined),
            ),
            onPressed: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: filters.dateRange,
              );

              if (range != null) {
                ref.read(purchaseFilterProvider.notifier).setDateRange(range);
              }
            },
          ),
          // Pulsante per cancellare il filtro (appare solo se il filtro è attivo)
          if (isDateFilterActive)
            IconButton(
              tooltip: 'Rimuovi filtro data', // TODO: Localizza
              icon: const Icon(Icons.filter_alt_off_outlined),
              onPressed: () {
                ref.read(purchaseFilterProvider.notifier).clearDateRange();
              },
            ),
          IconButton(
            tooltip: user != null ? l10n.account : l10n.login,
            icon: user != null
                ? const Icon(Icons.person_outline_rounded, color: Colors.white)
                : const Icon(Icons.login_rounded, color: Colors.white),
            onPressed: () {
              if (user != null) {
                // Naviga alla pagina dell'account, dove l'utente può fare logout, ecc.
                // Navigator.of(context).push(MaterialPageRoute(builder: (_) => AccountScreen()));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.loggedInAs(user.email!))),
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
            tooltip: l10n.settings,
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
          if (!ref.watch(isProUserProvider)) const AdBannerWidget(),

          // 2. Barra di ricerca che aggiorna il provider dei filtri.
          // Ad ogni carattere digitato, `setSearchQuery` viene chiamato,
          // provocando la ri-esecuzione del `purchaseListProvider` con il
          // nuovo filtro di ricerca.
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchPlaceholder,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  tooltip: l10n.scanBarcode, // Aggiungi la traduzione se manca
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () async {
                    // Avvia lo scanner
                    final barcode = await Navigator.of(context).push<String>(
                      MaterialPageRoute(
                        builder: (_) => const BarcodeScannerScreen(),
                      ),
                    );

                    // Se lo scanner restituisce un codice
                    if (barcode != null && barcode.isNotEmpty) {
                      // Aggiorna sia il controller della UI che il provider dello stato
                      _searchController.text = barcode;
                      ref
                          .read(purchaseFilterProvider.notifier)
                          .setSearchQuery(barcode);
                    }
                  },
                ),
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
              // STATO CARICAMENTO: mostra un indicatore di progresso.
              loading: () => const Center(child: CircularProgressIndicator()),
              // STATO ERRORE: mostra un messaggio di errore informativo.
              error: (error, stackTrace) => Center(
                child: Text(
                  l10n.genericError(error),
                  textAlign: TextAlign.center,
                ),
              ),
              data: (_) {
                final isSearchActive = ref
                    .watch(purchaseFilterProvider)
                    .searchQuery
                    .isNotEmpty;

                // --- INIZIA LA MODIFICA CHIAVE ---

                // Definiamo il widget della lista che vogliamo mostrare
                final listContent = _buildListContent(ref, isSearchActive);

                // Avvolgiamo la nostra logica della lista nel RefreshIndicator
                return RefreshIndicator(
                  // La funzione onRefresh deve essere un Future.
                  // invalidare un provider è un'operazione sincrona, ma
                  // il refresh completo dei dati avverrà in modo asincrono.
                  onRefresh: () async {
                    // Questa singola riga dice a Riverpod di ricaricare i dati.
                    ref.invalidate(purchaseListProvider);

                    // Attendiamo che il nuovo stato del Future sia disponibile.
                    // Questo assicura che l'indicatore di caricamento
                    // rimanga visibile fino alla fine del fetch dei dati.
                    await ref.read(purchaseListProvider.future);
                  },
                  child: listContent,
                );
              },
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

  Widget _buildListContent(WidgetRef ref, bool isSearchActive) {
    // Questa è la logica if/else che avevi già nel blocco 'data'
    if (isSearchActive) {
      final searchResults = ref.watch(searchedProductsSummaryProvider);
      final l10n = AppLocalizations.of(ref.context)!;
      if (searchResults.isEmpty) {
        return Center(
          child: Text(
            l10n.noProductsFoundFor(
              ref.read(purchaseFilterProvider).searchQuery,
            ),
          ),
        );
      }
      return ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          return _SearchedProductSummaryCard(summary: searchResults[index]);
        },
      );
    } else {
      final groupedPurchases = ref.watch(groupedPurchaseProvider);
      final l10n = AppLocalizations.of(ref.context)!;
      if (groupedPurchases.isEmpty) {
        return Center(child: Text(l10n.noPurchases));
      }
      return ListView.builder(
        itemCount: groupedPurchases.length,
        itemBuilder: (context, index) {
          final yearGroup = groupedPurchases[index];
          final filters = ref.watch(purchaseFilterProvider);
          return _YearlyGroupView(
            yearGroup: yearGroup,
            isSearchActive: false,
            searchQuery: filters.searchQuery,
          );
        },
      );
    }
  }
}

/// Un widget per visualizzare un intero gruppo annuale con mesi espandibili.
class _YearlyGroupView extends StatelessWidget {
  final YearlyPurchaseGroup yearGroup;
  final bool isSearchActive;
  final String searchQuery;

  const _YearlyGroupView({
    required this.yearGroup,
    required this.isSearchActive,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ExpansionTile(
        initiallyExpanded: isSearchActive,
        // Il titolo è l'header dell'anno
        title: _GroupHeader(
          title: yearGroup.year.toString(),
          totalGf: yearGroup.totalGlutenFree,
          totalRegular: yearGroup.totalRegular,
          totalOverall: yearGroup.totalOverall,
          isYear: true,
        ),
        // I figli sono i mesi di quell'anno
        children: yearGroup.months.map((monthGroup) {
          return _MonthlyGroupView(
            monthGroup: monthGroup,
            isSearchActive: isSearchActive,
            searchQuery: searchQuery,
          );
        }).toList(),
      ),
    );
  }
}

/// Un widget per visualizzare un gruppo mensile con gli acquisti espandibili.
class _MonthlyGroupView extends StatelessWidget {
  final MonthlyPurchaseGroup monthGroup;
  final bool isSearchActive;
  final String searchQuery;

  const _MonthlyGroupView({
    required this.monthGroup,
    required this.isSearchActive,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Formatta il nome del mese nella lingua corretta
    final monthName = DateFormat.MMMM(
      l10n.localeName,
    ).format(DateTime(monthGroup.year, monthGroup.month));

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
      child: ExpansionTile(
        initiallyExpanded: isSearchActive,
        title: _GroupHeader(
          title: monthName,
          totalGf: monthGroup.totalGlutenFree,
          totalRegular: monthGroup.totalRegular,
          totalOverall: monthGroup.totalOverall,
        ),
        // I figli sono le card degli acquisti di quel mese
        children: monthGroup.purchases.map((purchase) {
          final Widget cardToShow;
          if (isSearchActive) {
            // Se la ricerca è attiva, mostra solo i risultati filtrati
            cardToShow = FilteredPurchaseItemCard(
              purchase: purchase,
              searchQuery: searchQuery,
            );
          } else {
            // Altrimenti, la card normale
            cardToShow = PurchaseCard(purchase: purchase);
          }
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PurchaseDetailScreen(purchaseId: purchase.id),
                ),
              );
            },
            // Usiamo la nostra PurchaseCard esistente!
            child: cardToShow,
          );
        }).toList(),
      ),
    );
  }
}

/// Un widget riutilizzabile per mostrare il titolo e i totali per anni e mesi.
class _GroupHeader extends StatelessWidget {
  final String title;
  final double totalGf;
  final double totalRegular;
  final double totalOverall;
  final bool isYear;

  const _GroupHeader({
    required this.title,
    required this.totalGf,
    required this.totalRegular,
    required this.totalOverall,
    this.isYear = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final titleStyle = isYear
        ? theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
        : theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600);

    final totalStyle = isYear
        ? theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
        : theme.textTheme.bodyMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${l10n.totalOverall}:', style: totalStyle),
            Text(
              '${totalOverall.toStringAsFixed(2)} €',
              style: totalStyle?.copyWith(color: theme.colorScheme.primary),
            ),
          ],
        ),
        if (totalGf > 0 || totalRegular > 0) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${l10n.glutenFree}:', style: theme.textTheme.bodySmall),
              Text(
                '${totalGf.toStringAsFixed(2)} €',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${l10n.other}:', style: theme.textTheme.bodySmall),
              Text(
                '${totalRegular.toStringAsFixed(2)} €',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// --- AGGIUNGI QUESTO NUOVO WIDGET ALLA FINE DEL FILE ---
class _SearchedProductSummaryCard extends StatelessWidget {
  final SearchedProductSummary summary;
  const _SearchedProductSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              summary.productName,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${l10n.totalOverall}: ${summary.totalSpent.toStringAsFixed(2)} €',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            Text(
              '${l10n.quantity}: ${summary.totalQuantity.toStringAsFixed(2)} (${l10n.productsCount(summary.purchaseCount)})',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        children: summary.items.map((item) {
          final purchase = summary.purchaseContext[item.id]!;
          return ListTile(
            title: Text('${purchase.store ?? l10n.genericPurchase}'),
            subtitle: Text(
              DateFormat.yMd(l10n.localeName).format(purchase.date),
            ),
            trailing: Text('${item.subtotal.toStringAsFixed(2)} €'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PurchaseDetailScreen(purchaseId: purchase.id),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
