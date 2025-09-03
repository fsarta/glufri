import '../../domain/repositories/purchase_repository.dart';
import '../datasources/purchase_local_datasource.dart';
import '../models/purchase_model.dart';

// L'implementazione concreta che usa il datasource
class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseLocalDataSource localDataSource;

  PurchaseRepositoryImpl(this.localDataSource);

  @override
  Future<void> addPurchase(PurchaseModel purchase) {
    return localDataSource.addPurchase(purchase);
  }

  @override
  Future<void> deletePurchase(String purchaseId) {
    return localDataSource.deletePurchase(purchaseId);
  }

  @override
  Future<void> updatePurchase(PurchaseModel purchase) {
    return localDataSource.updatePurchase(purchase);
  }

  @override
  Future<List<PurchaseModel>> getPurchases() {
    return localDataSource.getPurchases();
  }
}
