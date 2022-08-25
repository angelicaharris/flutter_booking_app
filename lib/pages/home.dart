import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_scale_ruler/flutter_scale_ruler.dart';

//my own imports
import 'package:flutter_booking_app/pages/profile.dart';
import 'package:flutter_booking_app/pages/signin_screen.dart';
import 'package:flutter_booking_app/services/tutors.dart';
import 'package:flutter_booking_app/pages/upcoming_lessons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name;
  String? email;
  String? interests;

// <--- Firebase get users from collection --->
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
        String type = data["userType"];
        getUsers(type);
        setState(() {});
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  QuerySnapshot? usersSnap;

//<----- Firebase get type of user either tutor or student -->

  getUsers(String type) {
    final db = FirebaseFirestore.instance;
    if (type == 'Tutor') {
      db.collection("users").where('userType', isEqualTo: 'Student').get().then(
        (res) {
          print("Successfully completed => $res}");
          // parse data to our model
          usersSnap = res;
          // update ui
          setState(() {});
        },
        onError: (e) => print("Error completing: $e"),
      );
    } else {
      db.collection("users").where('userType', isEqualTo: 'Tutor').get().then(
        (res) {
          // parse data to our model
          usersSnap = res; // @
          // update ui
          setState(() {});
        },
        onError: (e) => print("Error completing: $e"),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentUser();
  }
/*
  Widget buildProfileImage(Function(String) onAction) async {
    ImagePicker imgPicker = ImagePicker();
    final XFile? imageSelected =
        await imgPicker.pickImage(source: ImageSource.gallery);
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref("profile_images");
   // storageRef.putData(io.File(imageSelected?.path), null);
  }
  */

/*
Stremamcontroller -> sink -> add()
stream -> listen 
*/
//<----- toggle button declaration for  ---->

  StreamController<String> _searchInterests = StreamController();
  Stream<String> get searchInterests => _searchInterests.stream;

  void search(String value) {}

  List<bool> _isSelected = [true, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blue,
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {},
          ),
        ),
        actions: <Widget>[
          new IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              });
            },
          ),
          new IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: null),
        ],
      ),
      //<--homepage side drop down menu -->
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              //displays user's name and email
              accountName: Text(name ?? ''),
              accountEmail: Text(email ?? ''),
              currentAccountPicture: GestureDetector(
                child: Stack(
                  children: [
                    new CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.edit),
                    )
                  ],
                ),
              ),
              decoration: new BoxDecoration(color: Colors.red),
            ),
            //body

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Home Page'),
                leading: Icon(Icons.home, color: Colors.red),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new Profile()));
              },
              child: ListTile(
                title: Text('Profile'),
                leading: Icon(Icons.person, color: Colors.red),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new UpCominngLessons()));
              },
              child: ListTile(
                title: Text('Upcoming Lessons'),
                leading: Icon(Icons.shopping_basket, color: Colors.red),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Past Lessons'),
                leading: Icon(Icons.favorite, color: Colors.red),
              ),
            ),

            const Divider(),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Settings'),
                leading: Icon(
                  Icons.settings,
                ),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('About'),
                leading: Icon(
                  Icons.help,
                ),
              ),
            ),
          ],
        ),
      ),

      /*    body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshots) {
          return (snapshots.connectionState == ConnectionState.waiting)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: snapshots.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshots.data!.docs[index].data()
                        as Map<String, dynamic>;

                    if (name!.isEmpty) {
                      return Flexible(
                          child: Tutors(
                        usersSnap: usersSnap,
                      ));
                    }
                    if (data['name']
                        .toString()
                        .toLowerCase()
                        .startsWith(name!.toLowerCase())) {
                      return Flexible(
                          child: Tutors(
                        usersSnap: usersSnap,
                      ));
                    }
                    return Container();
                  });
        },
      ),*/

      body: new Column(
        children: <Widget>[
//<-----Listing the users on homepage ----->
          Flexible(
              child: Tutors(
            usersSnap: usersSnap,
          )),
        ],
      ),
    );
  }
}

 /*  new Row(
            children: <Widget>[
              ToggleButtons(
                isSelected: _isSelected,
                selectedColor: Colors.white,
                color: Colors.black,
                fillColor: Colors.lightBlue.shade900,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text("Online",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text("In-person",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
                onPressed: (int newIndex) {
                  setState(() {
                    for (int index = 0; index < _isSelected.length; index++) {
                      if (index == newIndex) {
                        _isSelected[index] = true;
                      } else {
                        _isSelected[index] = false;
                      }
                    }
                  });
                },
              ),
            ],
          ),*/