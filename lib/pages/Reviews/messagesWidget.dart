import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/pages/Reviews/message_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_booking_app/pages/Reviews/model/model_comment.dart';
import 'package:flutter_booking_app/pages/Reviews/services/services_comment.dart';
import 'package:flutter_booking_app/pages/tutor_details.dart';
import 'package:flutter_booking_app/pages/Reviews/newMessagesWidget.dart';

class MessagesWidget extends StatelessWidget {
  final String tutorId;
  late TutorReviewServices tutorReviewServices = TutorReviewServices();
  MessagesWidget({required this.tutorId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<TutorReviews>>(
        stream: tutorReviewServices.getMessages(tutorId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                final messages = snapshot.data;

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  reverse: true,
                  itemCount: messages?.length,
                  itemBuilder: (context, index) {
                    final message = messages?[index];

                    return MessageWidget(
                      message: message!,
                    );
                  },
                );
              }
          }
        },
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      );
}
