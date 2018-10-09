import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(user, context) {
    Firestore.instance.collection('/users').document(user.uid).setData({
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

  onProfileImageChanged(user, newUri, context) {
    Firestore.instance.collection('/users').document(user.uid).updateData({
      "imageUri": newUri
    }).then((_) {
      print("changed!");
    });
  }
}
