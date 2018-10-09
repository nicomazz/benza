import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = 'aaa@b.com';
  String _password = '123456';

  bool _loginInProgress = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Login page'),
      ),
      body: Center(
          child: Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                controller: TextEditingController(text: _email),
                decoration: InputDecoration(hintText: 'Email'),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                }),
            SizedBox(height: 15.0),
            TextField(
                controller: TextEditingController(text: _password),
                decoration: InputDecoration(hintText: 'Password'),
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                }),
            SizedBox(height: 20.0),
            _loginInProgress ? CircularProgressIndicator() : RaisedButton(
                child: Text('Login'),
                color: Colors.blue,
                textColor: Colors.white,
                elevation: 7.0,
                onPressed: () {
                  //FirebaseAuth.instance.currentUser()
                  setState(() => _loginInProgress = true);
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                      email: _email, password: _password)
                      .then((FirebaseUser user) {
                    setState(() => _loginInProgress = false);
                    //Navigator.of(context).pushReplacementNamed('/homepage');
                  }).catchError((e) {
                    setState(() => _loginInProgress = false);
                    print(e);
                  });
                }),
            SizedBox(
              height: 15.0,
            ),
            Text('Don\'t have an account?'),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
                child: Text('Sign Up'),
                color: Colors.blue,
                textColor: Colors.white,
                elevation: 7.0,
                onPressed: () {
                  Navigator.of(context).pushNamed('/signup');
                }),
          ],
        ),
      )),
    );
  }
}
