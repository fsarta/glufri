// lib/features/monetization/presentation/screens/upsell_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/monetization/presentation/providers/monetization_provider.dart';

class UpsellScreen extends ConsumerWidget {
  const UpsellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      // Usiamo una SliverAppBar per un effetto più elegante allo scroll
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(l10n.upsellTitle),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primaryContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.star_purple500_outlined,
                  size: 100,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.upsellHeadline,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.upsellSubtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 32),

                  // --- LISTA DETTAGLIATA DELLE FEATURE ---
                  _FeatureDetail(
                    icon: Icons.cloud_sync_rounded,
                    title: l10n.proFeatureTitleBackup,
                    body: l10n.proFeatureBodyBackup,
                  ),
                  _FeatureDetail(
                    icon: Icons.list_alt_rounded,
                    title: l10n.proFeatureTitleLists,
                    body: l10n.proFeatureBodyLists,
                  ),
                  _FeatureDetail(
                    icon: Icons.favorite_rounded,
                    title: l10n.proFeatureTitleFavorites,
                    body: l10n.proFeatureBodyFavorites,
                  ),
                  _FeatureDetail(
                    icon: Icons.assessment_rounded,
                    title: l10n.proFeatureTitleBudget,
                    body: l10n.proFeatureBodyBudget,
                  ),
                  _FeatureDetail(
                    icon: Icons.science_rounded,
                    title: l10n.proFeatureTitleDetails,
                    body: l10n.proFeatureBodyDetails,
                  ),
                  _FeatureDetail(
                    icon: Icons.history_toggle_off_rounded,
                    title: l10n.proFeatureTitleHistory,
                    body: l10n.proFeatureBodyHistory,
                  ),
                  _FeatureDetail(
                    icon: Icons.document_scanner_rounded,
                    title: l10n.proFeatureTitleExport,
                    body: l10n.proFeatureBodyExport,
                  ),
                  _FeatureDetail(
                    icon: Icons.hdr_off_rounded,
                    title: l10n.proFeatureTitleNoAds,
                    body: l10n.proFeatureBodyNoAds,
                  ),

                  const SizedBox(height: 32),
                  // -- TABELLA RIASSUNTIVA --
                  Text(
                    l10n.comparisonTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _buildComparisonTable(l10n, theme),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      // Manteniamo i bottoni fissi in basso
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  l10n.upsellAction,
                  style: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  ref.read(monetizationProvider.notifier).purchasePro();
                },
              ),
              TextButton(
                child: Text(l10n.upsellRestore),
                onPressed: () {
                  // Aggiungere logica di restore purchases
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget helper per le card delle feature
class _FeatureDetail extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _FeatureDetail({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget helper per costruire la tabella
Widget _buildComparisonTable(AppLocalizations l10n, ThemeData theme) {
  return Table(
    border: TableBorder.all(
      color: theme.dividerColor,
      borderRadius: BorderRadius.circular(8),
    ),
    columnWidths: const {
      0: FlexColumnWidth(2), // Feature più larga
      1: FlexColumnWidth(1), // Free
      2: FlexColumnWidth(1), // Pro
    },
    children: [
      TableRow(
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        children: [
          _tableHeader(l10n.featureHeader, textAlign: TextAlign.start),
          _tableHeader(l10n.freeHeader),
          _tableHeader(l10n.proHeader, isPro: true),
        ],
      ),
      _tableRow(l10n.proFeatureTitleBackup, "❌", "✔️"),
      _tableRow(l10n.proFeatureTitleLists, "❌", "✔️"),
      _tableRow(l10n.proFeatureTitleFavorites, "❌", "✔️"),
      _tableRow(l10n.proFeatureTitleBudget, "❌", "✔️"),
      _tableRow(l10n.proFeatureTitleDetails, "❌", "✔️"),
      _tableRow(l10n.proFeatureTitleHistory, "❌", "✔️"),
      _tableRow(l10n.proFeatureTitleExport, "❌", "✔️"),
      _tableRow(
        l10n.proFeatureTitleNoAds,
        "Con annunci",
        "✔️",
      ), // testo diverso per free
    ],
  );
}

TableRow _tableRow(
  String feature,
  String freeValue,
  String proValue, {
  bool isLast = false,
}) {
  return TableRow(
    children: [
      Padding(padding: const EdgeInsets.all(12.0), child: Text(feature)),
      Center(child: Text(freeValue, style: const TextStyle(fontSize: 18))),
      Center(
        child: Text(
          proValue,
          style: const TextStyle(fontSize: 18, color: Colors.green),
        ),
      ),
    ],
  );
}

Widget _tableHeader(
  String text, {
  TextAlign textAlign = TextAlign.center,
  bool isPro = false,
}) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: isPro ? Colors.green.shade800 : null,
      ),
    ),
  );
}
