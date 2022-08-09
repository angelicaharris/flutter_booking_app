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
        primarySwatch: Colors.deepOrange,
      ),
      home: user != null ? HomePage() : SignInScreen(),
    );
  }
}


/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_booking_app/booking/state/state_management.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_booking_app/booking/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //firebase
  Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return PageTransition(
                settings: settings,
                child: HomePage(),
                type: PageTransitionType.fade);
            break;
          default:
            return null;
        }
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();
  @override
  Widget build(BuildContext context) {
// <----- barber booking --->
    return Scaffold(
      key: scaffoldState,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/my_bg.png'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                label: Text(
                  'LOGIN WITH PHONE',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)),
                onPressed: () => processLogin(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  processLogin(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) //user not login, start home page
    {
      FirebaseAuthUi.instance()
          .launchAuth([AuthProvider.phone()]).then((firebaseUser) {
        context.read(userLogged).state = FirebaseAuth.instance.currentUser;
        ScaffoldMessenger.of(scaffoldState.currentContext).showSnackBar(SnackBar(
            content: Text(
                'Login Success ${FirebaseAuth.instance.currentUser!.phoneNumber}')));
      }).catchError((e) {
        if (e is PlatformException) if (e.code ==
            FirebaseAuthUi.kUserCancelledError)
          ScaffoldMessenger.of(scaffoldState.currentContext)
              .showSnackBar(SnackBar(content: Text('${e.message}')));
        else
          ScaffoldMessenger.of(scaffoldState.currentContext)
              .showSnackBar(SnackBar(content: Text('error')));
      });
    } else {
      //user already login, start home page

    }
  }
}
*/