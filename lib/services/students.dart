import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/pages/student_details.dart';

//my own imports
import 'package:flutter_booking_app/pages/tutor_details.dart';
import 'package:flutter_booking_app/models/student.dart';

import '../booking/screens/home_screen.dart';

class Students extends StatefulWidget {
  const Students({Key? key, this.studentList}) : super(key: key);
  final List<Student>? studentList;
  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  @override
  Widget build(BuildContext context) {
    final data = widget.studentList;
    if (data == null) return CircularProgressIndicator();
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final student = data[index];
          return Padding(
            padding: const EdgeInsets.all(.1),
            child: Single_prod(studentId: student.docId, student: student),
          );
        });
  }
}

class Single_prod extends StatelessWidget {
  final Student student;
  final String studentId;

  Single_prod({required this.studentId, required this.student});
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        child: Card(
            child: Material(
          child: InkWell(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                //here we are passing the values of the product to the product detail page
                builder: (context) => StudentDetails(
                      student: student,
                      studentId: studentId,
                    ))),
            child: ListTile(
              leading: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(student.avatar),
              ),
              title: Text(
                student.name,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              subtitle: Text(
                student.bio,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              trailing: Text(
                "\$${student.price}/hr",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
          ),
        )));
  }
}
