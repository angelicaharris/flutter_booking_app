
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createCategory(String name){
  var id = Uuid();
  String categoryId = id.v1();

    _firestore.collection('categories').doc(categoryId).set({'category': name});
  }
}







/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
class CategoryService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'category';

  void createCategory(String name){
  var id = Uuid();
  String categoryId = id.v1();

    _firestore.collection(ref).doc(categoryId).set({'category': name});
    
    Future<List<DocumentSnapshot>> getCategories(){
    return _firestore.collection(ref).getDocuments().then((snaps){
      return snaps.documents;
  });
}
  }
}*/