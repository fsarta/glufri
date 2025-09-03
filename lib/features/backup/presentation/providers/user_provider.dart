import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/backup/domain/auth_repository.dart';
import 'package:glufri/features/backup/domain/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _userCacheKey = 'lastKnownUser';

class UserNotifier extends StateNotifier<UserModel?> {
  final Ref _ref;
  UserNotifier(this._ref) : super(null) {
    // 1. Prova a caricare l'utente dalla cache all'avvio
    _loadUserFromCache();
    // 2. Ascolta i cambiamenti di stato di Firebase
    _listenToAuthChanges();
  }
  void _listenToAuthChanges() {
    _ref.listen(authStateChangesProvider, (previous, authState) async {
      final user = authState.value;
      if (user != null) {
        // Utente loggato online: aggiorna stato e cache
        final userModel = UserModel(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
        );
        state = userModel;
        await _saveUserToCache(userModel);
      } else {
        // Utente ha fatto logout: pulisci stato e cache
        state = null;
        await _clearUserCache();
      }
    });
  }

  Future<void> _loadUserFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userCacheKey);
    if (jsonString != null) {
      state = UserModel.fromJson(json.decode(jsonString));
    }
  }

  Future<void> _saveUserToCache(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userCacheKey, json.encode(user.toJson()));
  }

  Future<void> _clearUserCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userCacheKey);
  }

  // Esegue il logout e si assicura che lo stato locale sia aggiornato
  Future<void> signOut() async {
    await _ref.read(authRepositoryProvider).signOut();
    // Il listener di authChanges farà il resto
  }
}

// Il provider che la UI userà per ottenere lo stato dell'utente (anche offline)
final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier(ref);
});
