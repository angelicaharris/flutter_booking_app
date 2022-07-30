import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//my own imports
import 'package:flutter_booking_app/pages/tutor_details.dart';

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
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Single_prod(
              prod_name: doc['name'],
              prod_picture: 'assets/images/c3.png',
              prod_old_price: '50',
              prod_price: '50',
            ),
          );
        });
  }
}

class Single_prod extends StatelessWidget {
  final prod_name;
  final prod_picture;
  final prod_old_price;
  final prod_price;

  Single_prod({
    this.prod_name,
    this.prod_picture,
    this.prod_old_price,
    this.prod_price,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
          tag: new Text("hero 1"),
          child: Material(
            child: InkWell(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  //here we are passing the values of the product to the product detail page
                  builder: (context) => new ProductDetails(
                        product_detail_name: prod_name,
                        product_detail_new_price: prod_price,
                        product_detail_old_price: prod_old_price,
                        product_detail_picture: prod_picture,
                      ))),
              child: GridTile(
                  footer: Container(
                    color: Colors.white,
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            prod_name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0),
                          ),
                        ),
                        new Text(
                          "\$${prod_price}",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  child: Image.asset(
                    prod_picture,
                    fit: BoxFit.cover,
                  )),
            ),
          )),
    );
  }
}
