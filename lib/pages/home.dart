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
import 'dart:io' as io;
import '../models/tutor.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
//my own imports
import 'package:flutter_booking_app/pages/profile.dart';
import 'package:flutter_booking_app/pages/signin_screen.dart';
import 'package:flutter_booking_app/services/tutors.dart';
import 'package:flutter_booking_app/pages/upcoming_lessons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? name;
  String? email;
  String? interests;
  String? image_url;
  // int? price;

  List<Tutor>? tutors;
  List<Tutor>? originalTutors;
  double _currentSliderValue = 20;
  final List<String> subjects = [
    'ACT English',
    'ACT Math',
    'ACT Reading',
    'ACT Science',
    'ACT Writing',
    'SAT English',
    'SAT Reading',
    'SAT Math',
  ];

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
        // final data = doc.data();
        if (doc.data() != null) {
          final data = doc.data() as Map<String, dynamic>;
          print("ProfileData => $data");
          // ...
          name = data["name"];
          email = data["email"];
          String type = data["userType"];
          //  price = data["price"];
          getUsers(type);
          image_url = data["imageUrl"];
          setState(() {});
        }
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
    int x = i ?? 0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromARGB(255, 129, 143, 155),
        title: Card(
          child: DropdownButtonFormField(
            items: subjects.map((subject) {
              return DropdownMenuItem(
                value: subject,
                child: Text(subject),
              );
            }).toList(),
            onChanged: (String? val) {},
            /*  onChanged: (String? val) {
              print("val: $val");
              if (tutors != null) {
                List<Tutor>? tutorList;
                setState(() {
                  tutorList = originalTutors?.where((element) {
                    if (val == '') {
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
                        return element.compareTo(val!) ==
                            0; // "maths", discrete maths
                        // wa --> maths; discrete maths

                      } else {
                        return false;
                      }
                    }).isNotEmpty;
                  }).toList();
                  tutors = tutorList;
                  print("searchS: ${tutors?.length}");
                });
              }
            },*/
          ),
        ),
        actions: <Widget>[
          Container(
            width: 50,
            height: 30,
            child: Stack(
              children: [
                Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 30,
                ),
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(top: 5),
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffc32c37),
                        border: Border.all(color: Colors.white, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Center(
                        child: Text(
                          '3',
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: image_url == null
                          ? const Icon(
                              Icons.person,
                              size: 60,
                            )
                          : Image.network(
                              image_url!,
                              fit: BoxFit.cover,
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
                ],
              ),
              decoration: new BoxDecoration(color: Colors.grey),
            ),
            //body

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Home Page'),
                leading: Icon(Icons.home, color: Colors.amberAccent),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new Profile()));
              },
              child: ListTile(
                title: Text('Profile'),
                leading: Icon(Icons.person, color: Colors.amberAccent),
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
                leading: Icon(Icons.shopping_basket, color: Colors.amberAccent),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Past Lessons'),
                leading: Icon(Icons.favorite, color: Colors.amberAccent),
              ),
            ),

            const Divider(),

            InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed Out");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                });
              },
              child: ListTile(
                title: Text('Logout'),
                leading: Icon(
                  Icons.logout,
                ),
              ),
            ),
          ],
        ),
      ),
      // ignore: unnecessary_new
      body: new Column(
        children: <Widget>[
          MultiSelectDialogField(
            items: subjects.map((e) => MultiSelectItem(e, e)).toList(),
            listType: MultiSelectListType.CHIP,
            onConfirm: (values) {
              if (tutors != null) {
                List<Tutor>? tutorList;
                setState(() {
                  tutorList = originalTutors?.where((element) {
                    if (values.isEmpty) {
                      tutorList = originalTutors;
                      return true;
                    }
                    final tutor = element as Tutor;
                    final interests = tutor.interests
                        .keys; // {"Maths": true, "Discrete Maths": false}, m

                    final interestMap = tutor
                        .interests; // The interest booleans //interstMap['Maths'] == false -> False

                    for (var val in values) {
                      if (interestMap[val] == false) {
                        return false;
                      }
                    }
                    return true;
                  }).toList();
                  tutors = tutorList;
                  print("searchS: ${tutors?.length}");
                });
              }
            },
          ),
//<--------PriceSliderClass---------->
          Text(
            'Price',
            style: TextStyle(fontSize: 18),
          ),
          Slider(
            value: _currentSliderValue,
            max: 100,
            divisions: 5,
            label: _currentSliderValue.round().toString(),
            onChanged: (value) {
              if (tutors != null) {
                List<Tutor>? tutorList;
                setState(() {
                  _currentSliderValue = value;
                });
                setState(() {
                  tutorList = originalTutors?.where((element) {
                    return double.parse(element.price) <= _currentSliderValue;
                  }).toList();
                  tutors = tutorList;
                });
              }
            },
          ),
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
