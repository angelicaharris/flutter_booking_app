import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class Utils {
  static StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<T>>
      transformer<T>(
              T Function(Map<String, dynamic> json, String id) fromJson) =>
          StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
              List<T>>.fromHandlers(
            handleData: (QuerySnapshot<Map<String, dynamic>> data,
                EventSink<List<T>> sink) {
              final users = data.docs.map((doc) {
                print("TRANSFORMED DATA");
                print(doc.data());
                print(doc.id);
                return fromJson(doc.data(), doc.id);
              }).toList();
              // final users = snaps.map((json) => fromJson(json, )).toList();

              sink.add(users);
            },
          );

  static DateTime? toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }
}
