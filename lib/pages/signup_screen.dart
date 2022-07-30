import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

//my own imports
import 'package:flutter_booking_app/widgets/reusable_widget.dart';
import 'package:flutter_booking_app/utils/color_utils.dart';
import 'package:flutter_booking_app/widgets/my_radio_button.dart';
import 'package:flutter_booking_app/pages/student_survey.dart';

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
  //Radio Button Variable
  UserTypeEnum? _UserTypeEnum;

  void _createUser(String userId, String name, String email, String userType) {
    final db = FirebaseFirestore.instance;
    final user = <String, dynamic>{
      "name": name,
      "email": email,
      "userType": userType,
    };

    db
        .collection("users")
        .doc(userId)
        .set(user)
        .onError((e, _) => print("Error writing document: $e"));
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
                firebaseUIButton(context, "Sign Up", () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((userCredential) {
                    print("Created New Account");
                    final userId = userCredential.user!.uid;
                    _createUser(userId, _userNameTextController.text,
                        _emailTextController.text, userType);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StudentSurvey(userId: userId)));
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                })
              ],
            ),
          ))),
    );
  }
}
