import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Tutor {
  final String name;
  final String email;
  final String price;
  final String bio;
  final String avatar;
  final String docId;
  final Map<String, dynamic> interests;

  Tutor(
      {required this.name,
      required this.email,
      required this.price,
      required this.bio,
      required this.interests,
      required this.avatar,
      required this.docId});

  factory Tutor.fromDocument(DocumentSnapshot doc) {
    return Tutor(
      name: doc['name'],
      email: doc['email'],
      price: priceFromDoc(doc),
      bio: doc['bio'],
      docId: doc.id,
      avatar: 'assets/images/c3.png',
      interests: doc['interests'],
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
