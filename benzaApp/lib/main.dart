import 'package:benza/pages/home_page.dart';
import 'package:benza/pages/login/login_page.dart';
import 'package:benza/pages/login/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  //timeDilation = 5.0; // use to test animations
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  //auth management. It check if the user is logged in correctly
  Widget _handleCurrentScreen() {
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return new Text("loading..");

          //user already logged in
          if (snapshot.hasData) return new HomePage();

          return new LoginPage();
        });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          primaryColor: Colors.blue,
          accentColor: Colors.cyan[600], // tabbar color
        ),
        debugShowCheckedModeBanner: false,
        home: _handleCurrentScreen(),
        //LoginPage(),// for testing, put this the page
        routes: <String, WidgetBuilder>{
          '/landingpage': (BuildContext context) => MyApp(),
          '/signup': (BuildContext context) => SignUpPage(),
          '/homepage': (BuildContext context) => HomePage()
        });
  }
}
