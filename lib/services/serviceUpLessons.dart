import 'package:flutter/material.dart';

//my own imports
import 'package:flutter_booking_app/models/modelUpLesson.dart';
import 'package:intl/intl.dart';

class ServiceUpLessons extends StatefulWidget {
  const ServiceUpLessons({Key? key, this.upcomingLessonList}) : super(key: key);
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
            // final lesson = ModelUpcomingLesson.fromDocument(doc);
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
  //final String lessonId;
//how a lesson looks
  SingleLesson({required this.lesson});

  @override
  Widget build(BuildContext context) {
    String subjectNames = "";
    for (var element in lesson.subjectNames ?? []) {
      // ["hello", "world"] -> "hello, world"
      subjectNames += "$element,";
    }
    final dateFormat = DateFormat("yyyy-MM-dd hh:mm");
    final formattedDate = dateFormat
        .format(DateTime.fromMicrosecondsSinceEpoch(lesson.date * 1000));
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
        ],
      ),
    );
  }
}
