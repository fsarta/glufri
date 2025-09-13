// lib/features/budget/presentation/screens/budget_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/backup/domain/sync_service.dart';
import 'package:glufri/features/budget/data/models/budget_model.dart';
import 'package:glufri/features/budget/presentation/providers/budget_providers.dart';
import 'package:intl/intl.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  final _gfController = TextEditingController();
  final _totalController = TextEditingController();

  @override
  void dispose() {
    _gfController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Assicurati che l'italiano (o altre lingue) sia inizializzato in main.dart
    final monthName = DateFormat.yMMMM(
      Localizations.localeOf(context).languageCode,
    ).format(DateTime.now());

    // Osserviamo i provider
    final budgetAsync = ref.watch(currentMonthBudgetProvider);
    final spending = ref.watch(currentMonthSpendingProvider(null));

    // `ref.listen` è il modo giusto per reagire a un cambiamento di stato
    // asincrono per aggiornare i controller, che sono parte dello State del widget.
    ref.listen<AsyncValue<BudgetModel?>>(currentMonthBudgetProvider, (
      _,
      state,
    ) {
      state.whenData((budget) {
        if (mounted) {
          // Controlla sempre `mounted` in listener asincroni
          _gfController.text = budget?.glutenFreeBudget?.toString() ?? '';
          _totalController.text = budget?.totalBudget?.toString() ?? '';
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: Text('Budget di $monthName'), // TODO: Localizza
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: budgetAsync.isLoading
                ? null
                : _saveBudget, // Disabilita durante il caricamento
            tooltip: 'Salva Budget', // TODO: Localizza
          ),
        ],
      ),
      body: budgetAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Errore: $err')),
        data: (budget) {
          final spentOther = spending.spentTotal - spending.spentGlutenFree;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Sezione Spesa vs Budget
                Text('Andamento Spesa', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 16),
                _BudgetProgressIndicator(
                  label: 'Senza Glutine',
                  spent: spending.spentGlutenFree,
                  budget: budget?.glutenFreeBudget,
                  color: Colors.green,
                ),
                const SizedBox(height: 12),
                _BudgetProgressIndicator(
                  label: 'Altro',
                  spent: spentOther,
                  budget: null,
                  color: Colors.orange,
                ),
                const SizedBox(height: 12),
                _BudgetProgressIndicator(
                  label: 'Totale',
                  spent: spending.spentTotal,
                  budget: budget?.totalBudget,
                  color: theme.colorScheme.primary,
                ),

                const Divider(height: 48),

                // Sezione per impostare i budget
                Text('Imposta Budget', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 16),
                _BudgetTextField(
                  controller: _gfController,
                  label: 'Budget Senza Glutine',
                ),
                const SizedBox(height: 12),
                _BudgetTextField(
                  controller: _totalController,
                  label: 'Budget Totale',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveBudget() {
    final box = ref.read(budgetBoxProvider).requireValue;
    final now = DateTime.now();
    final id = '${now.year}-${now.month}';

    final newGfBudget = double.tryParse(_gfController.text);
    final newTotalBudget = double.tryParse(_totalController.text);

    final budget = BudgetModel(
      id: id,
      year: now.year,
      month: now.month,
      glutenFreeBudget: newGfBudget,
      totalBudget: newTotalBudget,
    );

    // 1. Salva in locale
    box.put(id, budget);
    debugPrint("[Sync Budget] Budget per '$id' salvato in Hive.");

    // 2. Prova a salvare in cloud
    try {
      final user = ref.read(authProvider).currentUser;
      if (user != null) {
        final remoteCollection = ref
            .read(firestoreProvider)
            .collection('users')
            .doc(user.uid)
            .collection('budgets');

        // Usiamo `set` per creare o sovrascrivere il documento del mese corrente.
        remoteCollection.doc(id).set(budget.toJson());
        debugPrint(
          "[Sync Budget] Budget per '$id' salvato anche su Firestore.",
        );
      }
    } catch (e) {
      debugPrint(
        "[Sync Budget] Errore sync (save budget) su cloud (probabilmente offline): $e",
      );
    }

    // Il resto della funzione (invalidate, snackbar) rimane identico
    ref.invalidate(currentMonthBudgetProvider);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Budget salvato!')));
    FocusScope.of(context).unfocus();
  }
}

// Widget helper per i campi di testo
class _BudgetTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const _BudgetTextField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label, // TODO: Localizza
        suffixText: '€',
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }
}

// Widget helper per le barre di progresso
class _BudgetProgressIndicator extends StatelessWidget {
  final String label;
  final double spent;
  final double? budget;
  final Color color;

  const _BudgetProgressIndicator({
    required this.label,
    required this.spent,
    required this.budget,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasBudget = budget != null && budget! > 0;
    final progress = hasBudget ? (spent / budget!) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.titleMedium),
            Text(
              '${spent.toStringAsFixed(2)} € ${hasBudget ? "/ ${budget!.toStringAsFixed(2)} €" : ""}',
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (hasBudget)
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 12,
            borderRadius: BorderRadius.circular(6),
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              progress > 1.0 ? Colors.red : color,
            ),
          ),
      ],
    );
  }
}
