import 'dart:developer';
import 'dart:io';

import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'navigation_service.dart';


class CapturePhotoPage {

  static Future<dynamic> captureImageByGallery(
      {required BuildContext context,
        required Function(String) function}) async {
    PermissionStatus storePermission = await Permission.storage.request();

    if (Platform.isIOS) {

      if (storePermission.isDenied || storePermission.isPermanentlyDenied) {
        RMSWidgets.getToast(
            message:
            'Files and Media permissions are denied.Please enable it from settings.',
            color: Color(0xffF40909));

        await storagePermissionDialog(context: context);
      }
      else{

        final image = await ImagePicker.platform
            .pickImage(source: ImageSource.gallery, imageQuality: 5);
        if (image != null &&
            image.path != null &&
            image.path.toString().length > 5) {
          // RMSWidgets.showLoaderDialog(context: context, message: "Uploading");
          // dynamic response = await function(image.path);
          // Navigator.of(context).pop();

          return image.path;
        } else {
          return null;
        }
      }

    } else if (Platform.isAndroid) {

      if (storePermission.isDenied || storePermission.isPermanentlyDenied) {
        RMSWidgets.getToast(
            message:
            'Files and Media permissions are denied.Please enable it from settings.',
            color: Color(0xffF40909));

        await storagePermissionDialog(context: context);
      } else {
        final XFile? image = await ImagePicker()
            .pickImage(source: ImageSource.gallery, imageQuality: 5);
        if (image != null &&
            image.path != null &&
            image.path.toString().length > 5) {
          /*RMSWidgets.showLoaderDialog(
              context: context, message: "Uploading");
          dynamic response = await function(image.path);
          Navigator.of(context).pop();*/

          return image.path;
        } else {
          return null;
        }
      }
    }
  }

  static Future<dynamic> captureImageByCamera(
      {required BuildContext context,
        required Function(String) function}) async {
    if (Platform.isAndroid) {
      PermissionStatus isDenied = await Permission.camera.request();
      PermissionStatus isDeniedMicrophone =
      await Permission.microphone.request();

      if (isDenied.isDenied && isDeniedMicrophone.isDenied ||
          isDenied.isPermanentlyDenied &&
              isDeniedMicrophone.isPermanentlyDenied) {
        RMSWidgets.getToast(
            message:
            'Camera and Audio access permissions are denied.Please enable it from settings.',
            color: Color(0xffF40909));
        await cameraAndMicrophonePermissionDialog(
            photoPermission: false,
            microphonePermission: false,
            context: context);
      } else if (isDenied.isGranted &&
          (isDeniedMicrophone.isDenied ||
              isDeniedMicrophone.isPermanentlyDenied)) {
        RMSWidgets.getToast(
            message:
            'Audio access permissions are denied.Please enable it from settings.',
            color: Color(0xffF40909));
        await cameraAndMicrophonePermissionDialog(
            photoPermission: true,
            microphonePermission: false,
            context: context);
      } else if ((isDenied.isDenied || isDenied.isPermanentlyDenied) &&
          (isDeniedMicrophone.isGranted)) {
        RMSWidgets.getToast(
            message:
            'Camera access permissions are denied.Please enable it from settings.',
            color: Color(0xffF40909));
        await cameraAndMicrophonePermissionDialog(
            photoPermission: false,
            microphonePermission: true,
            context: context);
      } else if (isDenied.isGranted && isDeniedMicrophone.isGranted) {
        WidgetsFlutterBinding.ensureInitialized();

        // Obtain a list of the available cameras on the device.
        final cameras = await availableCameras();

        // Get a specific camera from the list of available cameras.
        final firstCamera = cameras.first;

        String filePath = (await Navigator.of(context)
            .pushNamed(AppRoutes.pictureScreenPage, arguments: firstCamera))
            .toString();

        if (filePath != null && filePath.toString().length > 5) {
         /* RMSWidgets.showLoaderDialog(
              context: context, message: "Uploading");
          dynamic response = await function(filePath);
          Navigator.of(context).pop();*/

          return filePath;
        } else {
          return null;
        }
      }
    } else if (Platform.isIOS) {
      PermissionStatus isDenied = await Permission.camera.request();
      PermissionStatus isDeniedMicrophone =
      await Permission.microphone.request();

      if (isDenied.isDenied && isDeniedMicrophone.isDenied ||
          isDenied.isPermanentlyDenied &&
              isDeniedMicrophone.isPermanentlyDenied) {
        RMSWidgets.getToast(
            message:
            'Camera and Audio access permissions are denied.Please enable it from settings.',
            color: Color(0xffF40909));
        await cameraAndMicrophonePermissionDialog(
            photoPermission: false,
            microphonePermission: false,
            context: context);
      } else if (isDenied.isGranted &&
          (isDeniedMicrophone.isDenied ||
              isDeniedMicrophone.isPermanentlyDenied)) {
        RMSWidgets.getToast(
            message:
            'Audio access permissions are denied.Please enable it from settings.',
            color: Color(0xffF40909));
        await cameraAndMicrophonePermissionDialog(
            photoPermission: true,
            microphonePermission: false,
            context: context);
      } else if ((isDenied.isDenied || isDenied.isPermanentlyDenied) &&
          (isDeniedMicrophone.isGranted)) {
        RMSWidgets.getToast(
            message:
            'Camera access permissions are denied.Please enable it from settings.',
            color: Color(0xffF40909));
        await cameraAndMicrophonePermissionDialog(
            photoPermission: false,
            microphonePermission: true,
            context: context);
      } else if (isDenied.isGranted && isDeniedMicrophone.isGranted) {
        WidgetsFlutterBinding.ensureInitialized();

        // Obtain a list of the available cameras on the device.
        final cameras = await availableCameras();

        // Get a specific camera from the list of available cameras.
        final firstCamera = cameras.first;

        String filePath = (await Navigator.of(context)
            .pushNamed(AppRoutes.pictureScreenPage, arguments: firstCamera))
            .toString();

        if (filePath != null && filePath.toString().length > 5) {
          // RMSWidgets.showLoaderDialog(context: context, message: "Uploading");
          // dynamic response = await function(filePath);
          // Navigator.of(context).pop();

          return filePath;
        } else {
          return null;
        }
      }

    }
  }

