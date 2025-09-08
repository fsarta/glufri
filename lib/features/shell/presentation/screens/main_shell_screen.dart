import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/budget/presentation/screens/budget_screen.dart';
import 'package:glufri/features/favorites/presentation/screens/favorite_products_screen.dart';
import 'package:glufri/features/monetization/presentation/providers/monetization_provider.dart';
import 'package:glufri/features/monetization/presentation/screens/upsell_screen.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_history_screen.dart';
import 'package:glufri/features/settings/presentation/screens/settings_screen.dart';
import 'package:glufri/features/shopping_list/presentation/screens/shopping_lists_screen.dart';
// ... importa le altre schermate principali

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _selectedIndex = 0; // L'indice della tab corrente

  // La lista delle schermate principali dell'app
  static const List<Widget> _widgetOptions = <Widget>[
    PurchaseHistoryScreen(), // Index 0
    ShoppingListsScreen(), // Index 1
    BudgetScreen(), // Index 2
    FavoriteProductsScreen(), // Index 3
    SettingsScreen(), // Index 4
  ];

  // Definiamo quali indici sono "Pro"
  final proScreenIndexes = {1, 2, 3}; // Indici di Liste, Budget e Preferiti

  void _onItemTapped(int index) {
    // Ora usiamo 'ref' che è disponibile nello state
    final isPro = ref.read(isProUserProvider);

    // Se l'indice cliccato è una feature Pro e l'utente non è Pro...
    if (proScreenIndexes.contains(index) && !isPro) {
      // ...mostra la schermata di upsell.
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const UpsellScreen()));
      // NOTA: Non cambiamo _selectedIndex, così la tab rimane visivamente su quella precedente.
      return;
    }

    // Altrimenti, cambia la tab normalmente
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      // Il body ora è dinamico in base all'indice selezionato
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: l10n.purchaseHistory,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Liste Spesa', // TODO: Localizza
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Budget', // TODO: Localizza
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Preferiti', // TODO: Localizza
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // Questi stili migliorano l'aspetto quando ci sono più di 3 item
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false, // Stile pulito per tante icone
      ),
    );
  }
}
