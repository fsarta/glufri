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

  factory FaqModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FaqModel(
      id: doc.id,
      question: data['question'] ?? '',
      answer: data['answer'] ?? '',
      keywords: List<String>.from(data['keywords'] ?? []),
    );
  }
}
