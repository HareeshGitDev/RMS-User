import 'dart:developer';

import 'package:flutter/cupertino.dart';

class BottomNavigationProvider extends ChangeNotifier{

  int selectedIndex=0;

  void  shiftBottom({required int index}){
    selectedIndex=index;
    log('Selected Index $selectedIndex');
    notifyListeners();
  }

}