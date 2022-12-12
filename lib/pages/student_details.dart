import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_booking_app/models/student.dart';

import 'package:flutter_booking_app/pages/booking_dialog.dart';

import 'package:flutter_booking_app/pages/home.dart';
import 'package:flutter_booking_app/pages/reviews/reviewsDialog.dart';

import 'package:flutter_booking_app/pages/tutor_details_viewmodel.dart';

class StudentDetails extends StatefulWidget {
  final Student student;

  final tutoDetailViewModel = TutorDetailsViewModel();
  final String studentId;

  StudentDetails({required this.studentId, required this.student});

  @override
  State<StudentDetails> createState() => StudentDetailsState();
}

class StudentDetailsState extends State<StudentDetails> {
  double rating = 0.0;
  double checking = 0.0;
  String text = "";

  QuerySnapshot? usersSnap;
  getRating() {
    final db = FirebaseFirestore.instance;
    int counter = 0;

    db
        .collection("reviews")
        .doc(widget.studentId)
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
    for (var element in widget.student.interests.keys) {
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
          child: Text(widget.student.name),
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
                        image: NetworkImage(widget.student.avatar),
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
                      /*  showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Request a Lesson"),
                              content: BookingDialog(studentId: widget.studentId),
                            );
                          }
                          );*/
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
                    widget.student.bio,
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
                    "Price: \$" + widget.student.price,
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
