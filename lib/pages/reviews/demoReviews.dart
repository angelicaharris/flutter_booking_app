import 'dart:async';
import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_booking_app/models/student.dart';
import 'package:flutter_booking_app/models/tutor.dart';
import 'package:flutter_booking_app/pages/chats/model/user.dart';
import 'package:flutter_booking_app/pages/reviews/reviewsService.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class DemoReviews extends StatefulWidget {
  const DemoReviews({super.key, required this.tutorId});
  final String tutorId;
  @override
  State<DemoReviews> createState() => _DemoReviewsState();
}

class _DemoReviewsState extends State<DemoReviews> {
  //final User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      body: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: new ListView(
          children: <Widget>[
            Center(child: Text('testing')),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('reviews')
                    .doc(widget.tutorId)
                    .collection('userReviews')
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
                                      starCount: 5,
                                      rating: document["rating"],
                                      size: 40.0,
                                      halfFilledIconData: Icons.blur_on,
                                      color: Colors.yellow,
                                      borderColor: Colors.yellow,
                                      spacing: 0.0),
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
