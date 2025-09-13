import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// 1. La classe di stato che contiene tutti i filtri applicabili
@immutable
class PurchaseFilterState {
  final String searchQuery;
  final DateTimeRange? dateRange;
  // Altri filtri potrebbero essere aggiunti qui, es. `String? selectedStore;`

  const PurchaseFilterState({this.searchQuery = '', this.dateRange});

  PurchaseFilterState copyWith({
    String? searchQuery,
    DateTimeRange? dateRange,
    bool clearDateRange = false,
  }) {
    return PurchaseFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      // Se 'clearDateRange' è true, imposta dateRange a null, altrimenti prendi
      // il nuovo valore o mantieni il vecchio
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
    );
  }
}

// 2. Lo StateNotifier che gestisce la logica di aggiornamento dei filtri
class PurchaseFilterNotifier extends StateNotifier<PurchaseFilterState> {
  // 2. Aggiungi un Timer come variabile privata
  Timer? _debounce;

  PurchaseFilterNotifier() : super(const PurchaseFilterState());

  void setSearchQuery(String query) {
    // Se c'è un timer attivo, cancellalo.
    // Questo succede se l'utente digita un altro carattere prima della scadenza.
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Fai partire un nuovo timer.
    _debounce = Timer(const Duration(milliseconds: 250), () {
      // Quando il timer scade (dopo 250ms di inattività),
      // aggiorna lo stato con la nuova query.
      // Questo è l'unico punto in cui lo stato viene effettivamente modificato,
      // scatenando il rebuild dei widget in ascolto.
      state = state.copyWith(searchQuery: query);
    });
  }

  void setDateRange(DateTimeRange? range) {
    state = state.copyWith(dateRange: range);
  }

  void clearDateRange() {
    state = state.copyWith(clearDateRange: true);
  }

  void clearFilters() {
    state = const PurchaseFilterState();
  }

  // 4. Aggiungi un metodo dispose per pulire il timer
  //    quando il provider non è più utilizzato. È una buona pratica.
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

// 3. Il provider effettivo
final purchaseFilterProvider =
    StateNotifierProvider<PurchaseFilterNotifier, PurchaseFilterState>((ref) {
      return PurchaseFilterNotifier();
    });
