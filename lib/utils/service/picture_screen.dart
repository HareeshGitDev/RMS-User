import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../theme/custom_theme.dart';

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
  late StreamSubscription<ConnectivityResult> _connectivitySubs;
  final Connectivity _connectivity = Connectivity();
  bool _connectionStatus = true;

  Future<void> initConnectionStatus() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      log(e.toString());
    }
    if (!mounted) {
      return null;
    }

    _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() => _connectionStatus = true);
        break;
      case ConnectivityResult.mobile:
        setState(() => _connectionStatus = true);
        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = false);
        break;
      case ConnectivityResult.ethernet:
        setState(() => _connectionStatus = true);
        break;
      default:
        setState(() => _connectionStatus = false);
        break;
    }
  }



  @override
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

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
    _connectivitySubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _connectionStatus?WillPopScope(
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
    ):RMSWidgets.networkErrorPage(context: context);
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