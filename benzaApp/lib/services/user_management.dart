import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(user, context, _userName) {
    Firestore.instance.collection('/users')
    .document(user.uid).setData({
      'name': _userName,
      'email': user.email,
      'uid': user.uid,
      'photoUrl': user.photoUrl, // will always be null on create
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
      print("\n*** profile picture for user: $user changed ***\n");
    });
  }
}