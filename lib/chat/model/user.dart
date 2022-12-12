import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../utils.dart';

class UserField {
  static final String lastMessageTime = 'lastMessageTime';
}

class User {
  final String idUser;
  final String name;
  final String imageUrl;
  final DateTime lastMessageTime;

  const User({
    this.idUser = ' ',
    required this.name,
    required this.imageUrl,
    required this.lastMessageTime,
  });

  User copyWith({
    String? idUser,
    String? name,
    String? imageUrl,
    String? lastMessageTime,
  }) =>
      User(
        idUser: idUser ?? this.idUser,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        lastMessageTime: lastMessageTime as DateTime,
      );

  static User fromJson(Map<String, dynamic> json, String id) => User(
        idUser: id,
        name: json['name'],
        imageUrl: json['imageUrl'],
        lastMessageTime: Utils.toDateTime(json['lastMessageTime']) as DateTime,
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'name': name,
        'imageUrl': imageUrl,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime),
      };
}
