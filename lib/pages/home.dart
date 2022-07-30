import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_scale_ruler/flutter_scale_ruler.dart';

//my own imports
import 'package:flutter_booking_app/components/horizontalListView.dart';
import 'package:flutter_booking_app/components/products.dart';
import 'package:flutter_booking_app/pages/cart.dart';
import 'package:flutter_booking_app/pages/profile.dart';
import 'package:flutter_booking_app/pages/signin_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name;
  String? email;

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
        print('name - $name');
        print('userType - $type');
        getUsers(type);
        setState(() {});
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  QuerySnapshot? usersSnap;

  getUsers(String type) {
    //get either tutors or students

    //final db = FirebaseFirestore.instance;
    final db = FirebaseFirestore.instance;

    print("here2");
    print('userType1 - $type');
    if (type == 'Tutor') {
      db.collection("users").where('userType', isEqualTo: 'Student').get().then(
        (res) {
          print("Successfully completed");
          // parse data to our model
          usersSnap = res;
          // update ui
          print("here3");
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
          print("here4");
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

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/images/c1.jpg'),
          AssetImage('assets/images/c1.jpg'),
          AssetImage('assets/images/c1.jpg'),
        ],
        autoplay: false,
        //  animationCurve: Curves.fastOutSlowIn,
        //  animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
        dotBgColor: Colors.transparent,
      ),
    );
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
                Icons.search,
                color: Colors.white,
              ),
              onPressed: null),
          new IconButton(
              icon: Icon(
                Icons.chat,
                color: Colors.white,
              ),
              onPressed: null),
          new IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new Cart()));
              }),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
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
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new Cart()));
              },
              child: ListTile(
                title: Text('Purchases'),
                leading: Icon(
                  Icons.shopping_cart,
                  color: Colors.red,
                ),
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
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: "Type Subject",
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text('Search')),
          Text("Filters"),
          new Padding(
            padding: const EdgeInsets.all(4.0),
            child:
                Container(alignment: Alignment.centerLeft, child: new Text('')),
          ),

          //Horizontal list view begins here
          HorizontalList(),
          /*  new Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
                alignment: Alignment.centerLeft,
                child: new Text('Experienced Tutors!')),
          ),*/
          //grid view
          Flexible(
              child: Products(
            usersSnap: usersSnap,
          )),
        ],
      ),
    );
  }
}
