import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];

  ScrollController _listScrollController;

  DocumentSnapshot currentUser;

  @override
  void initState() {
    _listScrollController = new ScrollController();
    initUser();
  } // new

  initUser() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    currentUser = await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .get();
    setState(() {});
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  //onSubmitted: _handleSubmitted, // sends an empty message when you click the tick on keyboard to make it (the keyboard) go away
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_textController.text)),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null)
      return Center(
        child: CircularProgressIndicator(),
      );

    return new Column(
      //modified
      children: <Widget>[
        //new
        new Flexible(
          //new
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('messages')
                .document("group_id")
                .collection("group_id")
                .orderBy('timestamp', descending: true)
                .limit(20)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) =>
                      buildItem(snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents.length,
                  reverse: true,
                  controller: _listScrollController,
                );
              }
            },
          ),
        ),
        new Divider(height: 1.0),
        new Container(
          decoration:
              new BoxDecoration(color: Theme.of(context).cardColor), //new
          child: _buildTextComposer(), //modified
        ),
      ],
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();

    var documentReference = Firestore.instance
        .collection('messages')
        .document("group_id")
        .collection("group_id")
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        {
          'nameFrom': currentUser["name"],
          'idFrom': currentUser.documentID,
          //'idTo': 42,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': text,
          'type': "message"
        },
      );
    });
    _listScrollController.animateTo(0.0,
        duration: Duration(milliseconds: 1000), curve: Curves.easeOut);
  }

  @override
  void dispose() {
    //new
    for (ChatMessage message in _messages) //new
      message.animationController.dispose(); //new
    super.dispose(); //new
  }

  buildItem(DocumentSnapshot document) {
    var message = new ChatMessage(
      //new
      text: document.data["content"],
      //new
      animationController: new AnimationController(
        //new
        duration: new Duration(milliseconds: 500), //new
        vsync: this, //new
      ),
      senderID: document["idFrom"],
      userID: currentUser.documentID,
      userName: document["nameFrom"] ?? "-",
    );
    //message.animationController.forward();
    return Column(children: <Widget>[
      new Divider(height: 1.0),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
        child: message,
      ), //new
    ]);
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {this.text,
      this.senderID,
      this.animationController,
      this.userID,
      this.userName = "-"});

  final String text;
  final AnimationController animationController; //new
  final String userID;
  final String senderID;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        textDirection:
            senderID == userID ? TextDirection.rtl : TextDirection.ltr,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(
              child: new Text(userName[0].toUpperCase()),
              backgroundColor: Colors
                  .primaries[userName.hashCode % Colors.primaries.length],
              foregroundColor: Colors.white,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(this.userName,
                    style: Theme.of(context).textTheme.subhead),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
