import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_booking_app/pages/tutor_booking.dart';

class TutorDetailsViewModel {
  final StreamController<String> _bookNow = StreamController.broadcast();
  Stream<String> get bookNow => _bookNow.stream;

  final CollectionReference _tutorBookingRef =
      FirebaseFirestore.instance.collection("tutors");

  void bookTutor({String tutorId = "noUserId"}) async {
    _bookNow.sink.add("");
    try {
      String? currentUId = FirebaseAuth.instance.currentUser?.uid;
      final result =
          await _tutorBookingRef.doc(tutorId).set({"$currentUId": true});
      _bookNow.sink.add("Successfully booked!");
    } catch (msg, trace) {
      _bookNow.sink.addError("An error occurred while...");
    }
  }
}
