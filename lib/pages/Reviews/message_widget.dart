import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/pages/Reviews/messagesWidget.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_booking_app/pages/Reviews/model/model_comment.dart';
import 'package:flutter_booking_app/pages/Reviews/services/services_comment.dart';
import 'package:flutter_booking_app/pages/tutor_details.dart';
import 'package:flutter_booking_app/pages/Reviews/newMessagesWidget.dart';

class MessageWidget extends StatelessWidget {
  final TutorReviews message;

  const MessageWidget({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(12);
    final borderRadius = BorderRadius.all(radius);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 140),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius:
                borderRadius.subtract(BorderRadius.only(bottomLeft: radius)),
          ),
          child: buildMessage(),
        ),
      ],
    );
  }

  Widget buildMessage() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.message ?? "",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.start,
          ),
        ],
      );
}
