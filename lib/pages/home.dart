import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_scale_ruler/flutter_scale_ruler.dart';

//my own imports
import 'package:flutter_booking_app/pages/horizontalListView.dart';
import 'package:flutter_booking_app/pages/profile.dart';
import 'package:flutter_booking_app/pages/signin_screen.dart';
import 'package:flutter_booking_app/pages/tutors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name;
  String? email;

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
          print("Successfully completed");
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
          print("Successfully completed");
          // parse data to our model
          usersSnap = res;
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

//<----- toggle button declaration for  ---->
  List<bool> _isSelected = [true, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: Text('TutorMatch'),
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
                Icons.chat,
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
                child: new CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
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
              onTap: () {},
              child: ListTile(
                title: Text('My Lessons'),
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
      body: new Column(
        //<------- Filtering Icons toggles for users ----->
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: "Type Subject",
            ),
          ),
          SizedBox(height: 10),
          new Row(
            children: <Widget>[
              ToggleButtons(
                isSelected: _isSelected,
                selectedColor: Colors.white,
                color: Colors.black,
                fillColor: Colors.lightBlue.shade900,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text("Online", style: TextStyle(fontSize: 18)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text("In-person", style: TextStyle(fontSize: 18)),
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
              SizedBox(width: 10),
              ElevatedButton(onPressed: () {}, child: Text('Search')),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text("X # Tutors", style: TextStyle(fontSize: 18)),
          ),

//<-----Horizontal list view begins here ----->
          HorizontalList(),
          Flexible(
              child: Tutors(
            usersSnap: usersSnap,
          )),
        ],
      ),
    );
  }
}
