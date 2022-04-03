import 'dart:developer';

import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
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

  static Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    return status.isGranted;
  }

  static Future<String> getCurrentPlace() async {
    bool isGranted = await requestLocationPermission();
    if (isGranted) {
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
    return '';
  }
}
