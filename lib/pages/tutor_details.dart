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
import 'package:flutter_booking_app/pages/reviews/reviewsDialog.dart';

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
  double rating = 0.0;
  double checking = 0.0;
  String text = "";

  QuerySnapshot? usersSnap;
  getRating() {
    final db = FirebaseFirestore.instance;
    int counter = 0;

    db
        .collection("reviews")
        .doc(widget.tutorId)
        .collection('userReviews')
        .where('rating', isGreaterThan: 0)
        .get()
        .then(
      (res) {
        usersSnap = res;
        counter = res.docs.length;
        var values = res.docs.map((doc) => doc['rating'] as double);
        var sum = values.fold<double>(0.0, (a, b) => a + b);
        // update ui
        if (counter == 0) {
          counter = 1;
        }
        rating = sum / counter.toDouble();
        setState(() {});
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
    getRating();
    for (var element in widget.tutor.interests.keys) {
      text += element + "\n";
    }
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
                  Text(
                    widget.tutor.bio,
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const Divider(
                    height: 15,
                    thickness: .5,
                    indent: 10,
                    endIndent: 0,
                    color: Colors.black,
                  ),
                  Text(
                    text,
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                  Text(
                    "Price: \$" + widget.tutor.price,
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Ratings',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SmoothStarRating(
                      allowHalfRating: false,
                      starCount: 5,
                      rating: rating,
                      size: 40.0,
                      halfFilledIconData: Icons.star_half,
                      color: Colors.yellow,
                      borderColor: Colors.yellow,
                      spacing: 0.0),
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
                          EdgeInsets.symmetric(horizontal: 32, vertical: 5),
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
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('reviews')
                    .doc(widget.tutorId)
                    .collection('userReviews')
                    .orderBy('datePosted', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    children:
                        (snapshot.data! as QuerySnapshot).docs.map((document) {
                      return Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: MediaQuery.of(context).size.height / 6,
                          child: Card(
                            child: Material(
                              child: InkWell(
                                child: ListTile(
                                  title: Text(
                                    document["email"],
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  subtitle: Text(
                                    document["response"],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey),
                                  ),
                                  trailing: SmoothStarRating(
                                      allowHalfRating: false,
                                      starCount: 5,
                                      rating: document["rating"],
                                      size: 40.0,
                                      halfFilledIconData: Icons.blur_on,
                                      color: Colors.yellow,
                                      borderColor: Colors.yellow,
                                      spacing: 0.0),
                                  leading: Text(document["datePosted"]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
