import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//my own imports
import 'package:flutter_booking_app/pages/home.dart';
import 'package:flutter_booking_app/pages/signin_screen.dart';
import 'package:flutter_booking_app/pages/tutor_booking_profile.dart';

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
  String? image_url;
  String? userID;

  getCurrentUser() {
    // Fireabse Auth - get Authenticated User - UserID

    if (FirebaseAuth.instance.currentUser != null) {
      userID = FirebaseAuth.instance.currentUser?.uid;
    }

    // Firestore - Get User Info using UserID
    final db = FirebaseFirestore.instance;
    final docRef = db.collection("users").doc(userID);
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        name = data["name"];
        email = data["email"];
        image_url = data["imageUrl"];
        setState(() {});
        _nameController.text = name ?? '';
        _emailController.text = email ?? '';
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

//<---- after user makes update, save that info to firestore --->
  void _save() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user found');
      return;
    }
    String userID = user.uid;
    // Update one field, creating the document if it does not already exist.
    final data = {"name": _nameController.text, "email": _emailController.text};

    await user.updateEmail(_emailController.text);

    final pwd = _passwordController.text;
    if (pwd.isNotEmpty) {
      await user.updatePassword(pwd);
    }

    final db = FirebaseFirestore.instance;
    db.collection("users").doc(userID).set(data, SetOptions(merge: true));
  }

  //show alert message
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Delete"),
      onPressed: () {
        _deleteUserAccount();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Account"),
      content: Text("Are you sure?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

//delete user
  void _deleteUserAccount() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('no user found');
      return;
    }
    String userID = user.uid;

    bool step1 = true;
    bool step2 = false;
    bool step3 = false;
    bool step4 = false;
    while (true) {
      if (step1) {
        //delete user info in the database
        var delete = await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .delete();
        step1 = false;
        step2 = true;
      }

      if (step2) {
        //delete user
        user.delete();
        step2 = false;
        step3 = true;
      }

      if (step3) {
        await FirebaseAuth.instance.signOut();
        step3 = false;
        step4 = true;
      }

      if (step4) {
        //go to sign up log in page
        //await Navigator.pushNamed(context, '/');
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInScreen()));
        step4 = false;
      }

      if (!step1 && !step2 && !step3 && !step4) {
        break;
      }
    }
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: 'Your Name', hintText: 'e.g. John'),
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
                child: Text('Save')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TutorBookingProfile(userId: userID!)));
                },
                child: Text('Edit Profile')),
            ElevatedButton(
                onPressed: () {
                  showAlertDialog(context);
                },
                child: Text('Delete Account')),
          ],
        ),
      ),
    );
  }
}
