import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutterwhatsapp/api/sound_recorder.dart';
import '../models/messages.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'camera_screen.dart';
/*
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:flutter_sound_lite/public/tau.dart';
import 'package:flutter_sound_lite/public/ui/recorder_playback_controller.dart';
import 'package:flutter_sound_lite/public/ui/sound_player_ui.dart';
import 'package:flutter_sound_lite/public/ui/sound_recorder_ui.dart';
import 'package:flutter_sound_lite/public/util/enum_helper.dart';
import 'package:flutter_sound_lite/public/util/flutter_sound_ffmpeg.dart';
import 'package:flutter_sound_lite/public/util/flutter_sound_helper.dart';
import 'package:flutter_sound_lite/public/util/temp_file_system.dart';
import 'package:flutter_sound_lite/public/util/wave_header.dart';*/
//import 'package:flutterwhatsapp/pages/camera_screen.dart';
//import 'package:flutterwhatsapp/models/risposta.dart';
//import 'package:flutter_session/flutter_session.dart';
//import '../models/login_data.dart';

// ignore: must_be_immutable
class ChatScreen23 extends StatefulWidget {
  final User user;
  final String token;
  final String contatto;
  final List<CameraDescription> cameras;
  ChatScreen23({this.token, this.user, this.contatto, this.cameras});

