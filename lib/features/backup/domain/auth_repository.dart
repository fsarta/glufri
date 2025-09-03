import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb; // Utile per la configurazione web

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(this._firebaseAuth, this._googleSignIn);

  /// Stream per ascoltare i cambiamenti dello stato di autenticazione in tempo reale.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Restituisce l'utente corrente di Firebase, se presente.
  User? get currentUser => _firebaseAuth.currentUser;

  /// Funzione per eseguire il login con Google, aggiornata alle API più recenti.
  Future<User?> signInWithGoogle() async {
    try {
      // 1. Avvia il flusso di login di Google. L'utente vedrà un popup per
      //    selezionare l'account. Se è già loggato, potrebbe essere immediato.
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();

      // Se l'utente chiude il popup, googleUser sarà null.
      if (googleUser == null) {
        return null;
      }

      // 2. Ottieni i dettagli di autenticazione dalla richiesta. Questo
      //    contiene i token necessari per l'autenticazione con Firebase.
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Crea una credenziale OAuth per Firebase.
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, // <- Ora è un accesso diretto
      );

      // 4. Esegui il login in Firebase con la credenziale ottenuta
      //    e restituisci l'utente di Firebase.
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase Auth Error in Google Sign-In: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Generic Error in Google Sign-In: $e');
      rethrow;
    }
  }

  /// Esegue il logout sia da Firebase che da Google Sign-In.
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}

// ---- Provider di Riverpod (Aggiornati) ----

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

/// Provider per GoogleSignIn, ora configurato correttamente.
final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  // Se stai costruendo per il web, devi fornire il tuo client ID.
  // Per mobile (Android/iOS), questa configurazione è sufficiente.
  if (kIsWeb) {
    // Sostituisci 'TUO_WEB_CLIENT_ID.apps.googleusercontent.com' con il tuo client ID
    // ottenuto dalla Google Cloud Console per la tua app web Firebase.
    return GoogleSignIn.instance;
  }
  // Configurazione standard per mobile
  return GoogleSignIn.instance;
});

// Il repository ora dipende dai provider aggiornati
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(googleSignInProvider),
  );
});

// Questo stream provider non necessita di modifiche e continuerà a funzionare
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
