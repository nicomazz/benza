import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(user, context) {
    Firestore.instance.collection('/users').document(user.uid).setData({
      'email': user.email,
      'uid': user.uid
    }).then((doc) {

      print ("\n*** adding new user to firestore database ***\n");
      

    }).catchError((e) {
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
