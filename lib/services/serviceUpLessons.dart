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
    //if (data == null) return CircularProgressIndicator();
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

class SingleLesson extends StatelessWidget {
  final ModelUpcomingLesson lesson;

  SingleLesson({required this.lesson});

  @override
  Widget build(BuildContext context) {
    String subjectNames = "";
    for (var element in lesson.subjectNames ?? []) {
      // ["hello", "world"] -> "hello, world"
      subjectNames += "$element,";
    }
    final dateFormat = DateFormat("MM-dd-yyyy hh:mm");
    final formattedDate = dateFormat
        .format(DateTime.fromMicrosecondsSinceEpoch(lesson.date * 1000));
    return Container(
      height: 200,
      color: Colors.lightBlue,
      child: Column(
        children: <Widget>[
          Text(
            "Student's name: ${lesson.email} ",
            style:
                TextStyle(height: 5, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            "Date: $formattedDate",
            style:
                TextStyle(height: 1, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            "Lesson Type: ${lesson.lessonType}",
            style:
                TextStyle(height: 1, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            "Duration: ${lesson.duration}",
            style:
                TextStyle(height: 1, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          new Center(
            child: new ButtonBar(
              mainAxisSize: MainAxisSize
                  .min, // this will take space as minimum as posible(to center)
              children: <Widget>[
                new ElevatedButton(
                  child: new Text('Accept'),
                  onPressed: null,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)),
                ),
                new ElevatedButton(
                  child: new Text('Decline'),
                  onPressed: () {
                    final docUser = FirebaseFirestore.instance
                        .collection("tutors")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection("bookings")
                        .doc(lesson.lessonId);

                    docUser.delete();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
