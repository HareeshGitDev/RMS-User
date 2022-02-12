import 'dart:convert';

import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {
  getJson(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key).toString());
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool?> setJson(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, json.encode(value));
  }

  static Future<bool> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<String?> getToken() async {
    String? registeredToken = await getString(rms_registeredUserToken);
    if (registeredToken != null && registeredToken.length > 10) {
      return registeredToken;
    }
  }

  static Future<bool?> setStringWithKeyValue(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  getAllKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys();
  }

  Future<bool?> removeKey(String input) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(input);
  }

  clearAll() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
