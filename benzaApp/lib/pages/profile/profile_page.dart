import 'dart:async';
import 'dart:io';

import 'package:benza/pages/profile/rating_widget.dart';
import 'package:benza/services/user_management.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileWidget extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProfileBody();
  }
}

class ProfileBody extends StatefulWidget {
  @override
  ProfileBodyState createState() {
    return new ProfileBodyState();
  }
}

class ProfileBodyState extends State<ProfileBody> {
  File imageFile;

  bool isLoading = false;

  String imageUrl;

  DocumentSnapshot displayedUser;

  FirebaseUser _currentUser;

  @override
  void initState() {
    super.initState();
    updateUser();
  }

  updateUser() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    //todo modify here to see everyone
    displayedUser = await Firestore.instance
        .collection('users')
        .document(currentUser.uid)
        .get();
    setState(() {
      this._currentUser = currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    //var size = MediaQuery.of(context).size; // MediaQuery has its own .size attr
    var imgSize = MediaQuery.of(context).size.width / 3;
    var data = displayedUser?.data ?? Map();
    var photoUrl = data["imageUri"];
    var userName = data["name"];
    var description = data["description"];

    var image = Container(
      width: imgSize,
      height: imgSize,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: CachedNetworkImageProvider(
                  photoUrl ?? "https://www.gannett-cdn.com/-mm-/cdeb9a9e093b3172aa58ea309e74edcf80bf651f/c=0-77-2911-1722/local/-/media/2016/05/29/Cincinnati/Cincinnati/636001135964333349-Harambe2.jpg?width=3200&height=1680&fit=crop"),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(imgSize / 2),
          boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black)]),
    );
    var name = Text(
      userName ?? 'Username',
      style: TextStyle(fontSize: 40.0, fontStyle: FontStyle.italic),
    );

    var imageNameDescription = Column(
      children: <Widget>[
        InkWell(
            onTap: () {
              getImage();
            },
            child: image),
        SizedBox(height: 15.0),
        name,
        SizedBox(height: 10.0),
        Text(
          description ?? 'Benza testing meeting 29/01/2019',
          style:
              TextStyle(fontSize: 20.0, color: Colors.black.withOpacity(0.5)),
        )
      ],
    );

    return Scaffold(
      floatingActionButton: displayedUser != null
          ? FloatingActionButton(
              child: Icon(Icons.edit),
              onPressed: () {
                _editProfile();
              },
            )
          : null,
      body: Stack(
        children: <Widget>[
          ClipPath(
              child: Container(color: Theme.of(context).primaryColorDark),
              clipper: GetClipper()),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: imgSize / 3,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                imageNameDescription,
                RatingWidget(displayedUser, _currentUser)
              ],
            ),
          )
        ],
      ),
    );
  }

  Future getProfileInfo() async {
    var currentUser = await FirebaseAuth.instance.currentUser();

    if (currentUser != null) {}
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageFile = image;
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);

    imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var currentUser = await FirebaseAuth.instance.currentUser();
    UserManagement().onProfileImageChanged(currentUser, imageUrl, context);
    setState(() {
      isLoading = false;
    });
  }

  void _editProfile() {}
}

class MyButton extends StatelessWidget {
  var color;
  var text;

  var shadowColor;

  MyButton(this.text, this.color, this.shadowColor);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60.0,
        width: 100.0,
        child: Material(
            borderRadius: BorderRadius.circular(30.0),
            shadowColor: this.shadowColor,
            color: this.color,
            elevation: 7.0,
            child: GestureDetector(
                onTap: () {},
                child: Center(
                    child: Text(
                  this.text,
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                )))));
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height / 3);
    path.lineTo(size.width * 2, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
