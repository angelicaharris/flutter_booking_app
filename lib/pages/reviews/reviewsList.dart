import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

//my imports
import 'package:flutter_booking_app/models/student.dart';
import 'package:flutter_booking_app/pages/reviews/reviewsDialog.dart';
import 'package:flutter_booking_app/pages/reviews/reviewsService.dart';

class ReviewsList extends StatefulWidget {
  const ReviewsList({Key? key, this.reviewsList}) : super(key: key);
  final List<Student>? reviewsList;
  @override
  State<ReviewsList> createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {
  @override
  Widget build(BuildContext context) {
    final data = widget.reviewsList ?? [];

    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final student = data[index];
          return Padding(
            padding: const EdgeInsets.all(.1),
            child: Single_prod(student: student, studentId: student.docId),
          );
        });
  }
}

class Single_prod extends StatelessWidget {
  final Student student;
  final String studentId;

  Single_prod({required this.student, required this.studentId});
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
                  backgroundImage: NetworkImage(student.avatar),
                ),
                title: Text(
                  student.email,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
            ),
          ),
        ));
  }
}
