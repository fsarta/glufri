import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/backup/domain/auth_repository.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        await ref
            .read(authRepositoryProvider)
            .sendPasswordResetEmail(_emailController.text.trim());
        setState(() {
          _successMessage =
              "Email di recupero inviata con successo! Controlla la tua casella di posta.";
        });
      } catch (e) {
        setState(() {
          _errorMessage =
              "Errore durante l'invio dell'email. L'indirizzo potrebbe non essere valido.";
        });
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Recupera Password')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Password Dimenticata?',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Inserisci l'email associata al tuo account. Ti invieremo un link per reimpostare la tua password.",
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Inserisci un\'email valida.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Messaggio di errore o successo
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                if (_successMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _successMessage!,
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                  ),

                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  FilledButton(
                    onPressed: _sendResetEmail,
                    child: const Text('INVIA EMAIL DI RECUPERO'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
