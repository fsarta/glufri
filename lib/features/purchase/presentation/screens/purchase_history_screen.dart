// lib/features/purchase/presentation/screens/purchase_history_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/core/widgets/month_picker.dart';
import 'package:glufri/core/widgets/skeletons/shimmer_list.dart';
import 'package:glufri/core/widgets/skeletons/skeleton_card.dart';
import 'package:glufri/features/backup/domain/sync_service.dart';
import 'package:glufri/features/backup/presentation/providers/sync_providers.dart';
import 'package:glufri/features/backup/presentation/providers/user_provider.dart';
import 'package:glufri/features/backup/presentation/screens/login_screen.dart';
import 'package:glufri/features/monetization/presentation/providers/monetization_provider.dart';
import 'package:glufri/features/monetization/presentation/screens/upsell_screen.dart';
import 'package:glufri/features/monetization/presentation/widgets/ad_banner_widget.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/domain/services/pdf_export_service.dart';
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
import 'package:printing/printing.dart';

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
    // Sincronizza lo stato del provider con il controller all'inizio
    final initialQuery = ref.read(purchaseFilterProvider).searchQuery;
    _searchController.text = initialQuery;

    // Aggiungi un listener per mostrare/nascondere la X
    _searchController.addListener(() {
      setState(() {}); // Forza un rebuild per aggiornare la UI della X
    });
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
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Text(l10n!.purchaseHistory),
        actions: [
          IconButton(
            tooltip: 'Esporta Report', // TODO: Localizza
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () {
              // Controlla se l'utente è PRO prima di mostrare il menu
              if (!ref.read(isProUserProvider)) {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const UpsellScreen()));
                return;
              }
              _showExportOptions(context, ref);
            },
          ),
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
          /* IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settings,
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ), */
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
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize
                      .min, // La Row occupa solo lo spazio necessario
                  children: [
                    // Icona "X" per cancellare
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref
                              .read(purchaseFilterProvider.notifier)
                              .setSearchQuery('');
                        },
                      ),
                    // Icona dello scanner
                    IconButton(
                      tooltip: l10n.scanBarcode,
                      icon: const Icon(Icons.qr_code_scanner),
                      onPressed: () async {
                        // la logica dello scanner rimane identica
                      },
                    ),
                  ],
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
              loading: () =>
                  const ShimmerList(skeletonCard: PurchaseCardSkeleton()),
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
                  onRefresh: () async {
                    // 1. Leggi i provider necessari per la logica
                    final user = ref.read(userProvider);
                    final isPro = ref.read(isProUserProvider);
                    final l10n = AppLocalizations.of(context)!;

                    // 2. Esegui la sincronizzazione solo se l'utente è loggato e Pro
                    if (user != null && isPro) {
                      // 3. Mostra l'indicatore di caricamento globale
                      ref.read(syncInProgressProvider.notifier).state = true;
                      try {
                        // 4. Chiama il servizio di sync per scaricare i dati dal cloud
                        await ref.read(syncServiceProvider).restoreFromCloud();
                      } catch (e) {
                        // In caso di errore (es. offline), mostra un messaggio
                        debugPrint('Errore di sincronizzazione manuale: $e');
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.syncError),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } finally {
                        // 5. In ogni caso, nascondi l'indicatore di caricamento
                        if (mounted) {
                          ref.read(syncInProgressProvider.notifier).state =
                              false;
                        }
                      }
                    }

                    // 6. ALLA FINE, invalida il provider locale. La UI si aggiornerà
                    //    con i dati appena scaricati (o con quelli vecchi se la sync fallisce).
                    ref.invalidate(purchaseListProvider);
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
        heroTag: 'purchase_history_fab',
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

