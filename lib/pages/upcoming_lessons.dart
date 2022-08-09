import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

//my imports

class UpCominngLessons extends StatefulWidget {
  const UpCominngLessons({Key? key}) : super(key: key);

  @override
  State<UpCominngLessons> createState() => _UpCominngLessonsState();
}

class _UpCominngLessonsState extends State<UpCominngLessons> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Upcoming Lessons'),
        actions: <Widget>[],
      ),
    );
  }
}
