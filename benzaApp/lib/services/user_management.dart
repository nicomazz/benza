import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(user, context, _userName) {
    Firestore.instance.collection('/users')
    .document(user.uid).setData({
      'name': _userName,
      'email': user.email,
      'uid': user.uid,
      'bio': "Say something about yourself!",
    })
    .then((doc) {
      print ("\n*** adding new user to firestore database ***\n");
    })
    .catchError((e) {
      print(e);
    });
  }

  onProfileImageChanged(user, newUri, context) {
    Firestore.instance.collection('/users').document(user.uid).updateData({
      "imageUri": newUri
    }).then((_) {
      print("\n*** ${user.uid} changed their profile picture ***\n");
      Navigator.of(context)
        ..pop()
        ..pushReplacementNamed('/homepage');
    });
  }
}