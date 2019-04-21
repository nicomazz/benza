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

  ///Sets the current user to the one that is logged in.
  ///This will need to be changed when development continues on the peer rating feature so that profile pages can display uids that are handed to them instead of just the one belonging to the current user.
  updateUser() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
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
    //Getting the data from the current user's cloud firestore record
    var imgSize = MediaQuery.of(context).size.width / 3;
    var data = displayedUser?.data ?? Map();
    var photoUrl = data["imageUri"];
    var userName = data["name"];
    var description = data["bio"];

    //The default image is a gorilla from Cincinatti Zoo, called Harambe. This will change before the application is released for closed alpha testing.
    var image = Container(
      width: imgSize,
      height: imgSize,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              //Here, we check if there's a link to an actual profile photo in the user's firestore record.
              image: CachedNetworkImageProvider(photoUrl ??
                  //If there's no link to a photo in the Firestore record, Harambe is used.
                  "https://www.gannett-cdn.com/-mm-/cdeb9a9e093b3172aa58ea309e74edcf80bf651f/c=0-77-2911-1722/local/-/media/2016/05/29/Cincinnati/Cincinnati/636001135964333349-Harambe2.jpg?width=3200&height=1680&fit=crop"),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(imgSize / 2),
          boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black)]),
    );
    var name = Text(
      userName ?? 'Username',
      style: TextStyle(fontSize: 40.0, fontStyle: FontStyle.italic),
    );

    //This widget represents the finished layout of the profile page, excluding the rating widget.
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
        InkWell(
          onTap: () {
            //This is where the logic will appear for the user being able to edit their own bio.
          },
          child: Text(
            description ?? 'Bio goes here',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 18.0, color: Colors.black.withOpacity(0.5)),
          ),
        ),
      ],
    );
    
    //The whole page structure
    return Scaffold(
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
            //This is where the elements that appear on the page are specified
            child: Column(
              mainAxisSize: MainAxisSize.max,
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

  ///Basically a getter for a Future object representing the user's profile info
  Future getProfileInfo() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    if (currentUser != null) {}
  }

  ///Select a picture from the device's gallery
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

  ///Uploads the picture to the Firebase storage bucket and inserts the link to that picture in the user's firestore record.
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

  ///This method was a possible concept that was not included in the requirements analysis.
  ///It will remain here because it will become important and necessary as the application grows.
  void _editProfile() {}
}

class MyButton extends StatelessWidget {
  final color;
  final text;

  final shadowColor;

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
          onTap: () {
            //DO SOMETHING
          },
          child: Center(
            child: Text(
              this.text,
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
          ),
        ),
      ),
    );
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
