import 'package:cloud_firestore/cloud_firestore.dart';

class FaqModel {
  final String id;
  final String question;
  final String answer;
  final List<String> keywords;

  const FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.keywords,
  });

  factory FaqModel.fromFirestore(DocumentSnapshot doc, String languageCode) {
    final data = doc.data() as Map<String, dynamic>;
    final translations = data['translations'] as Map<String, dynamic>? ?? {};

    // 1. Cerca la traduzione per la lingua corrente (es. "it")
    // 2. Se non la trova, usa l'inglese ("en") come lingua di fallback
    // 3. Se non trova neanche l'inglese, usa una mappa vuota per evitare errori
    final langData = translations[languageCode] ?? translations['en'] ?? {};

    return FaqModel(
      id: doc.id,
      // Estrai la domanda dalla mappa della lingua scelta
      question: langData['question'] ?? 'No question available',
      // Estrai la risposta dalla mappa della lingua scelta
      answer: langData['answer'] ?? 'No answer available',
      keywords: List<String>.from(langData['keywords'] ?? []),
    );
  }
}
