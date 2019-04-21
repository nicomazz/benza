import 'package:benza/services/user_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _email;
  String _password;
  String _userName;

  bool _signUpProgress = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Sign up!'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //The Name textfield does not have any restrictions
              TextField(
                  controller: TextEditingController(text: _userName),
                  decoration: InputDecoration(hintText: 'Name'),
                  autofocus: true,
                  onChanged: (value) {
                    _userName = value;
                  }),
              SizedBox(height: 10.0),
              //The Email textfield provides basic input validation for correct email formats (e.g. x@y.z)
              TextField(
                  controller: TextEditingController(text: _email),
                  decoration: InputDecoration(hintText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    _email = value;
                  }),
              SizedBox(height: 10.0),
              //The Password textfield forces the user to choose a password with over 6 characters.
              //This needs to be improved in the future.
              TextField(
                  controller: TextEditingController(text: _password),
                  decoration: InputDecoration(hintText: 'Password'),
                  obscureText: true,
                  onChanged: (value) {
                    _password = value;
                  }),
              SizedBox(height: 10.0),
              //If the signup button hasn't been pressed, display the rest of the page. 
              //If it has, display Loading screen.
              _signUpProgress
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      child: Text('Sign Up'),
                      color: Colors.blue,
                      textColor: Colors.white,
                      elevation: 7.0,
                      onPressed: () {
                        setState(() => _signUpProgress = true);
                        //Creating a new registered user in the Firebase Authentication tool
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _email, password: _password)
                            .then((FirebaseUser signedInUser) {
                          setState(() => _signUpProgress = false);
                          //Creating a record for the new user in the Firebase Cloud Firestore tool
                          UserManagement()
                              .storeNewUser(signedInUser, context, _userName);
                          //Proceed to the homepage of the app. This will be set to the profile page.
                          Navigator.of(context)
                            ..pop()
                            ..pushReplacementNamed('/homepage');
                        }).catchError((e) {
                          setState(() => _signUpProgress = false);
                          print(e);
                        });
                      }),
            ],
          ),
        ),
      ),
    );
  }
}
