import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';

  bool _loginInProgress = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(50.0),
          child: ListView(
            children: <Widget>[
              TextField(
                  decoration: InputDecoration(hintText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  }),
              TextField(
                  decoration: InputDecoration(hintText: 'Password'),
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  }),
              SizedBox(height: 15.0),
              //If the login button hasn't been pressed, display the rest of the page. 
              //If it has, display Loading screen.
              _loginInProgress
                  ? Center(child: CircularProgressIndicator())
                  : new Column(
                      children: <Widget>[
                        RaisedButton(
                            child: Text('Login'),
                            color: Colors.blue,
                            textColor: Colors.white,
                            elevation: 7.0,
                            onPressed: () {
                              if (_email==''||_password=='') {
                                _showDialog();
                              }
                              //FirebaseAuth.instance.currentUser()
                              setState(() => _loginInProgress = true);
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: _email, password: _password)
                                  .then((FirebaseUser user) {
                                setState(() => _loginInProgress = false);
                                Navigator.of(context)
                                    .pushReplacementNamed('/homepage');
                              }).catchError((e) {
                                //setState(() => _loginInProgress = false);
                                print(e);
                              });
                            }),
                        SizedBox(
                          height: 60.0,
                        ),
                        Text(
                          'Don\'t have an account?',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 15.0,
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
            ],
          ),
        ),
      ),
    );
  }

  ///Warning the user that they are not allowed to have any blank fields when tapping the Login button.
  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Oopsie"),
          content: new Text("You can't login with blank fields."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  Navigator.of(context).pushReplacementNamed('/landingpage');
                });
              },
            )
          ],
        );
      },
    );
  }
}
