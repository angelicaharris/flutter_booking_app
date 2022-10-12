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

class ChatPage extends StatefulWidget {
  final String tutorId;

  const ChatPage({required this.tutorId, Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blue,
      body:

          //  ProfileHeaderWidget(name: widget.user.name),
          //
          //child:
          /*    Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: MessagesWidget(tutorId: widget.tutorId),
              ),*/
          // ),
          // MessagesWidget(tutorId: widget.tutorId);
          NewMessageWidget(
        tutorId: widget.tutorId,
      ));
}
