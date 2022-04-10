import 'dart:developer';
import 'dart:io';

import 'package:RentMyStay_user/utils/service/rms_user_api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SystemService {
  static Future<void> launchGoogleMaps(
      {required String latitude, required String longitude}) async {
    var url = '';
    var urlAppleMaps = '';
    if (Platform.isAndroid) {
      url = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
      if (await canLaunch(url)) {
        await launch(url);
      }
    } else if(Platform.isIOS){
      urlAppleMaps = 'https://maps.apple.com/?q=$latitude,$longitude';
      //url = "comgooglemaps://?saddr=&daddr=$latitude,$longitude&directionsmode=driving";
      // if (await canLaunch(url)) {
      //   await launch(url);
      // } else
       if (await canLaunch(urlAppleMaps)) {
        await launch(urlAppleMaps);
      }else {
        log ('Could not launch $url');
      }
    }
  }


}
