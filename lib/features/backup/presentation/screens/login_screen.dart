// lib/features/backup/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/l10n/app_localizations.dart';
import 'package:glufri/features/backup/domain/auth_repository.dart';
import 'package:glufri/features/backup/presentation/screens/forgot_password_screen.dart';
import 'package:glufri/features/backup/presentation/screens/signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _errorMessage = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text,
          );
      // La logica di pop è gestita globalmente
    } catch (e) {
      if (mounted)
        setState(
          () => _errorMessage = "Email o password errati.",
        ); // TODO: Localizza
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _errorMessage = null);
    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      // La logica di pop è gestita globalmente
    } catch (e) {
      if (mounted)
        setState(
          () => _errorMessage = "Login con Google fallito. Riprova.",
        ); // TODO: Localizza
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        // Rimuoviamo l'ombra per un look più piatto e integrato
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- 1. HEADER GRAFICO ---
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Icon(
                    Icons.shopping_cart_checkout_rounded,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  l10n.loginWelcome, // "Bentornato!"
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.loginSubtitle, // "Accedi per continuare"
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 48),

                // --- 2. CAMPI DI INPUT ---
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: l10n.email),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? l10n.requiredField : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  // L'oscuramento del testo ora dipende dalla nostra variabile di stato
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    // Aggiungiamo un'icona alla fine del campo
                    suffixIcon: IconButton(
                      // L'icona cambia in base alla visibilità
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        // 3. AGGIORNA LO STATO QUANDO L'ICONA VIENE PREMUTA
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? l10n.requiredField : null,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(l10n.forgotPassword),
                  ),
                ),
                const SizedBox(height: 24),

                // --- MOSTRA MESSAGGIO DI ERRORE ---
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // --- 3. PULSANTI D'AZIONE ---
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  FilledButton(
                    onPressed: _login,
                    child: Text(l10n.loginAction),
                  ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _loginWithGoogle,
                  icon: const Icon(
                    Icons.g_mobiledata,
                  ), // Dovresti usare un logo Google
                  label: Text(l10n.loginWithGoogle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                  ),
                ),

                // --- 4. FOOTER PER REGISTRAZIONE ---
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.noAccountPrompt), // "Non hai un account?"
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(l10n.signup),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
