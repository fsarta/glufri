import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/core/utils/debug_overrides.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
// Per un mock, possiamo usare anche shared_preferences
// import 'package:shared_preferences/shared_preferences.dart';

// ID del tuo abbonamento su Play Store/App Store
const String _subscriptionId = 'glufri_pro_yearly';

class MonetizationState {
  final bool isPro;
  final bool isProStatusLoading;

  MonetizationState({this.isPro = false, this.isProStatusLoading = true});
}

class MonetizationNotifier extends StateNotifier<MonetizationState> {
  late final StreamSubscription<List<PurchaseDetails>> _subscription;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  MonetizationNotifier() : super(MonetizationState()) {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        // Gestisci errore
      },
    );
    _initInAppPurchase();
  }

  Future<void> _initInAppPurchase() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      state = MonetizationState(isPro: false, isProStatusLoading: false);
      return;
    }
    // Recupera acquisti precedenti
    await _inAppPurchase.restorePurchases();
  }

  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    bool isProUser = state.isPro;
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        if (purchaseDetails.productID == _subscriptionId) {
          isProUser = true;
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
    state = MonetizationState(isPro: isProUser, isProStatusLoading: false);
  }

  Future<void> purchasePro() async {
    final ProductDetailsResponse response = await _inAppPurchase
        .queryProductDetails({_subscriptionId});
    if (response.notFoundIDs.isNotEmpty) return; // Prodotto non trovato

    final ProductDetails productDetails = response.productDetails.first;
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final monetizationProvider =
    StateNotifierProvider<MonetizationNotifier, MonetizationState>((ref) {
      return MonetizationNotifier();
    });

// Provider semplice per sapere se l'utente è PRO
final isProUserProvider = Provider<bool>((ref) {
  // Ora "osserviamo" il nostro nuovo provider di debug
  final isDebugOverrideActive = ref.watch(debugProVersionOverrideProvider);

  // La logica rimane la stessa, ma ora è REATTIVA
  if (kDebugMode && isDebugOverrideActive) {
    return true;
  }

  // Altrimenti (sia in debug senza override che in release), usa la logica reale.
  return ref.watch(monetizationProvider).isPro;
});
