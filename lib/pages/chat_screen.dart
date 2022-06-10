import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import 'open_chat_screen.dart';

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  // ignore: deprecated_member_use
  List<ChatModel> _notes = List<ChatModel>();

  Future<List<ChatModel>> fetchNotes() async {
    //var token = await FlutterSession().get("token");
    var token = 'mDLKbai0cQwLl6F4x3mNVAFFHMiucVPdj3h3ahHYksM2TYZTIa';

    var url = 'https://centralino.gamwki.it/api/ticket_aperti/' + token;

    var response = await http.get(Uri.parse(url));

    // ignore: deprecated_member_use
    var notes = List<ChatModel>();

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(ChatModel.fromJson(noteJson));
      }
    }
    return notes;
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
      });
    });
    return new ListView.builder(
      itemCount: _notes.length,
      itemBuilder: (context, index) => new Column(
        children: <Widget>[
          new Divider(
            height: 10.0,
          ),
          new ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new ChatScreen23(token: 'ciao')),
            ),
            leading: new CircleAvatar(
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              backgroundImage: new NetworkImage(
                  'https://centralino.gamwki.it/img/icona.png'),
            ),
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  _notes[index].name,
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text(
                  _notes[index].time.substring(11),
                  style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                ),
              ],
            ),
            subtitle: new Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: new Text(
                _notes[index].message,
                style: new TextStyle(color: Colors.grey, fontSize: 15.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
