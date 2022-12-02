import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_booking_app/models/studentBooking.dart';
import 'package:flutter_booking_app/pages/tutor_booking.dart';
import 'package:uuid/uuid.dart';

class TutorDetailsViewModel {
  final StreamController<String> _bookNow = StreamController.broadcast();
  Stream<String> get bookNow => _bookNow.stream;

  final CollectionReference _tutorBookingRef =
      FirebaseFirestore.instance.collection("tutors");

  final StreamController<String> _studentBookNow = StreamController.broadcast();
  Stream<String> get studentBookNow => _studentBookNow.stream;

  final CollectionReference _studentBookingRef =
      FirebaseFirestore.instance.collection("student");

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

  ///STUDENT BOOKING DATABASE

  void studentBookings(
      {required StudentBooking bookingRequest, required String tutorId}) async {
    _studentBookNow.sink.add("");

    try {
      bookingRequest.tutorId = tutorId;

      final result = await _studentBookingRef
          .doc(tutorId)
          .collection("bookings")
          .add(bookingRequest.toJson());
      _studentBookNow.sink.add("Successfully booked!");

      FirebaseFirestore.instance
          .collection('students')
          .doc(tutorId)
          .collection('bookings')
          .doc(result.id)
          .update({'lessonId': result.id});
      print("lesson ID HERE,  {$bookingRequest.lessonId}");
    } catch (msg, trace) {
      _studentBookNow.sink.addError("An error occurred while...");
    }
  }
}
