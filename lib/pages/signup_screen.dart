import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

//my own imports
import 'package:flutter_booking_app/widgets/reusable_widget.dart';
import 'package:flutter_booking_app/utils/color_utils.dart';
import 'package:flutter_booking_app/widgets/my_radio_button.dart';
import 'package:flutter_booking_app/pages/user_survey/student_survey_bio.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  late String userType;
  String? image_url;
  //Radio Button Variable
  UserTypeEnum? _UserTypeEnum;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _createUser(
      String userId, String name, String email, String userType, String url) {
    final db = FirebaseFirestore.instance;
    final user = <String, dynamic>{
      "name": name,
      "email": email,
      "userType": userType,
      "imageUrl": url,
    };

    db
        .collection("users")
        .doc(userId)
        .set(user)
        .onError((e, _) => print("Error writing document: $e"));
  }

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      child: CircleAvatar(
                        radius: 71,
                        backgroundColor: Colors.grey,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.grey,
                          backgroundImage: _pickedImage == null
                              ? null
                              : FileImage(_pickedImage!),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 120,
                        left: 110,
                        child: RawMaterialButton(
                          elevation: 10,
                          fillColor: Colors.grey,
                          child: Icon(Icons.add_a_photo),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                          onPressed: () {
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.camera,
                                                    color: Colors.purpleAccent,
                                                  ),
                                                ),
                                                Text(
                                                  'Camera',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.image,
                                                    color: Colors.purpleAccent,
                                                  ),
                                                ),
                                                Text(
                                                  'Gallery',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.remove_circle,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                Text(
                                                  'Remove',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter First Name", Icons.person_outline,
                    false, _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    MyRadioButton(
                      title: UserTypeEnum.Student.name,
                      value: UserTypeEnum.Student,
                      selectedUserType: _UserTypeEnum,
                      onChanged: (val) {
                        setState(() {
                          _UserTypeEnum = val;
                          userType = UserTypeEnum.Student.name;
                        });
                      },
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    MyRadioButton(
                        title: UserTypeEnum.Tutor.name,
                        value: UserTypeEnum.Tutor,
                        selectedUserType: _UserTypeEnum,
                        onChanged: (val) {
                          setState(() {
                            _UserTypeEnum = val;
                            userType = UserTypeEnum.Tutor.name;
                          });
                        }),
                  ],
                ),
                //<-----users inputs get checked in firestore and saved to firebase -->
                firebaseUIButton(context, "Sign Up", () async {
                  // if (image_url == null) {
                  //   return;
                  // }

                  print("_pickedImage => $_pickedImage");

                  //Step 1

                  _auth
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((userCredential) async {
                    print("Created New Account");
                    final userId = userCredential.user!.uid;
                    final ref = FirebaseStorage.instance //step 2
                        .ref()
                        .child('usersImages')
                        .child(userId)
                        .child(_userNameTextController.text + '.jpg');
                    await ref.putFile(_pickedImage!);
                    image_url = await ref.getDownloadURL();
                    print("$image_url");
                    //step 3
                    _createUser(userId, _userNameTextController.text,
                        _emailTextController.text, userType, image_url ?? "");

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TutorBookingProfile(userId: userId)));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                }),
              ],
            ),
          ))),
    );
  }
}