  bool isPlaying = false;
  bool recorded = false;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen23> {
  final recorder = SoundRecorder();
  final audioplayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  void initState() {
    super.initState();
    recorder.init();
    audioplayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioplayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    audioplayer.onPlayerCompletion.listen((wow) {
      setState(() {
        widget.isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  bool isWriting = false;
  Future<http.Response> sendTicket(text, contatto, token) async {
    final response = await http.post(
      Uri.parse('https://centralino.gamwki.it/api/crea_ticket/' + token),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'messaggio': text,
        'contatto': contatto,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return response;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return response;
    }
  }

  Future<http.Response> sendPath(text, path1, contatto, token) async {
    final response = await http.post(
      Uri.parse('https://centralino.gamwki.it/api/crea_ticket/' + token),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'messaggio': text,
        'contatto': contatto,
        'vocale': path1,
      }),
    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return response;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return response;
    }
  }

  var text;
  _buildMessage(Message message, bool isMe) {
    String contatto = widget.contatto;
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe
            ? Theme.of(context).colorScheme.secondary
            : Colors.lightBlueAccent,
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(20.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        children: <Widget>[
          new ListTile(
            onTap: () {},
            leading: new CircleAvatar(
              radius: 22,
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage('assets/logo.png'),
            ),
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  currentUser.name,
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            subtitle: new Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: new Text(
                message.isLiked
                    ? 'Ciao $contatto' + message.text
                    : message.text,
                style: new TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ),
          )
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg, /*
        IconButton(
          icon: message.isLiked
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border),
          iconSize: 30.0,
          color: message.isLiked
              ? Theme.of(context).primaryColor
              : Colors.blueGrey,
          onPressed: () {},
        )*/
      ],
    );
  }

  _buildMessageComposer() {
    String token = widget.token;
    String contatto = widget.contatto;
    bool isRecording = recorder.isRecording;
    bool recorded = widget.recorded;

    /*
    IconButton(
          icon: Icon(Icons.mic),
          onPressed: () async {
            if (isPlaying == true) {
              await audioplayer.pause();
            } else {
              await audioplayer.play(
                  '/data/user/0/com.example.flutterwhatsapp/cache/audio_example.aac');
            }
          },
        ),
    */
    if (recorded == false) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        height: 70.0,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              iconSize: 25.0,
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                await availableCameras().then(
                  (value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraPage(
                          cameras: value,
                          token: widget.token,
                          contatto: widget.contatto),
                    ),
                  ),
                ); /*
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text("Errore!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                            const Text("Funzionalità ancora non disponibile.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                            const SizedBox(
                              height: 16,
                            ),
                            MaterialButton(
                              onPressed: () async {
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: const Text("Esci",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                              color: Color.fromARGB(174, 140, 235, 123),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              minWidth: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    );
                  });*/
              },
            ),
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  text = value;
                  if (text != null)
                    setState(() {
                      isWriting = true;
                    });
                  else
                    setState(() {
                      isWriting = false;
                    });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Scrivi qui il tuo ticket...',
                ),
              ),
            ),
            IconButton(
                icon: isWriting ? Icon(Icons.send) : Icon(Icons.mic),
                iconSize: 25.0,
                color:
                    isRecording ? Colors.red : Theme.of(context).primaryColor,
                onPressed: () async {
                  if (text != null && isWriting == true) {
                    var risposta = await sendTicket(text, contatto, token);
                    // ignore: unrelated_type_equality_checks
                    if (risposta.statusCode == 200 ||
                        risposta.statusCode == 201) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 30),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                        "Grazie per aver inviato il Ticket, verrà risolto il prima possibile!",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        setState(() {});
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Arrivederci"),
                                      color: Color.fromARGB(174, 140, 235, 123),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      minWidth: double.infinity,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 30),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Text("Errore!",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                        "Non riusciamo a ricevere il ticket. Riprova più tardi",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        setState(() {});
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Riprova"),
                                      color: Color.fromARGB(174, 140, 235, 123),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      minWidth: double.infinity,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  } /*else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 30),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text("Errore!",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  const Text(
                                      "Impossibile mandare un ticket vuoto",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  MaterialButton(
                                    onPressed: () async {
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Riprova"),
                                    color: Color.fromARGB(174, 140, 235, 123),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    minWidth: double.infinity,
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }*/
                  if (text == null && isWriting == false) {
                    final isRecording = await recorder.toggleRecording();
                    if (isRecording != null) {
                      setState(() {
                        widget.recorded = true;
                      });
                    } else
                      setState(() {});
                  } else {}
                }),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        height: 70.0,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: (widget.isPlaying)
                  ? Icon(Icons.pause)
                  : Icon(Icons.play_arrow),
              iconSize: 30.0,
              onPressed: () async {
                if (widget.isPlaying == true) {
                  await audioplayer.pause();
                  setState(() {
                    widget.isPlaying = false;
                  });
                } else {
                  await audioplayer.play(
                      '/data/user/0/com.example.flutterwhatsapp/cache/audio_example.mp4');
                  setState(() {
                    widget.isPlaying = true;
                  });
                }
              },
            ),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  disabledActiveTrackColor: Colors.blue,
                  disabledInactiveTrackColor: Colors.black12,
                  trackHeight: 0.5,
                ),
                child: Slider.adaptive(
                  min: 0,
                  max: duration.inMicroseconds.toDouble(),
                  value: position.inMicroseconds.toDouble(),
                  onChanged: (value) async {
                    Duration(microseconds: value.toInt());
                  },
                ),
              ),

              /*
              child: TextField(
                
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  text = value;
                  if (text != '')
                    setState(() {
                      isWriting = true;
                    });
                  else
                    setState(() {
                      isWriting = false;
                    });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Scrivi qui il tuo ticket...',
                ),
              ),*/
            ),
            IconButton(
                icon: Icon(Icons.send),
                iconSize: 25.0,
                color: Colors.blue,
                onPressed: () async {
                  if (widget.recorded == true) {
                    String path =
                        '/data/user/0/com.example.flutterwhatsapp/cache/audio_example.mp4';
                    File file = File(path);
                    List<int> fileBytes = await file.readAsBytes();
                    String path1 = base64Encode(fileBytes);
                    text = 'Vocale da App';
                    var risposta = await sendPath(text, path1, contatto, token);
                    // ignore: unrelated_type_equality_checks
                    if (risposta.statusCode == 200 ||
                        risposta.statusCode == 201) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 30),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                        "Grazie per aver inviato il Ticket, verrà risolto il prima possibile!",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        setState(() {});
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Arrivederci"),
                                      color: Color.fromARGB(174, 140, 235, 123),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      minWidth: double.infinity,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 30),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Text("Errore!",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const Text(
                                        "Non riusciamo a ricevere il ticket. Riprova più tardi",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    MaterialButton(
                                      onPressed: () async {
                                        setState(() {});
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Riprova"),
                                      color: Color.fromARGB(174, 140, 235, 123),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      minWidth: double.infinity,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  } else {
                    final isRecording = await recorder.toggleRecording();
                    if (isRecording != null) {
                      setState(() {
                        widget.recorded = true;
                      });
                    } else
                      setState(() {});
                  }
                }),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
   // String contatto = widget.contatto;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          'Sezione Ticket',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        //backgroundColor: Color(0x044A43),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: new DecorationImage(
                    image: ExactAssetImage('assets/Whatsapp.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 15.0),
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Message message = messages[index];
                      final bool isMe = message.sender.id == currentUser.id;
                      return _buildMessage(message, isMe);
                    },
                  ),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
