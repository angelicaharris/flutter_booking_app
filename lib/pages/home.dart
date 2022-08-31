import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_booking_app/pages/tutor_details_viewmodel.dart';
import 'package:flutter_scale_ruler/flutter_scale_ruler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

//my own imports
import 'package:flutter_booking_app/pages/profile.dart';
import 'package:flutter_booking_app/pages/signin_screen.dart';
import 'package:flutter_booking_app/services/tutors.dart';
import 'package:flutter_booking_app/pages/upcoming_lessons.dart';

import 'dart:io' as io;

import '../models/tutor.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name;
  String? email;
  String? interests;

  List<Tutor>? tutors;
  List<Tutor>? originalTutors;

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
          usersSnap = res; //
          tutors = res.docs.map((doc) => Tutor.fromDocument(doc)).toList();

          originalTutors = tutors;
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

  final viewModel = TutorDetailsViewModel();

  void search(String value) {}

  List<bool> _isSelected = [true, false];
  //getting an image from user var and methods
  io.File? _pickedImage;

  void _pickImageGallery({ImageSource source = ImageSource.gallery}) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    final pickedImageFile = io.File(pickedImage!.path);
    if (pickedImage != null) {
      final storageInstance = FirebaseStorage.instance.ref();
      final storage = storageInstance.child("images");
      final database = FirebaseDatabase.instance.ref("users");
      try {
        final uploadTask = await storage.putFile(pickedImageFile);
        final currentUser = FirebaseAuth.instance.currentUser;
        final currentUid = currentUser?.uid;
        final uploadedImageUrl = await storage.getDownloadURL();
        if (currentUid != null) {
          database
              .child(currentUid)
              .set({"userImage": uploadedImageUrl}).then((value) {
            print("Image uploaded!");
          });
        }

        print("download url: $uploadedImageUrl");
      } catch (error, trace) {
        print("OnError: $trace");
      }
    }
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  void _remove() {
    setState(() {
      _pickedImage = null;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    int? i;
    int x = i ?? 0; //
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromARGB(255, 129, 143, 155),
        title: Card(
          child: TextField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            /*
                  ? - nullable
                  ! - non-nullable

                  int? i; 
                  int x =i;
                */
            onChanged: (val) {
              if (tutors != null) {
                List<Tutor>? tutorList;
                setState(() {
                  tutorList = originalTutors?.where((element) {
                    print("search: $element");

                    if (val.isEmpty) {
                      tutorList = originalTutors;
                      return true;
                    }

                    final tutor = element as Tutor;
                    final interests = tutor.interests
                        .keys; // {"Maths": true, "Discrete Maths": false}, m
                    final interestMap = tutor
                        .interests; // The interest booleans //interstMap['Maths'] == false -> False

                    return interests.where((element) {
                      //Iterates through the interests element and check which item starts  with @val
                      // @param val - The textfield text
                      if (interestMap[element] == true) {
                        return element
                            .toLowerCase() // "maths", discrete maths
                            .startsWith(val
                                .toLowerCase()); // wa --> maths; discrete maths

                      } else {
                        return false;
                      }
                    }).isNotEmpty;
                  }).toList();

                  tutors = tutorList;

                  print("searchS: ${tutors?.length}");
                });
              }
            },
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
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              //displays user's name and email
              accountName: Text(name ?? ''),
              accountEmail: Text(email ?? ''),
              currentAccountPicture: Stack(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    child: CircleAvatar(
                      radius: 71,
                      backgroundColor: Colors.green,
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.blue,
                        backgroundImage: _pickedImage == null
                            ? Image.asset("assets/images/c1.jpg").image
                            : FileImage(_pickedImage!),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Choose option',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.cyan),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _pickImageGallery(
                                            source: ImageSource.camera);
                                      },
                                      splashColor: Colors.purpleAccent,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.camera,
                                              color: Colors.purpleAccent,
                                            ),
                                          ),
                                          Text(
                                            'Camera',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.pink),
                                          )
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: _pickImageGallery,
                                      splashColor: Colors.purpleAccent,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.image,
                                              color: Colors.purpleAccent,
                                            ),
                                          ),
                                          Text(
                                            'Gallery',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.blue),
                                          )
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: _remove,
                                      splashColor: Colors.purpleAccent,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.remove_circle,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Text(
                                            'Remove',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  )
                  /* new CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.edit),
                      
                    )*/
                ],
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
            tutorList: tutors,
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
