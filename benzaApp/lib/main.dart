import 'package:benza/pages/home_page.dart';
import 'package:benza/pages/login/login_page.dart';
import 'package:benza/pages/login/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Widget _handleCurrentScreen() {
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("waiting");
            return new Text("loading..");
          } else {
            //user already logged in
            if (snapshot.hasData) {
              print ("we already have data");
              return new HomePage();
              // firestore: firestore, uuid: snapshot.data.uid);
            }
            print("displaying login");
            return new LoginPage();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: _handleCurrentScreen(),//LoginPage(),
        routes: <String, WidgetBuilder>{
          '/landingpage': (BuildContext context) => MyApp(),
          '/signup': (BuildContext context) => SignUpPage(),
          '/homepage': (BuildContext context) => HomePage()
        });
  }
}
