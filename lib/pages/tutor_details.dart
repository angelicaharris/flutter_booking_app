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
        centerTitle: true,
        elevation: 0.1,
        backgroundColor: Colors.grey,
        title: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new HomePage()));
          },
          child: Text(widget.tutor.name),
        ),
      ),
      body: new ListView(
        children: <Widget>[
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
        ],
      ),
    );
  }
}
