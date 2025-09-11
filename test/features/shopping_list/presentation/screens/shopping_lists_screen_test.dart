import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glufri/features/shopping_list/presentation/providers/shopping_list_providers.dart';
import 'package:glufri/features/shopping_list/presentation/screens/shopping_lists_screen.dart';
import 'package:mocktail/mocktail.dart';

// Importa il file di localizzazione per il test
import 'package:glufri/core/l10n/app_localizations.dart';

// Mock della classe delle azioni
class MockShoppingListActions extends Mock implements ShoppingListActions {}

void main() {
  late MockShoppingListActions mockActions;

  // Widget di test
  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        shoppingListsProvider.overrideWith(
          (ref) => Stream.value([]),
        ), // Partiamo con una lista vuota
        shoppingListActionsProvider.overrideWithValue(mockActions),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ShoppingListsScreen(),
      ),
    );
  }

  setUp(() {
    mockActions = MockShoppingListActions();
  });

  testWidgets(
    'should create a new list when user enters a name and taps create',
    (tester) async {
      // ARRANGE: Diciamo al mock che il metodo createNewList non deve fare nulla di speciale
      when(
        () => mockActions.createNewList(any()),
      ).thenAnswer((_) async => 'some_id');

      await tester.pumpWidget(createTestWidget());

      // ACT: Simula il click sul FloatingActionButton
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle(); // Attendi che il dialogo appaia

      // Inserisci del testo nel TextFormField
      // Troviamo il widget TextField tramite il suo labelText
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.labelText == "Nome della lista",
        ),
        'Spesa di Natale',
      );

      // Clicca il pulsante 'Crea'
      await tester.tap(find.text('Crea'));
      await tester.pumpAndSettle(); // Attendi che il dialogo si chiuda

      // ASSERT: Verifica che il nostro mock sia stato chiamato correttamente
      verify(() => mockActions.createNewList('Spesa di Natale')).called(1);
    },
  );
}
