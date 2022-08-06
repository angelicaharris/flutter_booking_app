import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/pages/home.dart';

class TutorBookingProfile extends StatefulWidget {
  const TutorBookingProfile({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<TutorBookingProfile> createState() => _TutorBookingProfileState();
}

class _TutorBookingProfileState extends State<TutorBookingProfile> {
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

  String? bio;
  String? price;

  Future<void> saveSubjects(String userId) async {
    final db = FirebaseFirestore.instance;
    final data = {
      "interests": map,
      "bio": bio,
      "price": price,
    };
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
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Tutor Profile'),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Bio',
                ),
                onChanged: (value) {
                  this.bio = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Price',
                ),
                onChanged: (value) {
                  this.price = value;
                },
              ),
              Text('Subject'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: options,
              ),
              // TextFormField(
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     hintText: 'Subject',
              //   ),
              // ),
              // TextFormField(
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     hintText: 'Availability',
              //   ),
              // )
            ],
          ),
        ),
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
