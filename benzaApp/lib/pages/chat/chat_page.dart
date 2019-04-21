import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  //Adding an id parameter to this widget enabled each group to have its own unique chat based on group_id
  final int id;
  ChatPage(this.id);

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
  }

  ///Setting the [currentUser] to the user that is currently logged in, allowing us to access that user's firestore data
  initUser() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    currentUser = await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .get();
    //This is a bugfix for GitHub issue #11
    this.mounted ? setState(() {}) : context;
  }

  ///This widget is where users will type their messages for the chat.
  ///It also holds the button for sending those messages.
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
        ),
      ),
    );
  }

  //Main method for the chat page
  @override
  Widget build(BuildContext context) {
    //If there isn't a user currently logged in, display a loading screen
    if (currentUser == null)
      return Center(
        child: CircularProgressIndicator(),
      );

    //If there is a logged in user, build the chat history from the firestore data.
    return new Column(
      children: <Widget>[
        new Flexible(
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('chats')
                .document("group_id")
                .collection("${widget.id}")
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
        //This is where we tell the app that the message composer should be placed at the bottom of the chat history.
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ],
    );
  }

  ///Logic for the "Send Message" button
  void _handleSubmitted(String text) {
    //Clear the text field once the user taps the send button on their message
    _textController.clear();

    //Specify which part of the firestore database we'd like to store the message in
    var documentReference = Firestore.instance
        .collection('chats')
        .document("group_id")
        .collection("${widget.id}")
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    //Populate the document we just made (above) with our message's data
    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        {
          'nameFrom': currentUser["name"],
          'idFrom': currentUser.documentID,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': text,
          'type': "message"
        },
      );
    });
    //Nice UI animation
    _listScrollController.animateTo(0.0,
        duration: Duration(milliseconds: 1000), curve: Curves.easeOut);
  }

  //Make sure that animations finish properly
  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  //How messages from the firestore area are displayed within the chat
  buildItem(DocumentSnapshot document) {
    var message = new ChatMessage(
      text: document.data["content"],
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 500),
        vsync: this,
      ),
      senderID: document["idFrom"],
      userID: currentUser.documentID,
      userName: document["nameFrom"] ?? "-",
    );
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
          child: message,
        ),
      ],
    );
  }
}

///Constructing the internal layout of a message in the chat
class ChatMessage extends StatelessWidget {
  ChatMessage(
      {this.text,
      this.senderID,
      this.animationController,
      this.userID,
      this.userName = "null"});

  final String text;
  final AnimationController animationController; //new
  final String userID;
  final String senderID;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        textDirection:
            senderID == userID ? TextDirection.rtl : TextDirection.ltr,
        children: <Widget>[
          new Container(
            child: new CircleAvatar(
              child: new Text(userName[0].toUpperCase()),
              backgroundColor:
                  Colors.primaries[userName.hashCode % Colors.primaries.length],
              foregroundColor: Colors.white,
            ),
          ),
          Expanded(
            child: Column(
              textDirection:
                  senderID == userID ? TextDirection.rtl : TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 5.0),
                  child: senderID == userID
                      ? Text("")
                      : Text(
                          this.userName,
                          style: TextStyle(
                              fontSize: 10.0,
                              fontStyle: FontStyle.italic,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      bottom: 10.0, right: 5.0, left: 5.0),
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
