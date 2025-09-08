import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glufri/features/backup/domain/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

// Creiamo le classi mock per le dipendenze
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

void main() {
  late AuthRepository authRepository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    authRepository = AuthRepository(mockFirebaseAuth, mockGoogleSignIn);
  });

  group('AuthRepository - signOut', () {
    test('should call signOut on FirebaseAuth and GoogleSignIn', () async {
      // ARRANGE: Programma i metodi finti perché non diano errori
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async {});

      // ACT: Chiama la funzione di logout
      await authRepository.signOut();

      // ASSERT: Verifica che entrambi i metodi di logout siano stati chiamati
      verify(() => mockFirebaseAuth.signOut()).called(1);
      verify(() => mockGoogleSignIn.signOut()).called(1);
    });

    test(
      'should continue with FirebaseAuth.signOut even if GoogleSignIn.signOut fails',
      () async {
        // ARRANGE: Simula un'eccezione quando viene chiamato il logout di Google
        when(
          () => mockGoogleSignIn.signOut(),
        ).thenThrow(Exception('Google Sign In failed'));
        // Assicurati che il logout di Firebase sia comunque "programmato" per funzionare
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        // ACT
        await authRepository.signOut();

        // ASSERT: Verifica che il logout di Firebase sia stato chiamato, nonostante l'errore precedente
        verify(() => mockFirebaseAuth.signOut()).called(1);
      },
    );
  });
}
