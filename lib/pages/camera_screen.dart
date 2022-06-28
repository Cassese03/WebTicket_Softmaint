import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart'; /*
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';*/
import 'camera_view.dart';
import 'video_view.dart';

// ignore: must_be_immutable
class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  String token;
  String contatto;
  CameraPage({this.cameras, Key key, this.token, this.contatto})
      : super(key: key);
  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  CameraController controller;
  XFile pictureFile;
  bool flash = false;
  bool isRecording = false;

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    Navigator.push(
        this.context,
        MaterialPageRoute(
            builder: (builder) => CameraViewPage(
                path: image.path,
                token: widget.token,
                contatto: widget.contatto)));
  }

  @override
// ignore: must_call_super
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.high,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        controller.setFlashMode(FlashMode.off);
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SafeArea(
      child: Material(
          child: Stack(
        children: [
          Positioned(
            top: 0.0,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20.0,
                        height: 78.0,
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_sharp,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: CameraPreview(controller),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.photo,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            pickImage();
                          }),
                      GestureDetector(
                        onLongPress: () async {
                          await controller.startVideoRecording();
                          setState(() {
                            isRecording = true;
                            print(isRecording);
                          });
                        },
                        onLongPressUp: () async {
                          XFile videoFile =
                              await controller.stopVideoRecording();
                          setState(() {
                            print(isRecording);
                            isRecording = false;
                            print(isRecording);
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => VideoViewPage(
                                      path: videoFile.path,
                                      token: widget.token,
                                      contatto: widget.contatto)));
                        },
                        onTap: () async {
                          if (isRecording == false) {
                            pictureFile = await controller.takePicture();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => CameraViewPage(
                                        path: pictureFile.path,
                                        token: widget.token,
                                        contatto: widget.contatto)));
                          }
                        },
                        child: isRecording
                            ? Icon(
                                Icons.radio_button_on,
                                color: Colors.red,
                                size: 70,
                              )
                            : Icon(
                                Icons.panorama_fish_eye,
                                color: Colors.white,
                                size: 70,
                              ),
                      ),
                      IconButton(
                          icon: Icon(
                            flash ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            if (flash) {
                              controller.setFlashMode(FlashMode.off);
                              setState(() {
                                flash = !flash;
                              });
                            } else {
                              controller.setFlashMode(FlashMode.torch);
                              setState(() {
                                flash = !flash;
                              });
                            }
                          }), // IconButton
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
/*
final size = MediaQuery.of(context).size;
final deviceRatio = size.width / size.height;
return Transform.scale(
  scale: controller.value.aspectRatio / deviceRatio,
  child: Center(
    child: AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    ),
  ),
);
*/
/*
          Transform.scale(
            scale: controller.value.aspectRatio / deviceRatio,
            child: Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CameraPreview(controller),
              ),
            ),
          ),*/
