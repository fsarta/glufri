import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final monthName = DateFormat.yMMMM('it_IT').format(DateTime.now());

    // Osserviamo i provider
    final budgetAsync = ref.watch(currentMonthBudgetProvider);
    final spending = ref.watch(currentMonthSpendingProvider);

    // Usiamo ref.listen per aggiornare i controller una sola volta quando i dati arrivano
    ref.listen<AsyncValue<BudgetModel?>>(currentMonthBudgetProvider, (
      _,
      state,
    ) {
      if (state.hasValue) {
        final budget = state.value;
        _gfController.text = budget?.glutenFreeBudget?.toString() ?? '';
        _totalController.text = budget?.totalBudget?.toString() ?? '';
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Budget di $monthName'), // TODO: Localizza
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveBudget,
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
    final box = ref.read(budgetBoxProvider);
    final now = DateTime.now();
    final id = '${now.year}-${now.month}';

    // Parse dei valori, con gestione del testo vuoto
    final newGfBudget = double.tryParse(_gfController.text);
    final newTotalBudget = double.tryParse(_totalController.text);

    final budget = BudgetModel(
      id: id,
      year: now.year,
      month: now.month,
      glutenFreeBudget: newGfBudget,
      totalBudget: newTotalBudget,
    );

    box.put(id, budget);

    // Invalida il provider per far ricaricare i dati e aggiornare la UI
    ref.invalidate(currentMonthBudgetProvider);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Budget salvato!'),
        backgroundColor: Colors.green,
      ),
    );
    FocusScope.of(context).unfocus(); // Chiude la tastiera
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
