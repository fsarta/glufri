// lib/features/settings/presentation/providers/support_providers.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glufri/features/settings/data/models/faq_model.dart';

/// Provider che recupera tutte le FAQ da Firestore una sola volta.
final faqListProvider = FutureProvider<List<FaqModel>>((ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('faqs')
      .orderBy('order') // Ordina in base al campo 'order'
      .get();

  return snapshot.docs.map((doc) => FaqModel.fromFirestore(doc)).toList();
});

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
