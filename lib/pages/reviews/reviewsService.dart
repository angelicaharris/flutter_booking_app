import 'package:flutter/material.dart';

//my own imports
import 'package:flutter_booking_app/models/student.dart';
import 'package:intl/intl.dart';

class ReviewsService extends StatefulWidget {
  const ReviewsService({Key? key, this.reviewsList}) : super(key: key);
  final List<Student>? reviewsList;
  @override
  State<ReviewsService> createState() => _ServiceReviewsServiceState();
}

class _ServiceReviewsServiceState extends State<ReviewsService> {
  @override
  Widget build(BuildContext context) {
    final data = widget.reviewsList ?? [];
    //if (data == null) return CircularProgressIndicator();
    return Container(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            final lesson = data[index];
            // final lesson = ModelUpcomingLesson.fromDocument(doc);
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Single_prod(
                tutor: lesson,
                tutorId: lesson.docId,
              ),
            );
          }),
    );
  }
}

class Single_prod extends StatelessWidget {
  final Student tutor;
  final String tutorId;

  Single_prod({required this.tutorId, required this.tutor});
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
                  backgroundImage: NetworkImage(tutor.avatar),
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
