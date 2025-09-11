import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glufri/features/purchase/data/models/purchase_model.dart';

abstract class PurchaseRemoteDataSource {
  Future<void> savePurchase(PurchaseModel purchase);
  Future<void> deletePurchase(String purchaseId);
}

class PurchaseFirestoreDataSource implements PurchaseRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PurchaseFirestoreDataSource(this._firestore, this._auth);

  // Un utente non autenticato non può scrivere sul cloud.
  User? get _currentUser => _auth.currentUser;

  @override
  Future<void> savePurchase(PurchaseModel purchase) async {
    // Se non c'è un utente loggato, non fare nulla.
    if (_currentUser == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('purchases')
        .doc(purchase.id);

    // .set() crea il documento se non esiste o lo sovrascrive se esiste già.
    // Perfetto per gestire sia l'aggiunta che la modifica.
    await docRef.set(purchase.toJson());
  }

  @override
  Future<void> deletePurchase(String purchaseId) async {
    if (_currentUser == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(_currentUser!.uid)
        .collection('purchases')
        .doc(purchaseId);

    await docRef.delete();
  }
}