  static Future cameraAndMicrophonePermissionDialog(
      {required bool photoPermission,
        required bool microphonePermission,
        required BuildContext context}) async {
    return Platform.isAndroid
        ? await showDialog(
        context: context,

        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Text(photoPermission == false &&
              microphonePermission == false
              ? 'Camera & Microphone Permission'
              : photoPermission == false && microphonePermission == true
              ? 'Camera Permission'
              : 'Microphone Permission'),
          content: Text(photoPermission == false &&
              microphonePermission == false
              ? 'This app needs Camera and audio Permission to Capture Photos.'
              : photoPermission == false && microphonePermission == true
              ? 'This app needs Camera Permission to Capture Photos.'
              : 'This app needs Microphone Permission to Capture Photos.'),
          actions: <Widget>[
            TextButton(
              child: Text('Deny'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Settings'),
              onPressed: () async {
                bool isSettingOpened = await openAppSettings();
                if (isSettingOpened) Navigator.of(context).pop();
                //Navigator.of(context).pop();
              },
            ),
          ],
        ))
        : await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(photoPermission == false &&
              microphonePermission == false
              ? 'Camera & Microphone Permission'
              : photoPermission == false && microphonePermission == true
              ? 'Camera Permission'
              : 'Microphone Permission'),
          content: Text(photoPermission == false &&
              microphonePermission == false
              ? 'This app needs Camera and audio Permission to Capture Photos.'
              : photoPermission == false && microphonePermission == true
              ? 'This app needs Camera Permission to Capture Photos.'
              : 'This app needs Microphone Permission to Capture Photos.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Deny'),
              onPressed: () {
                Navigator.of(context).pop();
                //  Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Settings'),
              onPressed: () async {
                bool isSettingOpened = await openAppSettings();
                if (isSettingOpened) Navigator.of(context).pop();
                //  Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

  static Future storagePermissionDialog({required BuildContext context}) async {
    return Platform.isAndroid
        ? await showDialog(
        barrierDismissible:false ,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Files and Media Permission'),
          content: const Text(
              'This app needs Files and Media Permission to access Photos.'),
          actions: <Widget>[
            TextButton(
              child: Text('Deny'),
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Settings'),
              onPressed: () async {
                bool isSettingOpened = await openAppSettings();
                if (isSettingOpened) Navigator.of(context).pop();
                //  Navigator.of(context).pop();
              },
            ),
          ],
        ))
        : await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('Files and Media Permission'),
          content: Text(
              'This app needs Files and Media Permission to access Photos.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Deny'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Settings'),
              onPressed: () async {
                bool isSettingOpened = await openAppSettings();
                if (isSettingOpened) Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}