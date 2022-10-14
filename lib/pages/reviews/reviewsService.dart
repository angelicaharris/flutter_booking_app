import 'package:flutter/material.dart';
import 'package:flutter_booking_app/models/student.dart';

//my own imports

import 'package:intl/intl.dart';

class ReviewService extends StatefulWidget {
  const ReviewService({Key? key, this.upcomingLessonList}) : super(key: key);
  final List<Student>? upcomingLessonList;
  @override
  State<ReviewService> createState() => _ServiceUpLessonsState();
}

class _ServiceUpLessonsState extends State<ReviewService> {
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
  final Student lesson;
  //final String lessonId;
//how a lesson looks
  SingleLesson({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.lightBlue,
      child: Column(
        children: <Widget>[
          Text(
            "Student's name: ${lesson.email} ",
            style:
                TextStyle(height: 5, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
