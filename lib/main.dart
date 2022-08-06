import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

//my own imports
import 'package:flutter_booking_app/pages/home.dart';
import 'package:flutter_booking_app/pages/signin_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // get current user
  User? user = FirebaseAuth.instance.currentUser;
  await user?.reload();
  user = FirebaseAuth.instance.currentUser;
  print('main - user - ${user?.uid}');
  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.user}) : super(key: key);
  final User? user;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: user != null ? HomePage() : SignInScreen(),
    );
  }
}
