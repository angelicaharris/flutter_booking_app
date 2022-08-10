import 'package:flutter/material.dart';
import 'package:flutter_booking_app/main.dart';
import 'package:flutter_booking_app/models/tutor.dart';
import 'package:flutter_booking_app/pages/booking_dialog.dart';
import 'package:flutter_booking_app/pages/home.dart';
import 'package:flutter_booking_app/pages/tutor_details_viewmodel.dart';

class ProductDetails extends StatefulWidget {
  final Tutor tutor;
  final tutoDetailViewModel = TutorDetailsViewModel();
  final String tutorId;

  ProductDetails({required this.tutorId, required this.tutor});

  @override
  State<ProductDetails> createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  @override
  void initState() {
    final bookNow = widget.tutoDetailViewModel.bookNow;
    bookNow.listen((event) {
      if (event.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Booking tutor...")));
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(event)));
    }, onError: (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new HomePage()));
            },
            child: Text('Book a Lesson')),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: null),
        ],
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 300.0,
            child: GridTile(
              child: Container(
                color: Colors.white70,
                child: Image.asset(widget.tutor.avatar),
              ),
              footer: new Container(
                color: Colors.white70,
                child: ListTile(
                  leading: new Text(
                    widget.tutor.name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  title: new Row(
                    children: <Widget>[
                      Expanded(
                          child: new Text(
                        "\$${widget.tutor.price}",
                        style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      )),
                      Expanded(
                          child: new Text(
                        "\$${widget.tutor.price}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //second button
          Row(
            children: <Widget>[
              Expanded(
                child: MaterialButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Request a Lesson"),
                              content: BookingDialog(tutorId: widget.tutorId),
                            );
                          });
                    },
                    color: Colors.red,
                    textColor: Colors.white,
                    elevation: 0.2,
                    child: new Text("Book")),
              ),
            ],
          ),
          Divider(),
          new ListTile(
            title: new Text("Details"),
            subtitle: new Text(widget.tutor.bio),
          ),

          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text("Similar tutors"),
          ),
          //similar product section
          Container(
            height: 340.0,
            child: Similar_Tutors(),
          )
        ],
      ),
    );
  }
}

class Similar_Tutors extends StatefulWidget {
  @override
  State<Similar_Tutors> createState() => _Similar_TutorsState();
}

class _Similar_TutorsState extends State<Similar_Tutors> {
  @override
  var product_list = [
    {
      "name": "Ken",
      "picture": "assets/images/c2.jpg",
      "old_price": 120,
      "price": 85,
    },
    {
      "name": "Kelly",
      "picture": "assets/images/c2.jpg",
      "old_price": 100,
      "price": 50,
    },
    {
      "name": "Amber",
      "picture": "assets/images/c3.jpg",
      "old_price": 100,
      "price": 50,
    },
    {
      "name": "Jamar",
      "picture": "assets/images/c3.jpg",
      "old_price": 100,
      "price": 50,
    },
    {
      "name": "Donald",
      "picture": "assets/images/c3.jpg",
      "old_price": 100,
      "price": 50,
    },
    {
      "name": "Simone",
      "picture": "assets/images/c3.jpg",
      "old_price": 100,
      "price": 50,
    }
  ];
  @override
  Widget build(BuildContext context) {
    final tutors = [];
    return GridView.builder(
        itemCount: tutors.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Similar_single_prod(
            tutor: tutors[index],
            tutorId: "",
          );
        });
  }
}

class Similar_single_prod extends StatelessWidget {
  final Tutor tutor;
  final String tutorId;

  Similar_single_prod({required this.tutor, required this.tutorId});
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