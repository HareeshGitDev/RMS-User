import 'dart:convert';
import 'dart:developer';

import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtil {


  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    log('From Shared Preferences :: ${prefs.getString(key)}');
    return prefs.getString(key);
  }
  Future<bool> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    log('$key $value');
    return prefs.setString(key, value);
  }
  Future<bool> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key, value);
  }
  Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  Future<String?> getToken() async {
    String? registeredToken = await getString(rms_registeredUserToken);
    if (registeredToken != null && registeredToken.length > 4) {
      return registeredToken;
    }
    return null;
  }

  Future<bool?> setStringWithKeyValue(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  Future<Set<String>> getAllKeys() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys();
  }

  Future<bool?> removeKeyValuePair(String input) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(input);
  }

  Future<bool> clearAll() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.clear();
  }
}
