// lib/core/providers/connectivity_provider.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider che espone lo stato della connettività in tempo reale.
/// NOTA: Ora restituisce un Stream di una LISTA di risultati.
final connectivityStreamProvider = StreamProvider<List<ConnectivityResult>>((
  ref,
) {
  // `onConnectivityChanged` ora è uno Stream<List<ConnectivityResult>>
  return Connectivity().onConnectivityChanged;
});

/// Provider di convenienza che restituisce un booleano: `true` se c'è connessione, `false` altrimenti.
/// Questa è la parte che corregge il problema principale.
final hasConnectionProvider = Provider<bool>((ref) {
  final connectivityResultAsync = ref.watch(connectivityStreamProvider);

  return connectivityResultAsync.when(
    // Quando abbiamo i dati (una lista di risultati)
    data: (results) {
      // Se la lista contiene ConnectivityResult.none E la sua lunghezza è 1,
      // significa che l'unica "connessione" è nessuna connessione.
      if (results.contains(ConnectivityResult.none) && results.length == 1) {
        return false;
      }
      // In tutti gli altri casi (wifi, mobile, o una lista vuota che indica una transizione)
      // consideriamo l'utente connesso. Una lista vuota viene emessa brevemente su alcune
      // piattaforme durante il cambio di rete. Trattarla come 'connesso' è più sicuro
      // per evitare falsi negativi.
      return true;
    },
    // In caso di errore durante il recupero dello stato, assumiamo ottimisticamente di essere online
    error: (_, __) => true,
    // Mentre carica all'inizio, assumiamo ottimisticamente di essere online
    loading: () => true,
  );
});
