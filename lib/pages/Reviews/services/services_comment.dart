import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_booking_app/pages/Reviews/model/model_comment.dart';
import 'package:uuid/uuid.dart';

class TutorReviewServices {
  final StreamController<String> _postReview = StreamController.broadcast();
  Stream<String> get postReview => _postReview.stream;

  final CollectionReference _tutorReviews =
      FirebaseFirestore.instance.collection("reviews");

  void postTutorReview(
      {required TutorReviews postReviews, required String tutorId}) async {
    _postReview.sink.add("");

    try {
      String? currentUId = FirebaseAuth.instance.currentUser?.uid;
      String? name = FirebaseAuth.instance.currentUser?.displayName;
      String? email = FirebaseAuth.instance.currentUser?.email;
      String? mediaUrl = FirebaseAuth.instance.currentUser?.photoURL;

      postReviews.studentId = currentUId;
      postReviews.studentName = name;
      postReviews.studentEmail = email;
      postReviews.studentMediaUrl = mediaUrl;

      final result = await _tutorReviews
          .doc(tutorId)
          .collection("reviews")
          .add(postReviews.toJson());
      _postReview.sink.add("Successfully booked!");
    } catch (msg, trace) {
      _postReview.sink.addError("An error occurred while...");
    }
  }
}
