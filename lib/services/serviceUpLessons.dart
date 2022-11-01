import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//my own imports
import 'package:flutter_booking_app/models/modelUpLesson.dart';
import 'package:flutter_booking_app/pages/chats/model/user.dart';
import 'package:intl/intl.dart';

class ServiceUpLessons extends StatefulWidget {
  ServiceUpLessons({Key? key, this.upcomingLessonList}) : super(key: key);
  final List<ModelUpcomingLesson>? upcomingLessonList;
  @override
  State<ServiceUpLessons> createState() => _ServiceUpLessonsState();
}

class _ServiceUpLessonsState extends State<ServiceUpLessons> {
  @override
  Widget build(BuildContext context) {
    final data = widget.upcomingLessonList ?? [];
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            final lesson = data[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: SingleLesson(lesson: lesson),
            );
          }),
    );
  }
}

class SingleLesson extends StatefulWidget {
  final ModelUpcomingLesson lesson;
  const SingleLesson({super.key, required this.lesson});

  @override
  State<SingleLesson> createState() => _SingleLessonState();
}

class _SingleLessonState extends State<SingleLesson> {
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("MM-dd-yyyy hh:mm");
    final formattedDate = dateFormat
        .format(DateTime.fromMicrosecondsSinceEpoch(widget.lesson.date * 1000));
    return Container(
      height: 200,
      color: Colors.lightBlue,
      child: Column(
        children: <Widget>[
          Text(
            "Student's name: ${widget.lesson.email} ",
            style:
                TextStyle(height: 5, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            "Date: $formattedDate",
            style:
                TextStyle(height: 1, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            "Lesson Type: ${widget.lesson.lessonType}",
            style:
                TextStyle(height: 1, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            "Duration: ${widget.lesson.duration}",
            style:
                TextStyle(height: 1, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          new Center(
            child: widget.lesson.lessonConfirmed == false
                ? ButtonBar(
                    mainAxisSize: MainAxisSize
                        .min, // this will take space as minimum as posible(to center)
                    children: <Widget>[
                      new ElevatedButton(
                        child: new Text('Accept'),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green)),
                        onPressed: () {
                          final docUser = FirebaseFirestore.instance
                              .collection("tutors")
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .collection("bookings")
                              .doc(widget.lesson.lessonId);

                          docUser.update({"lessonConfirmed": true});

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Lesson Request Confirmed')));
                        },
                      ),
                      new ElevatedButton(
                          child: new Text('Decline'),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Delete'),
                                  content:
                                      Text('Are you sure you want to delete?'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel')),
                                    ElevatedButton(
                                        onPressed: () {
                                          final docUser = FirebaseFirestore
                                              .instance
                                              .collection("tutors")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser?.uid)
                                              .collection("bookings")
                                              .doc(widget.lesson.lessonId);

                                          docUser.delete().whenComplete(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text('Delete'))
                                  ],
                                );
                              },
                            );
                          }),
                    ],
                  )
                : Text(''),
          ),
        ],
      ),
    );
  }
}
