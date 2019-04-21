import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

///For interaction with the Firestore user data
class UserManagement {
  ///Stores a new user in the Firestore space with the details listed below.
  ///Profile photo field is missing because it is created when the user changes from the default picture.
  ///Same for ratings.
  ///bio should be changed so that is follows this behaviour as well, just showing a decoration text in the profile page instead of an actual value in the db.
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

  ///Creating the field that will hold the link to the user's new profile picture.
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