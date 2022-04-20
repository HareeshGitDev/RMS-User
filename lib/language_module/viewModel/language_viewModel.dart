import 'package:flutter/cupertino.dart';

class LanguageViewModel extends ChangeNotifier{

  List<String> getAvailableLanguageList(){
    return [
      'English',
      'Hindi',
    ];
  }


}