import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeViewModel {
  final CollectionReference _tutorBookingRef =
      FirebaseFirestore.instance.collection("users");

  StreamController<String> _searchInterests = StreamController();
  Stream<String> get searchInterests => _searchInterests.stream;

  void search(String text, String uId) async {
    try {
      final result = _tutorBookingRef.doc(uId).get();
      print("result => $result");
    } catch (e) {
      print("result => $e");
    }
  }
}
