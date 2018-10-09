import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];

  ScrollController _listScrollController;

  @override
  void initState() {
    _listScrollController = new ScrollController();
  } // new


  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme
          .of(context)
          .accentColor),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration: new InputDecoration.collapsed(
                      hintText: "Send a message"),
                ),
              ),
              new Container(margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => _handleSubmitted(_textController.text)
                ),)
            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Column( //modified
      children: <Widget>[ //new
        new Flexible( //new
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
                return Center(
                    child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemBuilder: (context, index) =>
                      buildItem(snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents.length,
                  reverse: true,
                  controller: _listScrollController,
                );
              }
            },
          ), //new
        ), //new
        new Divider(height: 1.0), //new
        new Container( //new
          decoration: new BoxDecoration(
              color: Theme
                  .of(context)
                  .cardColor), //new
          child: _buildTextComposer(), //modified
        ), //new
      ], //new
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();

    var documentReference = Firestore.instance
        .collection('messages')
        .document("group_id")
        .collection("group_id")
        .document(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        {
          'idFrom': 42,
          'idTo': 42,
          'timestamp': DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(),
          'content': text,
          'type': "message"
        },
      );
    });
    _listScrollController.animateTo(
        0.0, duration: Duration(milliseconds: 1000), curve: Curves.easeOut);
  }

  @override
  void dispose() {
    //new
    for (ChatMessage message in _messages) //new
      message.animationController.dispose(); //new
    super.dispose(); //new
  }

  buildItem(DocumentSnapshot document) {
    var message = new ChatMessage( //new
        text: document.data["content"], //new
        animationController: new AnimationController( //new
          duration: new Duration(milliseconds: 500), //new
          vsync: this, //new
        )
    );
    //message.animationController.forward();
    return message;
  }
}

const String _name = "Mario rossi";

class ChatMessage extends StatelessWidget {

  ChatMessage(
      {this.text, this.sender_id, this.animationController, this.user_id});

  final String text;
  final AnimationController animationController; //new
  final String user_id;
  final String sender_id;


  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        //textDirection: sender_id != user_id ? TextDirection.rtl : TextDirection.ltr,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(child: new Text(_name[0])),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_name, style: Theme
                    .of(context)
                    .textTheme
                    .subhead),
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