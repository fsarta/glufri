// test/features/purchase/presentation/providers/cart_provider_test.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/domain/repositories/purchase_repository.dart';
import 'package:glufri/features/purchase/presentation/providers/cart_provider.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_providers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Questa annotazione dice a Mockito di creare un file con una classe 'MockPurchaseRepository'
// che implementa 'PurchaseRepository'. 'Nice' mock significa che i metodi non stubbati
// restituiranno valori di default (null, 0, ecc.) invece di lanciare un errore.
@GenerateNiceMocks([MockSpec<PurchaseRepository>()])
import 'cart_provider_test.mocks.dart'; // Questo file non esiste ancora, lo genereremo

void main() {
  // Dichiariamo le nostre variabili di test qui per poterle riutilizzare
  late MockPurchaseRepository mockPurchaseRepository;
  late ProviderContainer container;

  // `setUp` viene eseguito prima di OGNI singolo test.
  // È perfetto per resettare lo stato e le dipendenze.
  setUp(() {
    mockPurchaseRepository = MockPurchaseRepository();
    // `ProviderContainer` è un oggetto di Riverpod per testare i provider in isolamento.
    // Usiamo `overrideWithValue` per dire a Riverpod: "Quando qualcuno chiede
    // `purchaseRepositoryProvider`, non creare quello vero, ma usa la nostra istanza di mock".
    container = ProviderContainer(
      overrides: [
        purchaseRepositoryProvider.overrideWithValue(mockPurchaseRepository),
      ],
    );
  });

  // `tearDown` viene eseguito dopo OGNI singolo test.
  // Serve per pulire, ad es. chiudere connessioni o cancellare dati.
  tearDown(() {
    container.dispose();
  });

  // Un oggetto di prova che useremo nei test
  final tItem = PurchaseItemModel(
    id: '1',
    name: 'Test Item',
    unitPrice: 10,
    quantity: 2,
  );

  test('initial state is correct (empty cart)', () {
    // Leggiamo lo stato iniziale del provider
    final cartState = container.read(cartProvider);

    // Verifichiamo che sia vuoto come ci aspettiamo
    expect(cartState.items, isEmpty);
    expect(cartState.storeName, isNull);
    expect(cartState.total, 0.0);
    expect(cartState.originalPurchaseId, isNull);
  });

  test('addItem correctly adds an item and updates total', () {
    // Leggiamo il notifier, non solo lo stato
    final notifier = container.read(cartProvider.notifier);

    // ACT: chiamiamo il metodo da testare
    notifier.addItem(tItem);

    // ASSERT: verifichiamo che lo stato sia cambiato
    final newState = container.read(cartProvider);
    expect(newState.items.length, 1);
    expect(newState.items.first.name, 'Test Item');
    expect(newState.total, 20.0); // 10 * 2
  });

  test('removeItem correctly removes an item and updates total', () {
    // ARRANGE: prima aggiungiamo un item
    final notifier = container.read(cartProvider.notifier);
    notifier.addItem(tItem);

    // ACT: ora lo rimuoviamo
    notifier.removeItem('1');

    // ASSERT: verifichiamo che lo stato sia tornato vuoto
    final newState = container.read(cartProvider);
    expect(newState.items, isEmpty);
    expect(newState.total, 0.0);
  });

  test('savePurchase calls repository.addPurchase when not editing', () async {
    // ARRANGE: aggiungiamo un item per rendere il carrello salvabile
    final notifier = container.read(cartProvider.notifier);
    notifier.addItem(tItem);

    // ACT: chiamiamo savePurchase
    // Poiché savePurchase usa ref.read, dobbiamo passargli il nostro container
    await notifier.savePurchase();

    // ASSERT: QUI LA MAGIA DEL MOCKING!
    // `verify` controlla che un metodo sul nostro mock sia stato chiamato.
    // `any` è un "argument matcher": ci va bene qualsiasi oggetto `PurchaseModel`,
    // basta che il metodo sia stato chiamato.
    verify(
      mockPurchaseRepository.addPurchase(any),
    ).called(1); // chiamato 1 volta
    verifyNever(mockPurchaseRepository.updatePurchase(any)); // mai chiamato
  });

  test('savePurchase calls repository.updatePurchase when editing', () async {
    // ARRANGE: carichiamo un acquisto esistente in modalità modifica
    final notifier = container.read(cartProvider.notifier);
    final existingPurchase = PurchaseModel(
      id: 'existing-id',
      date: DateTime.now(),
      total: 20,
      items: [tItem],
    );

    notifier.loadPurchase(
      existingPurchase,
      isDuplicate: false,
    ); // isDuplicate: false = modalità modifica

    // ACT: salviamo
    await notifier.savePurchase();

    // ASSERT
    verify(mockPurchaseRepository.updatePurchase(any)).called(1);
    verifyNever(mockPurchaseRepository.addPurchase(any));
  });

  test('reset correctly clears the state', () {
    // ARRANGE: sporchiamo lo stato
    final notifier = container.read(cartProvider.notifier);
    notifier.addItem(tItem);
    notifier.setStoreName('Test Store');

    // ACT: resettiamo
    notifier.reset();

    // ASSERT: lo stato deve tornare a quello iniziale
    final newState = container.read(cartProvider);
    expect(newState.items, isEmpty);
    expect(newState.storeName, isNull);
    expect(newState.total, 0.0);
  });
}
