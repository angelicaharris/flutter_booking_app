import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//my own imports
import 'package:flutter_booking_app/pages/tutor_details.dart';
import 'package:flutter_booking_app/models/tutor.dart';

class Tutors extends StatefulWidget {
  const Tutors({Key? key, this.tutorList}) : super(key: key);
  final List<Tutor>? tutorList;
  @override
  State<Tutors> createState() => _TutorsState();
}

class _TutorsState extends State<Tutors> {
  @override
  Widget build(BuildContext context) {
    final data = widget.tutorList;
    if (data == null) return CircularProgressIndicator();
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final tutor = data[index];
          return Padding(
            padding: const EdgeInsets.all(.1),
            child: Single_prod(tutorId: tutor.docId, tutor: tutor),
          );
        });
  }
}

class Single_prod extends StatelessWidget {
  final Tutor tutor;
  final String tutorId;

  Single_prod({required this.tutorId, required this.tutor});
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey,
        child: Card(
          child: Material(
            child: InkWell(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  //here we are passing the values of the product to the product detail page
                  builder: (context) => ProductDetails(
                        tutor: tutor,
                        tutorId: tutorId,
                      ))),
              /*  child: Row(
                children: [
                  CircleAvatar(
                      radius: 40, backgroundImage: AssetImage(tutor.avatar)),
                  Text(
                    tutor.name,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ],
              ),*/

              child: ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(tutor.avatar),
                ),
                title: Text(
                  tutor.name,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                subtitle: Text(
                  tutor.bio,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                trailing: Text(
                  "\$${tutor.price}/hr",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
            ),
          ),
        ));
  }
}
