import 'dart:developer';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class SystemService {
  static Future<void> launchGoogleMaps(
      {required String latitude, required String longitude}) async {
    if (Platform.isAndroid) {
      String url =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      if (await canLaunch(url)) {
        log('Google Map can be launched');
        launch(url);
      }
    } else if (Platform.isIOS) {
      //String url = 'comgooglemaps://?saddr=&daddr=$latitude,$longitude&directionsmode=driving';
      String url = 'https://www.maps.apple.com/?q=$latitude,$longitude';
      if (await canLaunch(url)) {
        log('Apple Map can be launched');
        launch(url);
      }
    }
  }
}
