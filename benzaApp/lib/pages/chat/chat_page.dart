import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[]; // new

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
          child: new ListView.builder( //new
            padding: new EdgeInsets.all(8.0), //new
            reverse: true, //new
            itemBuilder: (_, int index) => _messages[index], //new
            itemCount: _messages.length, //new
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
    ChatMessage message = new ChatMessage( //new
        text: text, //new
        animationController: new AnimationController( //new
          duration: new Duration(milliseconds:500), //new
          vsync: this, //new
        )
    ); //new
    setState(() { //new
      _messages.insert(0, message); //new
    });
    message.animationController.forward();
  }

  @override
  void dispose() {
    //new
    for (ChatMessage message in _messages) //new
      message.animationController.dispose(); //new
    super.dispose(); //new
  }
}

const String _name = "Mario rossi";

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});

  final String text;
  final AnimationController animationController; //new

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(_name, style: Theme
                    .of(context)
                    .textTheme
                    .subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}