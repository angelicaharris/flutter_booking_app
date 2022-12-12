import 'package:flutter/material.dart';

import '../utils.dart';

class MessageField {
  static final String createdAt = 'createdAt';
}

class Message {
  final String idUser;
  final String imageUrl;
  final String username;
  final String message;
  final DateTime createdAt;

  const Message({
    required this.idUser,
    required this.imageUrl,
    required this.username,
    required this.message,
    required this.createdAt,
  });

  static Message fromJson(Map<String, dynamic> json, String id) => Message(
        idUser: json['idUser'],
        imageUrl: json['imageUrl'],
        username: json['username'],
        message: json['message'],
        createdAt: Utils.toDateTime(json['createdAt']) as DateTime,
      );

  Map<String, dynamic> toJson() => {
        'idUser': idUser,
        'imageUrl': imageUrl,
        'username': username,
        'message': message,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
      };
}
