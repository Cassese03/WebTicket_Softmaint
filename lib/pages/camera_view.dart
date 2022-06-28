// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'package:loading_animations/loading_animations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CameraViewPage extends StatefulWidget {
  CameraViewPage({Key key, this.path, this.token, this.contatto})
      : super(key: key);
  final String path;
  String token;
  String contatto;
  CameraViewPageState createState() => CameraViewPageState();
}

class CameraViewPageState extends State<CameraViewPage> {
  bool isLoading = false;
  Future<http.Response> sendTicket(text, contatto, token, image) async {
    final response = await http.post(
      Uri.parse('https://webticket.softmaint.it/api/crea_ticket/' + token),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'messaggio': text + ' ' + image,
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

  Future<http.Response> sendPath(text, path, contatto, token) async {
    final response = await http.post(
      Uri.parse('https://webticket.softmaint.it/api/crea_ticket/' + token),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'messaggio': text,
        'contatto': contatto,
        'immagine': path,
      }),
    );
    print(response.body);
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

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    return isLoading
        ? Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/logo.png'),
                SizedBox(
                  height: 50,
                ),
                LoadingJumpingLine.circle()
              ],
            ),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              actions: [
                /*
          IconButton(
              icon: Icon(
                Icons.crop_rotate,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.emoji_emotions_outlined,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.title,
                size: 27,
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.edit,
                size: 27,
              ),
              onPressed: () {}),*/
              ],
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 150,
                    child: Image.file(
                      File(widget.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      color: Colors.black38,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: TextFormField(
                        controller: firstNameController,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                        maxLines: 6,
                        minLines: 1,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Scrivi il Ticket....",
                            /* prefixIcon: Icon(
                        Icons.add_photo_alternate,
                        color: Colors.white,
                        size: 27,
                      ),*/
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                            suffixIcon: CircleAvatar(
                              radius: 27,
                              backgroundColor: Colors.tealAccent[700],
                              child: IconButton(
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 27,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  File imageFile = new File(widget.path);
                                  List<int> imageBytes =
                                      await imageFile.readAsBytes();
                                  String path2 = base64Encode(imageBytes);
                                  var risposta = await sendPath(
                                      firstNameController.text,
                                      path2,
                                      widget.contatto,
                                      widget.token);
                                  if (risposta.statusCode == 200 ||
                                      risposta.statusCode == 201) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    print(risposta.body);
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 30),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  const Text(
                                                      "Grazie per aver inviato il Ticket, verrà risolto il prima possibile!",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  MaterialButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                        "Arrivederci"),
                                                    color: Color.fromARGB(
                                                        174, 140, 235, 123),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
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
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 30),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  const Text("Errore!",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  const Text(
                                                      "Non riusciamo a ricevere il ticket. Riprova più tardi",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  const SizedBox(
                                                    height: 16,
                                                  ),
                                                  MaterialButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        const Text("Riprova"),
                                                    color: Color.fromARGB(
                                                        174, 140, 235, 123),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                    minWidth: double.infinity,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                },
                              ),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
