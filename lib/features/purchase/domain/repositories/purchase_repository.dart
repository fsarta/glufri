import '../../data/models/purchase_model.dart';

// Questo è il "contratto" che il dominio si aspetta.
abstract class PurchaseRepository {
  Future<List<PurchaseModel>> getPurchases();
  Future<void> addPurchase(PurchaseModel purchase);
  Future<void> deletePurchase(String purchaseId);
  Future<void> updatePurchase(PurchaseModel purchase);
}
