import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  const UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });

  // Metodo per convertire da/in JSON, utile per shared_preferences
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }
}
