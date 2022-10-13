import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_booking_app/models/tutor.dart';
import 'package:flutter_booking_app/pages/chats/model/user.dart';

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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('reviews')
              .doc(widget.tutorId)
              .collection('userReviews')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: (snapshot.data! as QuerySnapshot).docs.map((document) {
                return Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 6,

                    // child: Text("Review's name: " + document["email"]),
                    child: Card(
                      child: Material(
                        child: InkWell(
                          child: ListTile(
                            /* leading: CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                
                            ),*/
                            title: Text(
                              document["email"],
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            subtitle: Text(
                              document["response"],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            trailing: Text(
                              '${document["rating"]}',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}

class Single_prod extends StatelessWidget {
  final Tutor tutor;
  final String tutorId;

  Single_prod({required this.tutorId, required this.tutor});
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        child: Card(
          child: Material(
            child: InkWell(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(tutor.avatar),
                ),
                title: Text(
                  tutor.name,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                subtitle: Text(
                  tutor.bio,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                trailing: Text(
                  "\$${tutor.price}/hr",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
            ),
          ),
        ));
  }
}
