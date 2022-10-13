import 'package:flutter/material.dart';
import 'package:flutter_booking_app/main.dart';
import 'package:flutter_booking_app/models/student.dart';
import 'package:flutter_booking_app/models/tutor.dart';
import 'package:flutter_booking_app/pages/booking_dialog.dart';

import 'package:flutter_booking_app/pages/home.dart';
import 'package:flutter_booking_app/pages/reviews/reviewsDialog.dart';
import 'package:flutter_booking_app/pages/tutor_details_viewmodel.dart';

class ProductDetails extends StatefulWidget {
  final Tutor tutor;
  final List<ReviewsDialog>? reviewList;
  final tutoDetailViewModel = TutorDetailsViewModel();
  final String tutorId;

  ProductDetails({required this.tutorId, required this.tutor, this.reviewList});

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
    final data = widget.reviewList;
    final color = Theme.of(context).colorScheme.primary;
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
      body: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: new ListView(
          children: <Widget>[
            Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: Ink.image(
                        image: NetworkImage(widget.tutor.avatar),
                        fit: BoxFit.cover,
                        width: 128,
                        height: 128,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      onPrimary: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text('Schedule Lesson'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Request a Lesson"),
                              content: BookingDialog(tutorId: widget.tutorId),
                            );
                          });
                    })),
            const SizedBox(height: 24),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.tutor.bio,
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                  Text(
                    "Price: \$" + widget.tutor.price,
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Reviews',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      onPrimary: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text('Post a Review'),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Request a Lesson"),
                              content: ReviewsDialog(tutorId: widget.tutorId),
                            );
                          });
                    })),
            ListView.builder(
                itemCount: data!.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final student = data[index];
                  return Padding(
                    padding: const EdgeInsets.all(.1),
                    child:
                        ReviewsListBuilder(studentId: student, student: tutor),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class ReviewsListBuilder extends StatelessWidget {
  final Student student;
  final String studentId;

  ReviewsListBuilder({required this.studentId, required this.student});
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
