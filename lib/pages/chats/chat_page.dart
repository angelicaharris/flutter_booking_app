import 'package:flutter/material.dart';
import 'package:flutter_booking_app/pages/chats/model/user.dart';
import 'package:flutter_booking_app/pages/chats/widgets/messages_widget.dart';
import 'package:flutter_booking_app/pages/chats/widgets/new_message_widget.dart';
import 'package:flutter_booking_app/pages/chats/widgets/profile_header_widget.dart';

class ChatPage extends StatefulWidget {
  final User user;

  const ChatPage({
    required this.user,
  }) : super();

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
