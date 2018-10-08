import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProfileBody();
  }
}

class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var image_size = MediaQuery.of(context).size.width / 3;

    var image = Container(
      width: image_size,
      height: image_size,
      decoration: BoxDecoration(
          color: Colors.red,
          image: DecorationImage(
              image: NetworkImage(
                  "https://randomuser.me/api/portraits/men/46.jpg"),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(image_size / 2),
          boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.black)]),
    );
    var name = Text(
      'Mario rossi',
      style: TextStyle(fontSize: 40.0, fontStyle: FontStyle.italic),
    );

    var imageNameDescription = Column(children: <Widget>[
      image,
      SizedBox(height: 15.0),
      name,
      SizedBox(height: 10.0),
      Text(
        'I like to travel!',
        style: TextStyle(
            fontSize: 20.0, color: Colors.black.withOpacity(0.5)),
      )
    ],);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ClipPath(
              child: Container(color: Colors.black.withOpacity(0.8)),
              clipper: getClipper()),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
                top: (size.height / 6 + size.height / 3) / 2 - image_size / 2),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              //  mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                imageNameDescription,
                SizedBox(height: 25.0),
                MyButton("Left a review", Colors.green, Colors.greenAccent),
                SizedBox(height: 25.0),
                MyButton("Log out", Colors.red, Colors.redAccent)
              ],
            ),
          )
        ],
      ),
    );
  }
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

class getClipper extends CustomClipper<Path> {
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
