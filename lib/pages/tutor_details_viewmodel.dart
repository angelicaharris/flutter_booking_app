import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_booking_app/pages/tutor_booking.dart';
import 'package:uuid/uuid.dart';

class TutorDetailsViewModel {
  String? lessonIdRetrieved;
  final StreamController<String> _bookNow = StreamController.broadcast();
  Stream<String> get bookNow => _bookNow.stream;

  final CollectionReference _tutorBookingRef =
      FirebaseFirestore.instance.collection("tutors");

  void bookTutor(
      {required TutorBooking bookingRequest, required String tutorId}) async {
    _bookNow.sink.add("");

    try {
      String? currentUId = FirebaseAuth.instance.currentUser?.uid;
      String? name = FirebaseAuth.instance.currentUser?.displayName;
      String? email = FirebaseAuth.instance.currentUser?.email;

      bookingRequest.studentId = currentUId;
      bookingRequest.name = name;
      bookingRequest.email = email;

      final result = await _tutorBookingRef
          .doc(tutorId)
          .collection("bookings")
          .add(bookingRequest.toJson());
      _bookNow.sink.add("Successfully booked!");

      FirebaseFirestore.instance
          .collection('tutors')
          .doc(tutorId)
          .collection('bookings')
          .doc(result.id)
          .update({'lessonId': result.id});
      print("lesson ID HERE,  {$bookingRequest.lessonId}");
    } catch (msg, trace) {
      _bookNow.sink.addError("An error occurred while...");
    }
  }
}
