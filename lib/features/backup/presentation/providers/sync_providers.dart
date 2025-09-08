// lib/features/backup/presentation/providers/sync_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Un provider che indica se è in corso un'operazione di sincronizzazione
/// (backup, ripristino, etc.). La UI può ascoltarlo per mostrare
/// un indicatore di caricamento globale.
final syncInProgressProvider = StateProvider<bool>((ref) => false);
