import 'package:flutter_booking_app/chat/model/user.dart';
import 'package:flutter_booking_app/chat/widget/messages_widget.dart';
import 'package:flutter_booking_app/chat/widget/new_message_widget.dart';
import 'package:flutter_booking_app/chat/widget/profile_header_widget.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final User user;

  const ChatPage({
    super.key,
    required this.user,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Column(
            children: [
              ProfileHeaderWidget(name: widget.user.name),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: MessagesWidget(idUser: widget.user.idUser),
                ),
              ),
              NewMessageWidget(idUser: widget.user.idUser)
            ],
          ),
        ),
      );
}
