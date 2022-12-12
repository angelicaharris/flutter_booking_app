import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Student {
  final String name;
  final String email;
  final String price;
  final String bio;
  final String avatar;
  final String docId;
  final Map<String, dynamic> interests;

  Student({
    required this.name,
    required this.email,
    required this.price,
    required this.bio,
    required this.interests,
    required this.avatar,
    required this.docId,
  });

  factory Student.fromDocument(Map doc, String id) {
    return Student(
      name: doc['name'] ?? 'Missing',
      email: doc['email'] ?? 'Missing',
      price: doc['price'] ?? 'Missing',
      bio: doc['bio'] ?? 'Missing',
      docId: id,
      avatar: doc['imageUrl'] ?? 'Missing',
      interests: doc['interests'] ?? 'Missing',
    );
  }
}

String priceFromDoc(DocumentSnapshot doc) {
  final key = 'price';
  final defaultValue = '0';

  final data = doc.data() as Map<String, dynamic>;
  if (data.containsKey(key)) {
    return data[key];
  }
  return defaultValue;
}
