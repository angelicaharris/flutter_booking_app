import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_booking_app/main.dart';
import 'package:flutter_booking_app/models/modelUpLesson.dart';
import 'package:flutter_booking_app/models/student.dart';
import 'package:flutter_booking_app/models/tutor.dart';
import 'package:flutter_booking_app/pages/booking_dialog.dart';

import 'package:flutter_booking_app/pages/home.dart';
import 'package:flutter_booking_app/pages/reviews/demoReviews.dart';
import 'package:flutter_booking_app/pages/reviews/reviewsDialog.dart';
import 'package:flutter_booking_app/pages/reviews/reviewsList.dart';
import 'package:flutter_booking_app/pages/reviews/reviewsService.dart';
import 'package:flutter_booking_app/pages/tutor_details_viewmodel.dart';
import 'package:flutter_booking_app/services/serviceUpLessons.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductDetails extends StatefulWidget {
  final Tutor tutor;

  final tutoDetailViewModel = TutorDetailsViewModel();
  final String tutorId;

  ProductDetails({required this.tutorId, required this.tutor});

  @override
  State<ProductDetails> createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  final StreamController<List<ModelUpcomingLesson>> _modelUpcomingLesson =
      StreamController.broadcast();
  Stream<List<ModelUpcomingLesson>> get modelUpcomingLesson =>
      _modelUpcomingLesson.stream;

  void getLessons() {
    final db = FirebaseFirestore.instance;
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    db
        .collection("tutors")
        .doc(currentUser.uid)
        .collection("bookings")
        .get()
        .then(
      (res) {
        print("Error completing: ${res.docs.length}");
        res.docs.forEach((element) {
          print("Error completing: ${element.data()}");
        });
        final docs = res.docs
            .map((e) => ModelUpcomingLesson.fromDocument(e.data()))
            .toList();
        // parse data to our model //
        _modelUpcomingLesson.sink.add(docs);
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  void initState() {
    final bookNow = widget.tutoDetailViewModel.bookNow;
    bookNow.listen((event) {
      if (event.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Booking tutor...")));
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(event)));
    }, onError: (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
    super.initState();
    getLessons();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.1,
        backgroundColor: Colors.grey,
        title: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new HomePage()));
          },
          child: Text(widget.tutor.name),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: new ListView(
          children: <Widget>[
            Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: Ink.image(
                        image: NetworkImage(widget.tutor.avatar),
                        fit: BoxFit.cover,
                        width: 128,
                        height: 128,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      onPrimary: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text('Schedule Lesson'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Request a Lesson"),
                              content: BookingDialog(tutorId: widget.tutorId),
                            );
                          });
                    })),
            const SizedBox(height: 24),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.tutor.bio,
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                  Text(
                    "Price: \$" + widget.tutor.price,
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Reviews',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      onPrimary: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text('Post a Review'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Write Review"),
                              content: ReviewsDialog(tutorId: widget.tutorId),
                            );
                          });
                    })),
            const SizedBox(height: 24),
            Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      onPrimary: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text('Read Reviews'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  new DemoReviews(tutorId: widget.tutorId)));
                    })),
            /* Flexible(
                child: reviewsList!.isNotEmpty
                    ? ReviewsList(reviewsList: reviewsList)
                    : Text("No Reviews")),*/
          ],
        ),
      ),
    );
  }
}
