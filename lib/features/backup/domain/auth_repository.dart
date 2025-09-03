// lib/features/backup/domain/auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Repository per autenticazione Firebase + Google (gestione web & mobile).
class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(this._firebaseAuth, this._googleSignIn);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  User? get currentUser => _firebaseAuth.currentUser;

  /// Login con Google — restituisce [User] se successo, `null` se l'utente annulla.
  Future<User?> signInWithGoogle() async {
    try {
      // WEB: usa il popup Firebase (se usi web)
      if (kIsWeb) {
        final GoogleAuthProvider webProvider = GoogleAuthProvider();
        final UserCredential userCredential = await _firebaseAuth
            .signInWithPopup(webProvider);
        return userCredential.user;
      }

      // MOBILE (Android / iOS)
      debugPrint('[GoogleSignIn] start authenticate()');
      GoogleSignInAccount? googleUser;

      try {
        // Chiamata principale: interactive authenticate()
        googleUser = await _googleSignIn.authenticate();
        debugPrint('[GoogleSignIn] authenticate() completed: $googleUser');
      } on GoogleSignInException catch (gse) {
        debugPrint('[GoogleSignIn] GoogleSignInException: ${gse.code}');
        // Gestiamo il caso di cancellazione (utente o sistema ha annullato)
        if (gse.code == 'canceled') {
          debugPrint(
            '[GoogleSignIn] authenticate() was cancelled by user/system.',
          );
          // Proviamo un fallback leggero (non sempre apre UI completa).
          try {
            debugPrint(
              '[GoogleSignIn] attempting attemptLightweightAuthentication() fallback...',
            );
            final fallbackAccount = await _googleSignIn
                .attemptLightweightAuthentication();
            debugPrint(
              '[GoogleSignIn] attemptLightweightAuthentication() returned: $fallbackAccount',
            );
            googleUser = fallbackAccount;
            // se fallbackAccount è null, verrà gestito più sotto come annullamento
          } on Exception catch (fallbackErr, fallbackSt) {
            debugPrint(
              '[GoogleSignIn] fallback attemptLightweightAuthentication error: $fallbackErr\n$fallbackSt',
            );
            // Non rilanciamo: consideriamo il login annullato
            return null;
          }
        } else {
          // altri codici di errore: rilanciamo per gestione superiore
          rethrow;
        }
      }

      // Se ancora null, consideriamo l'utente ha annullato / nessun account selezionato
      if (googleUser == null) {
        debugPrint(
          '[GoogleSignIn] No account returned (user cancelled or no account).',
        );
        return null;
      }

      debugPrint(
        '[GoogleSignIn] got account: ${googleUser.email} (${googleUser.id})',
      );

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      debugPrint(
        '[GoogleSignIn] got authentication, idToken: ${googleAuth.idToken != null}',
      );

      if (googleAuth.idToken == null) {
        debugPrint('[GoogleSignIn] idToken is null -> abort sign in');
        return null;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        // accessToken non sempre disponibile nelle API v7
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      debugPrint(
        '[GoogleSignIn] firebase signInWithCredential success: ${userCredential.user?.uid}',
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'FirebaseAuthException during Google Sign-In: ${e.code} - ${e.message}',
      );
      rethrow;
    } catch (e, st) {
      debugPrint('Generic Error in Google Sign-In: $e\n$st');
      rethrow;
    }
  }

  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("Errore registrazione: ${e.code} - ${e.message}");
      rethrow;
    }
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("Errore login: ${e.code} - ${e.message}");
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint("Errore reset password: ${e.code} - ${e.message}");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        // Non blocchiamo l'operazione principale se fallisce il signOut di GoogleSignIn
        debugPrint("Warning: signOut() su GoogleSignIn ha fallito: $e");
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint("Errore durante signOut: $e");
      rethrow;
    }
  }
}

// -------------------- Riverpod Providers (se li vuoi qui) --------------------

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  // L'istanza dovrebbe essere inizializzata in main() con clientId/serverClientId.
  return GoogleSignIn.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final googleSignIn = ref.watch(googleSignInProvider);
  return AuthRepository(firebaseAuth, googleSignIn);
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});
