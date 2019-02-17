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
              TextField(
                  controller: TextEditingController(text: _email),
                  decoration: InputDecoration(hintText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  onChanged: (value) {
                    //setState(() {
                    _email = value;
                    //});
                  }),
              SizedBox(height: 15.0),
              TextField(
                  controller: TextEditingController(text: _password),
                  decoration: InputDecoration(hintText: 'Password'),
                  obscureText: true,
                  onChanged: (value) {
                    //setState(() {
                    _password = value;
                    //});
                  }),
              SizedBox(
                height: 10.0,
              ),
              _signUpProgress
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      child: Text('Sign Up'),
                      color: Colors.blue,
                      textColor: Colors.white,
                      elevation: 7.0,
                      onPressed: () {
                        setState(() => _signUpProgress = true); 
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _email, password: _password)
                            .then((FirebaseUser signedInUser) {
                                print("\n*** Signing up a user from signup page ***\n");
                          setState(() => _signUpProgress = false);
                          UserManagement().storeNewUser(signedInUser, context);
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
