import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:glufri/features/purchase/data/models/purchase_item_model.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';
import 'package:glufri/features/purchase/presentation/providers/purchase_providers.dart';

const _uuid = Uuid();

// Lo stato del carrello
class CartState {
  final String? originalPurchaseId;
  final List<PurchaseItemModel> items;
  final String? storeName;
  final double total;

  CartState({
    this.originalPurchaseId,
    this.items = const [],
    this.storeName,
    this.total = 0.0,
  });

  CartState copyWith({
    String? originalPurchaseId,
    List<PurchaseItemModel>? items,
    String? storeName,
  }) {
    final newItems = items ?? this.items;
    final newTotal = newItems.fold(0.0, (sum, item) => sum + item.subtotal);

    return CartState(
      originalPurchaseId: originalPurchaseId ?? this.originalPurchaseId,
      items: newItems,
      storeName: storeName ?? this.storeName,
      total: newTotal,
    );
  }
}

// Il Notifier che gestisce la logica del carrello
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  void addItem(PurchaseItemModel item) {
    state = state.copyWith(items: [...state.items, item]);
  }

  void updateItem(PurchaseItemModel updatedItem) {
    final newItems = [
      for (final item in state.items)
        if (item.id == updatedItem.id) updatedItem else item,
    ];
    state = state.copyWith(items: newItems);
  }

  void removeItem(String itemId) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != itemId).toList(),
    );
  }

  void setStoreName(String name) {
    state = state.copyWith(storeName: name);
  }

  void loadPurchase(PurchaseModel purchase, {bool isDuplicate = false}) {
    state = CartState(
      // Se è una duplicazione, l'ID originale è null, così verrà salvato come nuovo.
      // Se è una modifica, conserviamo l'ID originale per sovrascrivere.
      originalPurchaseId: isDuplicate ? null : purchase.id,
      items: List<PurchaseItemModel>.from(purchase.items), // Copia la lista!
      storeName: purchase.store,
      total: purchase.total,
    );
  }

  Future<void> savePurchase(WidgetRef ref) async {
    if (state.items.isEmpty) return;

    // Controlla se siamo in modalità modifica
    final isEditing = state.originalPurchaseId != null;

    final purchase = PurchaseModel(
      id: isEditing ? state.originalPurchaseId! : _uuid.v4(),
      date: DateTime.now(),
      store: state.storeName,
      total: state.total,
      items: state.items,
      currency: 'EUR', // o da impostazioni
    );

    final repository = ref.read(purchaseRepositoryProvider);

    if (isEditing) {
      await repository.updatePurchase(purchase);
    } else {
      await repository.addPurchase(purchase);
    }

    // Resetta il carrello dopo il salvataggio
    reset();

    // Invalida il provider della lista per forzare l'aggiornamento
    ref.invalidate(purchaseListProvider);
  }

  void reset() {
    state = CartState();
  }
}

// Il Provider effettivo che la UI userà
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
