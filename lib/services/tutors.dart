import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//my own imports
import 'package:flutter_booking_app/pages/tutor_details.dart';
import 'package:flutter_booking_app/models/tutor.dart';

class Tutors extends StatefulWidget {
  const Tutors({Key? key, this.usersSnap}) : super(key: key);
  final QuerySnapshot? usersSnap;
  @override
  State<Tutors> createState() => _TutorsState();
}

class _TutorsState extends State<Tutors> {
  var product_list = [
    {
      "name": "Paulina",
      "picture": "assets/images/c3.png",
      "old_price": 120,
      "price": 40,
    },
    {
      "name": "Kim",
      "picture": "assets/images/c8.png",
      "old_price": 100,
      "price": 50,
    },
    {
      "name": "Jamar",
      "picture": "assets/images/c3.png",
      "old_price": 100,
      "price": 45,
    },
    {
      "name": "Ken",
      "picture": "assets/images/c3.png",
      "old_price": 100,
      "price": 50,
    },
    {
      "name": "Aliayah",
      "picture": "assets/images/c3.png",
      "old_price": 100,
      "price": 50,
    },
    {
      "name": "Linda",
      "picture": "assets/images/c3.png",
      "old_price": 100,
      "price": 60,
    }
  ];
  @override
  Widget build(BuildContext context) {
    final data = widget.usersSnap;
    if (data == null) return CircularProgressIndicator();
    return GridView.builder(
        itemCount: data.docs.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          final doc = data.docs[index];
          final tutor = Tutor.fromDocument(doc);
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Single_prod(tutorId: doc.id, tutor: tutor),
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
    return Card(
      child: Hero(
          tag: new Text("hero 1"),
          child: Material(
            child: InkWell(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  //here we are passing the values of the product to the product detail page
                  builder: (context) => ProductDetails(
                        tutor: tutor,
                        tutorId: tutorId,
                      ))),
              child: GridTile(
                  footer: Container(
                    color: Colors.white,
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            tutor.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                        ),
                        new Text(
                          "\$${tutor.price}",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  child: Image.asset(
                    tutor.avatar,
                    fit: BoxFit.cover,
                  )),
            ),
          )),
    );
  }
}
