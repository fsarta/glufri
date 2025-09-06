// lib/core/utils/debug_overrides.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider che contiene lo stato di override della versione Pro (solo per debug).
/// `StateProvider` è il tipo di provider più semplice che permette
/// alla UI di modificare il suo stato.
final debugProVersionOverrideProvider = StateProvider<bool>((ref) {
  // Il valore iniziale è sempre 'false'
  return false;
});
