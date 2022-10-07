import 'package:meta/meta.dart';

import 'package:flutter_booking_app/utils/transform_utils.dart';

class UserField {
  // static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String idUser;
  final String name;
  final String urlAvatar;
  //final DateTime lastMessageTime;

  const User({
    required this.idUser,
    required this.name,
    required this.urlAvatar,
    // required this.lastMessageTime,
  });

  User copyWith({
    required String idUser,
    required String name,
    required String urlAvatar,
    //required String lastMessageTime,
  }) =>
      User(
        idUser: idUser,
        name: name,
        urlAvatar: urlAvatar,
        // lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      );

  static User fromJson(Map<String, dynamic> json) => User(
        idUser: json['userType'],
        name: json['name'],
        urlAvatar: json['imageUrl'],
        // lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'name': name,
        'urlAvatar': urlAvatar,
        //  'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
      };
}
