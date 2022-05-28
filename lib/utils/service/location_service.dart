import 'dart:developer';
import 'dart:io';

import 'package:RentMyStay_user/property_module/model/location_model.dart';
import 'package:RentMyStay_user/utils/model/current_location_model.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../theme/custom_theme.dart';
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
    PermissionStatus permissionStatus=await requestInitialLocationPermission();
    log(permissionStatus.toString());
    if (Platform.isAndroid) {
      if (permissionStatus.isGranted) {
        return true;
      } else if (permissionStatus.isDenied) {
        await requestInitialLocationPermission();
      } else if (permissionStatus.isPermanentlyDenied) {
        await locationPermissionDialog(context: context);
      }
    } else if (Platform.isIOS) {
      if (permissionStatus.isGranted) {
        return true;
      } else if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
        await locationPermissionDialog(context: context);
      }
    }

    return null;
  }

  static Future<CurrentLocationModel> getCurrentPlace(
      {double? lat, double? lang, required BuildContext context}) async {
    bool? permission = await checkPermission(context: context);
    if (permission != null && permission) {
      List<Placemark> placeMarks = [];
      CurrentLocationModel locationModel = CurrentLocationModel();
      try {
        Position position = await LocationService.getCurrentPosition();
        await preferenceUtil.setString(
            rms_user_longitude, position.longitude.toString());
        await preferenceUtil.setString(
            rms_user_latitude, position.latitude.toString());
        placeMarks = await placemarkFromCoordinates(
            lat ?? position.latitude, lang ?? position.longitude);
        locationModel.address =
            '${placeMarks[0].subLocality?.replaceAll(' ', '-')}-${placeMarks[0].locality?.replaceAll(' ', '-')}-${placeMarks[0].administrativeArea?.replaceAll(' ', '-')}-${placeMarks[0].country?.replaceAll(' ', '-')}';

        locationModel.fullAddress =
            '${placeMarks[0].name?.replaceAll(' ', '-')},${placeMarks[0].subLocality?.replaceAll(' ', '-')},${placeMarks[0].locality?.replaceAll(' ', '-')},${placeMarks[0].administrativeArea?.replaceAll(' ', '-')},${placeMarks[0].country?.replaceAll(' ', '-')},${placeMarks[0].postalCode?.replaceAll(' ', '-')}';
        locationModel.zipCode =
            '${placeMarks[0].postalCode?.replaceAll(' ', '-')}';
        locationModel.longitude = lang.toString();
        locationModel.latitude = lat.toString();
        locationModel.country =
            '${placeMarks[0].country?.replaceAll(' ', '-')}';
        locationModel.state =
            '${placeMarks[0].administrativeArea?.replaceAll(' ', '-')}';
        locationModel.city = '${placeMarks[0].locality?.replaceAll(' ', '-')}';
      } catch (e) {
        RMSWidgets.getToast(
            message: e.toString(), color: CustomTheme.errorColor);
        log(e.toString());
      }

      return locationModel;
    } else {
      return CurrentLocationModel();
    }
  }

  static Future locationPermissionDialog(
      {required BuildContext context}) async {
    return Platform.isAndroid
        ? await showDialog(
            barrierDismissible: false,
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