class _SearchedProductSummaryCard extends StatelessWidget {
  final SearchedProductSummary summary;
  const _SearchedProductSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Determiniamo se si tratta di un singolo acquisto o di acquisti multipli
    final isSinglePurchase = summary.purchaseCount == 1;
    final singleItem = isSinglePurchase ? summary.items.first : null;

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
            if (isSinglePurchase && singleItem != null) ...[
              // CASO 1: UN SINGOLO ACQUISTO
              // Mostriamo Quantità x Prezzo Unitario = Subtotale
              Text.rich(
                TextSpan(
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                  children: [
                    TextSpan(
                      text:
                          '${singleItem.quantity.toString()} x ${singleItem.unitPrice.toStringAsFixed(2)} € = ',
                    ),
                    TextSpan(
                      text: '${singleItem.subtotal.toStringAsFixed(2)} €',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // CASO 2: ACQUISTI MULTIPLI
              // Mostriamo il totale speso
              Text(
                '${l10n.totalOverall}: ${summary.totalSpent.toStringAsFixed(2)} €',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if (!isSinglePurchase)
              Text(
                '${l10n.quantity}: ${summary.totalQuantity.toStringAsFixed(2)} (${l10n.productsCount(summary.purchaseCount)})',
                style: theme.textTheme.bodySmall,
              )
            else if (singleItem !=
                null) // Se è un acquisto singolo, mostriamo dove
              Text(
                '${summary.purchaseContext[singleItem.id]?.store ?? l10n.genericPurchase} - ${DateFormat.yMd(l10n.localeName).format(summary.purchaseContext[singleItem.id]!.date)}',
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),

        // La parte espandibile (children) appare solo se ci sono acquisti multipli.
        // Se c'è un solo acquisto, il titolo mostra già tutte le info.
        children: isSinglePurchase
            ? [] // Non mostrare nulla se l'acquisto è singolo
            : summary.items.map((item) {
                final purchase = summary.purchaseContext[item.id]!;
                return ListTile(
                  title: Text('${purchase.store ?? l10n.genericPurchase}'),
                  subtitle: Text(
                    DateFormat.yMd(l10n.localeName).format(purchase.date),
                  ),
                  trailing: Text.rich(
                    // Usiamo Text.rich anche qui per chiarezza
                    TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text:
                              '${item.quantity.toString()} x ${item.unitPrice.toStringAsFixed(2)} = ',
                        ),
                        TextSpan(
                          text: '${item.subtotal.toStringAsFixed(2)} €',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            PurchaseDetailScreen(purchaseId: purchase.id),
                      ),
                    );
                  },
                );
              }).toList(),
      ),
    );
  }
}

// Funzione che mostra il BottomSheet con le opzioni
void _showExportOptions(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;

  showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Esporta Report Mensile'), // TODO: Localizza
              onTap: () {
                Navigator.of(ctx).pop();
                _selectAndExportMonth(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_view_week),
              title: const Text('Esporta Report Annuale'), // TODO: Localizza
              onTap: () {
                Navigator.of(ctx).pop();
                _selectAndExportYear(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.select_all),
              title: const Text('Report Completo'), // TODO: Localizza
              onTap: () {
                Navigator.of(ctx).pop();
                final allPurchases =
                    ref.read(purchaseListProvider).valueOrNull ?? [];
                _exportPurchases(
                  context,
                  allPurchases,
                  l10n.pdfReportTitleComplete,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

// Guida l'utente nella selezione di ANNO e MESE
Future<void> _selectAndExportMonth(BuildContext context, WidgetRef ref) async {
  // 1. Seleziona l'anno
  final now = DateTime.now();
  final selectedYear = await showDialog<int>(
    context: context,
    builder: (ctx) => AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: SizedBox(
        height: 300,
        width: 300,
        child: YearPicker(
          firstDate: DateTime(2020),
          lastDate: now,
          selectedDate: DateTime(now.year),
          onChanged: (dateTime) => Navigator.of(ctx).pop(dateTime.year),
        ),
      ),
    ),
  );

  if (selectedYear == null || !context.mounted) return;

  // 2. Seleziona il mese, usando il nostro helper
  final selectedMonth = await showMonthPicker(
    context: context,
    initialYear: selectedYear,
  );

  if (selectedMonth == null || !context.mounted) return;

  // 3. Filtra i dati e avvia l'esportazione
  final allPurchases = ref.read(purchaseListProvider).valueOrNull ?? [];
  final monthPurchases = allPurchases
      .where(
        (p) => p.date.year == selectedYear && p.date.month == selectedMonth,
      )
      .toList();

  final titleDate = DateTime(selectedYear, selectedMonth);
  final title =
      "Report Spese - ${DateFormat.yMMMM('it_IT').format(titleDate)}"; // TODO: Usa l10n.localeName

  _exportPurchases(context, monthPurchases, title);
}

// Guida l'utente nella selezione dell'ANNO
Future<void> _selectAndExportYear(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;

  final now = DateTime.now();
  final selectedYear = await showDialog<int>(
    context: context,
    builder: (ctx) => AlertDialog(
      content: SizedBox(
        height: 300,
        width: 300,
        child: YearPicker(
          firstDate: DateTime(2020),
          lastDate: now,
          selectedDate: DateTime(now.year),
          onChanged: (dateTime) => Navigator.of(ctx).pop(dateTime.year),
        ),
      ),
    ),
  );

  if (selectedYear == null || !context.mounted) return;

  final allPurchases = ref.read(purchaseListProvider).valueOrNull ?? [];
  final yearPurchases = allPurchases
      .where((p) => p.date.year == selectedYear)
      .toList();

  final title = l10n.pdfReportTitleAnnual(selectedYear.toString());
  _exportPurchases(context, yearPurchases, title);
}

// Funzione che raccoglie i dati e genera il PDF
Future<void> _exportPurchases(
  BuildContext context,
  List<PurchaseModel> purchases,
  String title,
) async {
  final l10n = AppLocalizations.of(context)!;

  // Mostra un caricamento
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final pdfData = await PdfExportService().generatePurchaseReport(
      title: title,
      purchases: purchases,
    );

    // Chiudi il caricamento
    Navigator.of(context, rootNavigator: true).pop();

    // Mostra l'anteprima di stampa/condivisione
    await Printing.layoutPdf(onLayout: (format) => pdfData);
  } catch (e) {
    // Chiudi il caricamento in caso di errore
    Navigator.of(context, rootNavigator: true).pop();
    // Mostra errore
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.pdfCreationError),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Funzione per esportare il report del MESE corrente
void _exportCurrentMonthReport(BuildContext context, WidgetRef ref) {
  final now = DateTime.now();
  final allPurchases = ref.read(purchaseListProvider).valueOrNull ?? [];

  final monthPurchases = allPurchases
      .where((p) => p.date.year == now.year && p.date.month == now.month)
      .toList();

  final title =
      "Report Spese - ${DateFormat.yMMMM('it_IT').format(now)}"; // TODO: Usa l10n.localeName
  _exportPurchases(context, monthPurchases, title);
}

// Funzione per esportare il report dell'ANNO corrente
void _exportCurrentYearReport(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;

  final now = DateTime.now();
  final allPurchases = ref.read(purchaseListProvider).valueOrNull ?? [];

  final yearPurchases = allPurchases
      .where((p) => p.date.year == now.year)
      .toList();

  final title = l10n.pdfReportTitleAnnual(now.year.toString());
  _exportPurchases(context, yearPurchases, title);
}

// Funzione per esportare TUTTI gli acquisti
void _exportFullReport(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;

  final allPurchases = ref.read(purchaseListProvider).valueOrNull ?? [];
  final title = l10n.pdfReportTitleComplete;
  _exportPurchases(context, allPurchases, title);
}
