// lib/features/settings/presentation/providers/support_providers.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/settings/data/models/faq_model.dart';
import 'package:glufri/features/settings/presentation/providers/settings_provider.dart';

/// Provider che recupera tutte le FAQ da Firestore una sola volta.
final faqListProvider = FutureProvider<List<FaqModel>>((ref) async {
  // Leggi il provider della lingua
  // Ottiene la locale corrente (es. Locale('it')) o null (sistema)
  final currentLocale = ref.watch(localeProvider);

  String languageCode;

  if (currentLocale != null) {
    // Se l'utente ha scelto una lingua specifica nell'app, usiamo quella.
    languageCode = currentLocale.languageCode;
  } else {
    // Se l'utente ha scelto "Sistema" (cioè currentLocale è null),
    // dobbiamo scoprire qual è la lingua del dispositivo.
    // Usiamo `WidgetsBinding` per accedere in modo sicuro alla locale di sistema.
    // Dobbiamo usare un trucco con `ambiguate` per evitare warning con le versioni più recenti di Flutter
    final platformLocale = ambiguate(
      WidgetsBinding.instance,
    )!.platformDispatcher.locale;
    languageCode = platformLocale.languageCode;
  }

  // Per sicurezza, se per qualche motivo il codice lingua non è supportato, facciamo fallback su 'en'
  const supportedLanguages = ['it', 'en', 'es', 'de', 'fr'];
  if (!supportedLanguages.contains(languageCode)) {
    languageCode = 'en';
  }

  final snapshot = await FirebaseFirestore.instance
      .collection('faqs')
      .orderBy('order')
      .get();

  // Passa il languageCode al costruttore
  return snapshot.docs
      .map((doc) => FaqModel.fromFirestore(doc, languageCode))
      .toList();
});

T? ambiguate<T>(T? value) => value;

/// Provider che gestisce il termine di ricerca inserito dall'utente
final faqSearchQueryProvider = StateProvider<String>((ref) => '');

/// Provider che FILTRA la lista di FAQ in base alla query di ricerca
final filteredFaqProvider = Provider<List<FaqModel>>((ref) {
  final allFaqs = ref.watch(faqListProvider).valueOrNull ?? [];
  final query = ref.watch(faqSearchQueryProvider).toLowerCase().trim();

  if (query.isEmpty) {
    return allFaqs;
  }

  return allFaqs.where((faq) {
    final questionMatch = faq.question.toLowerCase().contains(query);
    final answerMatch = faq.answer.toLowerCase().contains(query);
    final keywordMatch = faq.keywords.any(
      (keyword) => keyword.toLowerCase().contains(query),
    );
    return questionMatch || answerMatch || keywordMatch;
  }).toList();
});
