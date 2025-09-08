// lib/features/shell/presentation/screens/main_shell_screen.dart

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

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _selectedIndex = 0;

  // Manteniamo la lista di widget come prima
  static const List<Widget> _screens = <Widget>[
    PurchaseHistoryScreen(), // 0
    ShoppingListsScreen(), // 1
    BudgetScreen(), // 2
    FavoriteProductsScreen(), // 3
    SettingsScreen(), // 4
  ];

  // Lista separata degli ID delle schermate (per riferimento futuro)
  final _screenKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final proScreenIndexes = {1, 2, 3};

  void _onItemTapped(int index) {
    final isPro = ref.read(isProUserProvider);

    if (proScreenIndexes.contains(index) && !isPro) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const UpsellScreen()));
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      // Usiamo IndexedStack: è molto efficiente. Costruisce tutti i figli
      // una volta, li mantiene in memoria, ma ne mostra solo uno alla volta
      // (quello corrispondente a `_selectedIndex`). Questo rende il cambio
      // di tab istantaneo e il layout stabile.
      body: IndexedStack(index: _selectedIndex, children: _screens),

      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: l10n.purchaseHistory,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt_outlined),
            label: 'Liste', // Todo: l10n.shoppingLists
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assessment_outlined),
            label: 'Budget', // Todo: l10n.budget
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border),
            label: 'Preferiti', // Todo: l10n.favoriteProducts
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
      ),
    );
  }
}
