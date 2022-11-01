import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/modelUpLesson.dart';

//my imports
import 'package:flutter_booking_app/services/serviceUpLessons.dart';

class UpCominngLessons extends StatefulWidget {
  const UpCominngLessons({Key? key}) : super(key: key);

  @override
  State<UpCominngLessons> createState() => _UpCominngLessonsState();
}

class _UpCominngLessonsState extends State<UpCominngLessons> {
  // <--- Firebase get users from collection --->
  //QuerySnapshot? lessonsSnap;

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
        .orderBy('startDateTime')
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
    // TODO: implement initState
    super.initState();

    getLessons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          elevation: 0.1,
          backgroundColor: Colors.blueGrey,
          title: Text('Upcoming Lessons'),
          actions: <Widget>[],
        ),
        body: StreamBuilder<List<ModelUpcomingLesson>>(
          stream: modelUpcomingLesson,
          builder: (BuildContext context,
              AsyncSnapshot<List<ModelUpcomingLesson>> snapshot) {
            if (snapshot.hasError) {
              print("error occurred");
            }
            getLessons();
            return ServiceUpLessons(upcomingLessonList: snapshot.data);
          },
        ));
  }
}
