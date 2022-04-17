import 'dart:io';

import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/sp_constants.dart';

class LocationService {
  static final GeolocatorPlatform _geolocatorPlatform =
      GeolocatorPlatform.instance;
  static SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();

  static Future<Position> getCurrentPosition() async {
    final Position position = await _geolocatorPlatform.getCurrentPosition();
    return position;
  }

  static Future<PermissionStatus> requestInitialLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    return status;
  }

  static Future<bool?> checkPermission({required BuildContext context}) async {
    await requestInitialLocationPermission();
    PermissionWithService location =Permission.location;
    if (await location.isGranted) {
      return true;
    }else if(await location.isDenied) {
      await locationPermissionDialog(context: context);
    }
    return null;
  }

  static Future<String> getCurrentPlace() async {
    Position position = await LocationService.getCurrentPosition();
    await preferenceUtil.setString(
        rms_user_longitude, position.latitude.toString());
    await preferenceUtil.setString(
        rms_user_latitude, position.latitude.toString());
    List<Placemark> placeMarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    String currentAddress =
        '${placeMarks[0].subLocality?.replaceAll(' ', '-')}-${placeMarks[0].locality?.replaceAll(' ', '-')}-${placeMarks[0].administrativeArea?.replaceAll(' ', '-')}-${placeMarks[0].country?.replaceAll(' ', '-')}';
    return currentAddress;
  }
  static Future locationPermissionDialog({required BuildContext context}) async {
    return Platform.isAndroid
        ? await showDialog(
        barrierDismissible:false ,
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Location Permission'),
          content: const Text(
              'This app needs Location Permission to detect Location.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Deny'),
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Settings'),
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
          title: const Text('Location Permission'),
          content: const Text(
              'This app needs Location Permission to detect Location.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Deny'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Settings'),
              onPressed: () async {
                bool isSettingOpened = await openAppSettings();
                if (isSettingOpened) Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}
