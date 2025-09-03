import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/backup/domain/auth_repository.dart';
import 'package:glufri/features/settings/presentation/providers/settings_provider.dart';
import 'package:glufri/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:glufri/generated/l10n.dart'; // Ensure this import is present for S

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authStateChangesProvider);

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
              items: const [
                DropdownMenuItem(value: 'system', child: Text("Sistema")),
                DropdownMenuItem(value: 'it', child: Text("Italiano")),
                DropdownMenuItem(value: 'en', child: Text("English")),
              ],
              onChanged: (value) {
                if (value == null) return;
                if (value == 'system') {
                  ref
                      .read(localeProvider.notifier)
                      .setLocale(const Locale('system'));
                } else {
                  ref.read(localeProvider.notifier).setLocale(Locale(value));
                }
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Account e Backup (Pro)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          authState.when(
            data: (user) {
              if (user == null) {
                return ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text(
                    'Accedi con Google per abilitare il backup',
                  ),
                  onTap: () async {
                    try {
                      await ref.read(authRepositoryProvider).signInWithGoogle();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login fallito. Riprova.'),
                        ),
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
                    title: Text(user.displayName ?? 'Utente'),
                    subtitle: Text(user.email ?? ''),
                  ),
                  ListTile(
                    leading: const Icon(Icons.cloud_upload_outlined),
                    title: const Text('Esegui Backup'),
                    onTap: () {
                      /* TODO: Chiamare SyncService.backupToCloud() */
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.cloud_download_outlined),
                    title: const Text('Ripristina da Cloud'),
                    onTap: () {
                      /* TODO: Chiamare SyncService.restoreFromCloud() */
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () => ref.read(authRepositoryProvider).signOut(),
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, st) =>
                const ListTile(title: Text('Errore di autenticazione')),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Informativa Privacy'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
