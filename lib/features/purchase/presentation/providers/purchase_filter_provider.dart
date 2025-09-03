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
  }) {
    return PurchaseFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      dateRange: dateRange ?? this.dateRange,
    );
  }
}

// 2. Lo StateNotifier che gestisce la logica di aggiornamento dei filtri
class PurchaseFilterNotifier extends StateNotifier<PurchaseFilterState> {
  PurchaseFilterNotifier() : super(const PurchaseFilterState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setDateRange(DateTimeRange range) {
    state = state.copyWith(dateRange: range);
  }

  void clearFilters() {
    state = const PurchaseFilterState();
  }
}

// 3. Il provider effettivo
final purchaseFilterProvider =
    StateNotifierProvider<PurchaseFilterNotifier, PurchaseFilterState>((ref) {
      return PurchaseFilterNotifier();
    });
