import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutterwhatsapp/login.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "WebTicket",
      theme: new ThemeData(
        primaryColor: new Color(0xff075E54),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: new Color(0xff25D366)),
      ),
      debugShowCheckedModeBanner: false,
      home: /*new WhatsAppHome(cameras:cameras)*/ new LoginPage(),
    );
  }
}
// per cambiare icona esegui -> flutter pub run flutter_launcher_icons:main