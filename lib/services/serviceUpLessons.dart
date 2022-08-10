import 'package:flutter/material.dart';

//my own imports
import 'package:flutter_booking_app/models/modelUpLesson.dart';

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

  SingleLesson({required this.lesson});

  @override
  Widget build(BuildContext context) {
    String subjectNames = "";
    for (var element in lesson.subjectNames ?? []) {
      // ["hello", "world"] -> "hello, world"
      subjectNames += "$element,";
    }
    return Container(
      child: Column(
        children: <Widget>[
          Text(
              "${lesson.email} has booked ${lesson.lessonType} for ${lesson.duration}")
        ],
      ),
    );
  }
}
