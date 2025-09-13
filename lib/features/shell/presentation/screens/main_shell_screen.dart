// lib/features/shell/presentation/screens/main_shell_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/backup/domain/auth_repository.dart';
import 'package:glufri/features/backup/domain/user_model.dart';
import 'package:glufri/features/backup/presentation/providers/sync_providers.dart';
import 'package:glufri/features/backup/presentation/providers/user_provider.dart';
import 'package:glufri/features/backup/presentation/screens/login_screen.dart';
import 'package:glufri/features/budget/presentation/screens/budget_screen.dart';
import 'package:glufri/features/favorites/presentation/screens/favorite_products_screen.dart';
import 'package:glufri/features/monetization/presentation/providers/monetization_provider.dart';
import 'package:glufri/features/monetization/presentation/screens/upsell_screen.dart';
import 'package:glufri/features/purchase/presentation/screens/purchase_history_screen.dart';
import 'package:glufri/features/settings/presentation/screens/settings_screen.dart';
import 'package:glufri/features/shopping_list/presentation/screens/shopping_lists_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _selectedIndex = 0;
  static const String _lastTabIndexKey = 'lastTabIndex';

  // Manteniamo la lista di widget come prima
  static const List<Widget> _screens = <Widget>[
    PurchaseHistoryScreen(), // 0
    ShoppingListsScreen(), // 1
    BudgetScreen(), // 2
    FavoriteProductsScreen(), // 3
    SettingsScreen(), // 4
  ];

  final proScreenIndexes = {1, 2, 3};

  @override
  void initState() {
    super.initState();
    _loadLastTabIndex();
  }

  /// Carica l'ultimo indice della tab salvato dalle preferenze.
  Future<void> _loadLastTabIndex() async {
    final prefs = await SharedPreferences.getInstance();
    // Legge l'indice salvato. Se non c'è, usa 0 (Cronologia) come default.
    final lastIndex = prefs.getInt(_lastTabIndexKey) ?? 0;

    // Controlliamo che lo stato esista ancora prima di aggiornarlo
    if (mounted) {
      setState(() {
        _selectedIndex = lastIndex;
      });
    }
  }

  /// Salva l'indice della tab corrente e aggiorna lo stato.
  Future<void> _onItemTapped(int index) async {
    final isPro = ref.read(isProUserProvider);

    if (proScreenIndexes.contains(index) && !isPro) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const UpsellScreen()));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastTabIndexKey, index);

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // 1. OSSERVIAMO il nostro nuovo provider di stato di sincronizzazione
    final isSyncing = ref.watch(syncInProgressProvider);

    return Scaffold(
      drawer: _AppDrawer(
        currentIndex: _selectedIndex,
        onItemTapped: (index) {
          // Chiudi il drawer prima di cambiare pagina
          Navigator.of(context).pop();
          _onItemTapped(index);
        },
      ),
      // 2. AVVOLGIAMO il body in uno Stack
      body: Stack(
        children: [
          // Widget principale (era il vecchio body)
          IndexedStack(index: _selectedIndex, children: _screens),

          // 3. MOSTRIAMO L'OVERLAY di caricamento in modo condizionale
          // se isSyncing è true.
          if (isSyncing)
            const ColoredBox(
              color: Colors.black45,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: l10n.purchaseHistory,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt_outlined),
            label: l10n.shoppingLists,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assessment_outlined),
            label: l10n.monthlyBudget,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border),
            label: l10n.favoriteProducts,
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

class _AppDrawer extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const _AppDrawer({required this.currentIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider);
    final isPro = ref.watch(isProUserProvider);
    final proScreenIndexes = {1, 2, 3}; // Indici delle schermate Pro

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context, user),
          _buildDrawerItem(
            context,
            icon: Icons.history,
            text: l10n.purchaseHistory,
            index: 0,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.list_alt_outlined,
            text: l10n.shoppingLists,
            index: 1,
            isProFeature: true,
            userIsPro: isPro,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.assessment_outlined,
            text: l10n.monthlyBudget,
            index: 2,
            isProFeature: true,
            userIsPro: isPro,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.favorite_border,
            text: l10n.favoriteProducts,
            index: 3,
            isProFeature: true,
            userIsPro: isPro,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            text: l10n.settings,
            index: 4,
          ),
          const Divider(),
          if (user != null)
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                l10n.settingsLogout,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () {
                Navigator.of(context).pop(); // Chiudi il drawer prima
                ref.read(authRepositoryProvider).signOut();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, UserModel? user) {
    final l10n = AppLocalizations.of(context)!;

    if (user != null) {
      // Intestazione per l'utente loggato
      return UserAccountsDrawerHeader(
        accountName: Text(user.displayName ?? l10n.user),
        accountEmail: Text(user.email ?? ''),
        currentAccountPicture: CircleAvatar(
          backgroundImage: user.photoURL != null
              ? NetworkImage(user.photoURL!)
              : null,
          child: user.photoURL == null
              ? const Icon(Icons.person, size: 40)
              : null,
        ),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      );
    } else {
      // Intestazione per l'utente ospite
      return DrawerHeader(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.person_pin,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.userGuest,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              child: Text(
                l10n.loginToSaveData,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required int index,
    bool isProFeature = false,
    bool userIsPro = false,
  }) {
    final bool isSelected = currentIndex == index;
    final bool isLocked = isProFeature && !userIsPro;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : (isLocked ? Colors.grey.shade500 : null),
      ),
      title: Text(
        text,
        style: TextStyle(color: isLocked ? Colors.grey.shade500 : null),
      ),
      selected: isSelected,
      selectedTileColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      onTap: () => onItemTapped(index),
      trailing: isLocked
          ? Icon(Icons.lock, size: 18, color: Colors.grey.shade600)
          : null,
    );
  }
}
