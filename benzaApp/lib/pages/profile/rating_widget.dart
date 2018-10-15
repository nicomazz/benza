import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  final DocumentSnapshot user;

  final FirebaseUser currentUser;

  @override
  _RatingWidgetState createState() => _RatingWidgetState();

  RatingWidget(this.user, this.currentUser);
}

class _RatingWidgetState extends State<RatingWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
      child: widget.user == null || widget.currentUser == null
          ? LinearProgressIndicator()
          : StreamBuilder<QuerySnapshot>(
              stream: _getRatingsCollection().snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                var precedentVoteDoc = snapshot.data.documents.firstWhere(
                    (d) => d.documentID == widget.currentUser.uid,
                    orElse: () => null);
                String precVote =
                    precedentVoteDoc != null ? precedentVoteDoc["type"] : "";
                return Container(
                  child: Row(
                    children: <Widget>[
                      _constructThumb(
                          icon: Icons.thumb_up,
                          function: () => _vote("up"),
                          default_color: Colors.green,
                          id: "up",
                          prec_vote: precVote),
                      Expanded(
                          child: LinearProgressIndicator(
                        value: _getUpPercentage(snapshot.data.documents),
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.green),
                        backgroundColor: Colors.red,
                      )),
                      _constructThumb(
                          icon: Icons.thumb_down,
                          function: () => _vote("down"),
                          default_color: Colors.red,
                          id: "down",
                          prec_vote: precVote),
                    ],
                  ),
                );
              },
            ),
    );
  }

  _getRatingsCollection() => Firestore.instance
      .collection('users')
      .document(widget.user.data["uid"])
      .collection("ratings");

  _getUpPercentage(List<DocumentSnapshot> data) {
    var up = 0;
    var down = 0;
    for (var d in data) {
      if (d["type"] == "up")
        up++;
      else if (d["type"] == "down")
        down++;
    }
    if (up == 0 && down == 0) return 0.5;
    return up / (up + down);
  }

  _constructThumb({icon, function, default_color, id, prec_vote}) {
    var color = id == prec_vote ? default_color : Colors.grey;
    return InkWell(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          size: 40.0,
          color: color,
        ),
      ),
    );
  }

  void _vote(String s) async {
    final DocumentReference docRef =
        _getRatingsCollection().document(widget.currentUser.uid);
    final DocumentSnapshot doc = await docRef.get();
    if (doc.exists) {
      if (doc["type"] == s) s = "";
    }
    Firestore.instance.runTransaction((Transaction tx) async {
      await tx.set(docRef, {"type": s});
    });
  }
}
