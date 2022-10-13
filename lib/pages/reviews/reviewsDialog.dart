import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_booking_app/pages/tutor_details_viewmodel.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewsDialog extends StatefulWidget {
  final String tutorId;
  const ReviewsDialog({super.key, required this.tutorId});

  @override
  State<ReviewsDialog> createState() => _ReviewsDialogState();
}

class _ReviewsDialogState extends State<ReviewsDialog> {
  TextEditingController reviewController = TextEditingController();
  String input = '';
  double rating = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmoothStarRating(
              allowHalfRating: false,
              onRatingChanged: (v) {
                rating = v;
                setState(() {});
              },
              starCount: 5,
              rating: rating,
              size: 40.0,
              filledIconData: Icons.blur_off,
              halfFilledIconData: Icons.blur_on,
              color: Colors.green,
              borderColor: Colors.green,
              spacing: 0.0),
          const Text(
            "Write Review",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
              margin: EdgeInsets.all(20),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: reviewController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Review',
                ),
                onChanged: (text) {
                  setState(() {
                    input = text;
                    //you can access nameController in its scope to get
                    // the value of text entered as shown below
                    //fullName = nameController.text;
                  });
                },
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text('Submit'),
              onPressed: () async {
                final CollectionReference reviewRef =
                    FirebaseFirestore.instance.collection("reviews");
                String? currentUId = FirebaseAuth.instance.currentUser?.uid;
                String? email = FirebaseAuth.instance.currentUser?.email;
                String? userImage = FirebaseAuth.instance.currentUser?.photoURL;
                Map<String, dynamic> json = {};
                json["rating"] = rating;
                json["response"] = input;

                json["uid"] = currentUId;
                json["email"] = email;
                json["userImage"] = userImage;
                final result = await reviewRef
                    .doc(widget.tutorId)
                    .collection("userReviews")
                    .add(json);
                Navigator.of(context).pop();
                // Push to Firebase
                // Reviews collection
                // Document Key is tutorid.
                // Add to reviews list if it exists for that key
              })
        ],
      ),
    ));
  }
}
