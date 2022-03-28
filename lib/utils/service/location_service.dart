import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final  GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;


  static Future<Position> getCurrentPosition() async {
    final Position position = await _geolocatorPlatform.getCurrentPosition();
    return position;
  }
  static Future<bool> requestLocationPermission()async{
    Geolocator();
   PermissionStatus status= await Permission.location.request();
   return status.isGranted;
  }
}
