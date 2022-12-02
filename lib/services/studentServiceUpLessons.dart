import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//my own imports
import 'package:flutter_booking_app/models/modelUpLesson.dart';
//import 'package:flutter_booking_app/pages/chats/model/user.dart';
import 'package:intl/intl.dart';

class StudentServiceUpLessons extends StatefulWidget {
  StudentServiceUpLessons({Key? key, this.upcomingLessonList})
      : super(key: key);
  final List<ModelUpcomingLesson>? upcomingLessonList;
  @override
  State<StudentServiceUpLessons> createState() =>
      _StudentServiceUpLessonsState();
}

class _StudentServiceUpLessonsState extends State<StudentServiceUpLessons> {
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
            "Tutor's name: ${widget.lesson.email} ",
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
        ],
      ),
    );
  }
}
