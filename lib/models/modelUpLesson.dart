import 'package:cloud_firestore/cloud_firestore.dart';

class ModelUpcomingLesson {
  final String? name;
  final String email;
  final String duration;
  final String lessonType;
  final int date;
  final List<String>? subjectNames;

  ModelUpcomingLesson(
      {this.name,
      required this.email,
      required this.duration,
      required this.lessonType,
      required this.date,
      this.subjectNames});

  factory ModelUpcomingLesson.fromDocument(Map<String, dynamic> doc) {
    return ModelUpcomingLesson(
        name: doc['name'],
        email: doc['email'],
        duration: doc['duration'],
        lessonType: doc['lessonType'],
        date: doc['startDateTime'],
        subjectNames: doc['subjectNames']);
  }
}
