import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//my own imports
import 'package:flutter_booking_app/pages/home.dart';

class StudentSurvey extends StatefulWidget {
  const StudentSurvey({Key? key, required this.userId}) : super(key: key);
  final String userId;
  @override
  State<StudentSurvey> createState() => _StudentSurveyState();
}

class _StudentSurveyState extends State<StudentSurvey> {
  Map<String, bool> map = {
    'ACT English': false,
    'ACT Math': false,
    'ACT Reading': false,
    'ACT Science': false,
    'ACT Writing': false,
    'SAT English': false,
    'SAT Reading': false,
    'SAT Math': false
  };

  Future<void> saveSubjects(String userId) async {
    final db = FirebaseFirestore.instance;
    final data = {"interests": map};
    await db
        .collection("users")
        .doc(userId)
        .update(data)
        .onError((error, stackTrace) => null);
  }

  @override
  Widget build(BuildContext context) {
    final options = <Widget>[];

    map.forEach((key, value) {
      final tile = CheckboxListTile(
        title: Text(key),
        value: value,
        onChanged: (bool? newValue) {
          map.update(key, (_) => newValue!);
          setState(() {});
        },
      );
      options.add(tile);
    });

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await saveSubjects(widget.userId);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        },
        label: const Text('Confirm'),
      ),
    );
  }
}
