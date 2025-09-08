import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/core/utils/debug_data_seeder.dart';
import 'package:glufri/core/utils/debug_overrides.dart';
import 'package:glufri/features/backup/domain/auth_repository.dart';
import 'package:glufri/features/backup/domain/sync_service.dart';
import 'package:glufri/features/budget/presentation/screens/budget_screen.dart';
import 'package:glufri/features/favorites/presentation/screens/favorite_products_screen.dart';
import 'package:glufri/features/monetization/presentation/providers/monetization_provider.dart';
import 'package:glufri/features/monetization/presentation/screens/upsell_screen.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_providers.dart';
import 'package:glufri/features/settings/presentation/providers/settings_provider.dart';
import 'package:glufri/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:glufri/features/shopping_list/presentation/screens/shopping_lists_screen.dart';
import 'package:glufri/generated/l10n.dart'; // Ensure this import is present for S

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isBackupLoading = false;
  bool _isRestoreLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authStateChangesProvider);
    final isPro = ref.watch(isProUserProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n!.settings)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.theme),
            trailing: DropdownButton<ThemeMode>(
              value: ref.watch(themeModeProvider),
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(l10n.system),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(l10n.light),
                ),
                DropdownMenuItem(value: ThemeMode.dark, child: Text(l10n.dark)),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                }
              },
            ),
          ),
          ListTile(
            title: Text(l10n.language),
            trailing: DropdownButton<String>(
              value: ref.watch(localeProvider)?.languageCode ?? 'system',
              items: [
                DropdownMenuItem(
                  value: 'system',
                  child: Text(l10n.settingsLanguageSystem),
                ),
                DropdownMenuItem(value: 'it', child: Text("Italiano")),
                DropdownMenuItem(value: 'en', child: Text("English")),
                DropdownMenuItem(value: 'es', child: Text("Español")),
                DropdownMenuItem(value: 'de', child: Text("Deutsch")),
                DropdownMenuItem(value: 'fr', child: Text("Français")),
              ],
              onChanged: (value) {
                ref.read(localeProvider.notifier).setLocaleFromString(value);
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              l10n.settingsAccountAndBackup,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          authState.when(
            data: (user) {
              if (user == null) {
                return ListTile(
                  leading: const Icon(Icons.login),
                  title: Text(l10n.settingsLoginForBackup),
                  onTap: () async {
                    try {
                      await ref.read(authRepositoryProvider).signInWithGoogle();
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.settingsLoginFailed)),
                      );
                    }
                  },
                );
              }
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.photoURL != null
                          ? NetworkImage(user.photoURL!)
                          : null,
                      child: user.photoURL == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(user.displayName ?? l10n.user),
                    subtitle: Text(user.email ?? ''),
                  ),
                  // Pulsante Backup
                  ListTile(
                    enabled: !_isBackupLoading && !_isRestoreLoading,
                    leading: _isBackupLoading
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.cloud_upload_outlined),
                    title: Text(l10n.settingsBackupNow),
                    onTap: () async {
                      if (!isPro) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const UpsellScreen(),
                          ),
                        );
                        return;
                      }

                      setState(() => _isBackupLoading = true);
                      try {
                        await ref.read(syncServiceProvider).backupToCloud();
                        if (mounted)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.backupSuccess),
                              backgroundColor: Colors.green,
                            ),
                          );
                      } catch (e) {
                        if (mounted)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.backupError),
                              backgroundColor: Colors.red,
                            ),
                          );
                      } finally {
                        if (mounted) setState(() => _isBackupLoading = false);
                      }
                    },
                  ),
                  // Pulsante Ripristino
                  ListTile(
                    enabled: !_isBackupLoading && !_isRestoreLoading,
                    leading: _isRestoreLoading
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.cloud_download_outlined),
                    title: Text(l10n.settingsRestoreFromCloud),
                    onTap: () async {
                      if (!isPro) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const UpsellScreen(),
                          ),
                        );
                        return;
                      }

                      final confirmed =
                          await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(l10n.restoreConfirmationTitle),
                              content: Text(l10n.restoreConfirmationBody),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: Text(l10n.cancel),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: Text(l10n.settingsRestoreFromCloud),
                                ),
                              ],
                            ),
                          ) ??
                          false;

                      if (!confirmed) return;

                      setState(() => _isRestoreLoading = true);
                      try {
                        await ref.read(syncServiceProvider).restoreFromCloud();
                        ref.invalidate(
                          purchaseListProvider,
                        ); // <-- FONDAMENTALE
                        if (mounted)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.restoreSuccess),
                              backgroundColor: Colors.green,
                            ),
                          );
                      } catch (e) {
                        if (mounted)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.restoreError),
                              backgroundColor: Colors.red,
                            ),
                          );
                      } finally {
                        if (mounted) setState(() => _isRestoreLoading = false);
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(l10n.settingsLogout),
                    onTap: () => ref.read(authRepositoryProvider).signOut(),
                  ),
                  /* ListTile(
                    leading: const Icon(Icons.assessment_outlined),
                    title: const Text(
                      'Budget Mensile (Pro)',
                    ), // TODO: Localizza
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      if (!isPro) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const UpsellScreen(),
                          ),
                        );
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BudgetScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite_border),
                    title: const Text(
                      'Prodotti Preferiti (Pro)',
                    ), // TODO: Localizza
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      if (!isPro) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const UpsellScreen(),
                          ),
                        );
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const FavoriteProductsScreen(),
                        ),
                      );
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.list_alt_outlined),
                    title: const Text(
                      'Liste della Spesa (Pro)',
                    ), // TODO: Localizza
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      if (!isPro) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const UpsellScreen(),
                          ),
                        );
                        return;
                      }
                      // Naviga alla nuova schermata principale delle liste
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ShoppingListsScreen(),
                        ),
                      );
                    },
                  ), */
                ],
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, st) => ListTile(title: Text(l10n.settingsAuthError)),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.settingsPrivacyPolicy),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              );
            },
          ),
          // Questa intera sezione verrà compilata e mostrata SOLO in modalità debug.
          // Non esisterà nell'app che pubblicherai sullo store.
          if (kDebugMode) ...[
            const Divider(thickness: 2, color: Colors.blueGrey),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Opzioni Sviluppatore',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SwitchListTile(
              title: const Text('Simula Account PRO'),
              subtitle: const Text(
                'Attiva per testare le funzionalità Pro senza pagare.',
              ),
              // Leggi il valore direttamente dal provider
              value: ref.watch(debugProVersionOverrideProvider),
              onChanged: (newValue) {
                // Scrivi il nuovo valore nel provider.
                // Questo notificherà TUTTI i listener (incluso isProUserProvider)
                ref.read(debugProVersionOverrideProvider.notifier).state =
                    newValue;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Versione PRO ${newValue ? "ATTIVATA" : "DISATTIVATA"} (Solo Debug)',
                    ),
                    backgroundColor: newValue ? Colors.purple : Colors.grey,
                  ),
                );
              },
              secondary: const Icon(Icons.star, color: Colors.amber),
            ),
            ListTile(
              leading: const Icon(Icons.add_box, color: Colors.green),
              title: const Text('Aggiungi 50 Acquisti Finti'),
              subtitle: const Text('Popola la cronologia con dati casuali.'),
              onTap: () async {
                // Mostra un caricamento
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Generazione dati in corso...'),
                    duration: Duration(seconds: 2),
                  ),
                );
                await DebugDataSeeder.generateAndSavePurchases();

                // Forza l'aggiornamento della UI
                ref.invalidate(purchaseListProvider);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dati generati con successo!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Cancella TUTTI gli Acquisti Locali'),
              subtitle: const Text(
                'Azione irreversibile. Utile per ripartire da zero.',
              ),
              onTap: () async {
                await DebugDataSeeder.clearLocalPurchases();

                // Forza l'aggiornamento della UI
                ref.invalidate(purchaseListProvider);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dati locali cancellati.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            const Divider(thickness: 2, color: Colors.blueGrey),
          ],
        ],
      ),
    );
  }
}
