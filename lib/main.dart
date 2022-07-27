import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_booking_app/pages/signin_screen.dart';
import 'firebase_options.dart';

 Future<void> main() async {
  
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(options: 
   DefaultFirebaseOptions.currentPlatform);
   runApp(const MyApp());
 }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(),
    );
  }
}






/*
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SignInScreen(),
  ));
}

*/


/*
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'verification.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Phone Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Phone Authentication'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneNumber,
                decoration: InputDecoration(
                  labelText: 'Phone nuber',
                  hintText: 'Enter your phone number',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.phone,
                  ),
                ),
              ),

              SizedBox(height: 10,),

              ElevatedButton(
                  onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)
                        => OTPScreen(phoneNumber.text),
                        ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Get OTP"),
                  ),
              ),
            ],
          ),
        ),
      )
         // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}




import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';


void main() {
  WidgetFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //home: VerifyNumber(),
       home: _MyHomePageState(),
    );
  }
}


class _MyHomePageState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        /*decoration: BoxDecoration(
            image: DecorationImage(
                //image: AssetImage('assets/images/my_bg.png'),
                fit: BoxFit.cover)),*/
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.phone, color: Colors.white,),
                label: Text(
                  'LOGIN WITH PHONE', style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/