import 'package:flutter_booking_app/chat/api/firebase_api.dart';
import 'package:flutter_booking_app/chat/model/message.dart';
import 'package:flutter_booking_app/chat/widget/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_booking_app/chat/widget/new_message_widget.dart';

import '../data.dart';

class MessagesWidget extends StatelessWidget {
  final String idUser;

  const MessagesWidget({
    super.key,
    required this.idUser,
  });

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Message>>(
        stream: FirebaseApi.getMessages(idUser),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                final messages = snapshot.data;

                return messages!.isEmpty
                    ? buildText('Say Hi..')
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: messages!.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          return MessageWidget(
                            message: message,
                            isMe: message.idUser == myId,
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
