import 'package:benza/pages/groups/create_group_page.dart';
import 'package:benza/pages/home_page.dart';
import 'package:benza/pages/login/login_page.dart';
import 'package:benza/pages/login/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///This is what start the whole application
void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  //Authentication management. Checks if the user is logged in correctly
  Widget _handleCurrentScreen() {
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          //If the user is signed out
          if (snapshot.connectionState == ConnectionState.none) {
            Text("no connection..");
          } else {
            //If already logged in, go straight to the home page for that user
            if (snapshot.hasData) {
              return new HomePage();
            }
          }
          //Default: no connection, display the login screen
          return new LoginPage();
        });
  }

  //Here we declare application-wide settings like colour scheme and routes between certain pages.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Benza',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          accentColor: Colors.cyan[600], // tab bar color
        ),
        debugShowCheckedModeBanner: false,
        home: _handleCurrentScreen(),
        routes: <String, WidgetBuilder>{
          '/landingpage': (BuildContext context) => MyApp(),
          '/signup': (BuildContext context) => SignUpPage(),
          '/homepage': (BuildContext context) => HomePage(),
        }
    );
  }
}
