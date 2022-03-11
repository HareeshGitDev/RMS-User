import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../model/mystay_list_model.dart';
import '../service/mystay_api_service.dart';

class MyStayViewModel extends ChangeNotifier{
  final MyStayApiService _profileApiService = MyStayApiService();
  MyStayListModel myStayListModel = MyStayListModel();
  List<Result>? activeBookingList;
  List<Result>? completedBookingList;

  Future <void> getMyStayList() async{
    final  MyStayListModel response = await _profileApiService.fetchProfileDetails();
    myStayListModel=response;
    log('Total Stay List :: ${myStayListModel.result?.length}');
    if(myStayListModel.result != null){
      completedBookingList=myStayListModel.result!
          .where((element) => element.checkOutStatus == '1'  )
          .toList();
      log('Completed Stay List :: ${completedBookingList?.length}');

      activeBookingList=myStayListModel.result!
          .where((element) => element.checkOutStatus == '0' && element.earlyCout == null)
          .toList();
      log('Active Stay List :: ${activeBookingList?.length}');
    }

    notifyListeners();
  }
}