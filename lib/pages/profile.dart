import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_booking_app/pages/home.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Profile> {
  String? name;
  String? email;
  String? oldPassword;
  String? newPassword;

  getCurrentUser() {
    // Fireabse Auth - get Authenticated User - UserID
    String? userID;
    if (FirebaseAuth.instance.currentUser != null) {
      userID = FirebaseAuth.instance.currentUser?.uid;
    }

    // Firestore - Get User Info using UserID
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("users").doc(userID);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        // ...
        name = data["name"];
        email = data["email"];
        print('name - $name');
        setState(() {});
        _nameCotroller.text = name ?? '';
        _emailController.text = email ?? '';
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  final _nameCotroller = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void _save() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user found');
      return;
    }
    String userID = user.uid;
    // Update one field, creating the document if it does not already exist.
    final data = {"name": _nameCotroller.text, "email": _emailController.text};

    await user.updateEmail(_emailController.text);

    final pwd = _passwordController.text;
    if (pwd.isNotEmpty) {
      await user.updatePassword(pwd);
    }

    final db = FirebaseFirestore.instance;
    db.collection("users").doc(userID).set(data, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('Profile'),
        actions: <Widget>[],
      ),
      body: Column(
        children: [
          TextFormField(
            controller: _nameCotroller,
            decoration:
                InputDecoration(labelText: 'Your Name', hintText: 'e.g. John'),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
                labelText: 'Your Email', hintText: 'e.g. John@gmail.com'),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: "New Password",
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                _save();
              },
              child: Text('Save'))
        ],
      ),
    );
  }
}
