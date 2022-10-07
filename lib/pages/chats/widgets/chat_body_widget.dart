import 'package:flutter_booking_app/pages/chats/chat_page.dart';
import 'package:flutter_booking_app/pages/chats/model/user.dart';
import 'package:flutter_booking_app/pages/chats/chats_page.dart';
import 'package:flutter/material.dart';

class ChatBodyWidget extends StatelessWidget {
  final List<User> users;

  const ChatBodyWidget({
    required this.users,
  }) : super();

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: buildChats(),
        ),
      );

  Widget buildChats() => ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final user = users[index];

          return Container(
            height: 75,
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatPage(user: user),
                ));
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(user.urlAvatar),
              ),
              title: Text(user.name),
            ),
          );
        },
        itemCount: users.length,
      );
}
