import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// A screen that allows users to take a picture using a given camera.
class PictureScreen extends StatefulWidget {
  final CameraDescription camera;

   PictureScreen({
    required this.camera,
  });

  @override
  PictureScreenState createState() => PictureScreenState();
}

class PictureScreenState extends State<PictureScreen> {
  late CameraController _controller;

  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, "");
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Take a picture'),
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: CustomTheme.white),
            onPressed: () => Navigator.pop(context, ""),
          ),
        ),
        // Wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner
        // until the controller has finished initializing.
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return Center(
                    child: CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(CustomTheme.appTheme)));
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          // Provide an onPressed callback.
          onPressed: () async {
            // Take the Picture in a try / catch block. If anything goes wrong,
            // catch the error.
            try {
              try {
                await _controller.setFlashMode(FlashMode.off);
              } catch (e) {
                print(
                    "error----------------------------------------${e.toString()}");
              }

              // Ensure that the camera is initialized.
              await _initializeControllerFuture;
              // Attempt to take a picture and log where it's been saved.
              XFile file = await _controller.takePicture();
              // If the picture was taken, display it on a new screen.
              Navigator.pop(context, file.path);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         DisplayPictureScreen(imagePath: file.path),
              //   ),
              // );
            } catch (e) {
              // If an error occurs, log the error to the console.
              log(e.toString());
            }
          },
        ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({required Key key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}