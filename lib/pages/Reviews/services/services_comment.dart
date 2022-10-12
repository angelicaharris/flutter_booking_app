import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_booking_app/pages/Reviews/model/model_comment.dart';
import 'package:flutter_booking_app/utils/transform_utils.dart';
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

  void getLessons() {
    final db = FirebaseFirestore.instance;
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    db
        .collection("reviews")
        .doc(currentUser.uid)
        .collection("bookings")
        .get()
        .then(
      (res) {
        print("Error completing: ${res.docs.length}");
        res.docs.forEach((element) {
          print("Error completing: ${element.data()}");
        });
        final docs =
            res.docs.map((e) => TutorReviews.fromJson(e.data())).toList();
        // parse data to our model //
        //_postReview.sink.add(docs);
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  Stream<List<TutorReviews>> getMessages(String idUser) =>
      FirebaseFirestore.instance
          .collection('reviews')
          .snapshots()
          .transform(Utils.transformer(TutorReviews.fromJson));
}
