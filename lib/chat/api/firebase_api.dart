import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_booking_app/chat/data.dart';
import 'package:flutter_booking_app/chat/model/message.dart';
import 'package:flutter_booking_app/chat/model/user.dart';

import '../utils.dart';

class FirebaseApi {
  static Stream<List<User>> getUsers() => FirebaseFirestore.instance
      .collection('users')
      .orderBy(UserField.lastMessageTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(User.fromJson));

  static Future uploadMessage(String idUser, String message) async {
    final refMessages =
        FirebaseFirestore.instance.collection('chats/$idUser/messages');

    final db = FirebaseFirestore.instance;
    final docRef = db.collection("users").doc(idUser);
    final doc = await docRef.get();
    final userData = doc.data();
    print('userData');
    print(userData);
    print('idUSer');
    print(idUser);
    final newMessage = Message(
      idUser: idUser, //myId
      imageUrl: userData!['imageUrl'] ?? myimageUrl,
      username: userData!['name'] ?? myUsername,
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());

    final refUsers = FirebaseFirestore.instance.collection('users');
    await refUsers
        .doc(idUser)
        .update({UserField.lastMessageTime: DateTime.now()});
  }

  static Stream<List<Message>> getMessages(String idUser) =>
      FirebaseFirestore.instance
          .collection('chats/$idUser/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));

  static Future addRandomUsers(List<User> users) async {
    final refUsers = FirebaseFirestore.instance.collection('users');

    final allUsers = await refUsers.get();
    if (allUsers.size != 0) {
      return;
    } else {
      for (final user in users) {
        final userDoc = refUsers.doc();
        final newUser = user.copyWith(idUser: userDoc.id);

        await userDoc.set(newUser.toJson());
      }
    }
  }
}
