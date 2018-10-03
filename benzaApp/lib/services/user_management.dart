import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(user, context) {
    Firestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid
    }).then((doc) {

      print ("adding new user to database!");
      Navigator.of(context)
        ..pop()
        ..pushReplacementNamed('/homepage');

    }).catchError((e) {
      print(e);
    });
  }
}
