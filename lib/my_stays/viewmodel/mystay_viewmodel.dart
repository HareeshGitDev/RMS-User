import 'dart:developer';

import 'package:RentMyStay_user/my_stays/model/mystay_details_model.dart';
import 'package:RentMyStay_user/my_stays/model/refund_splitup_model.dart';
import 'package:flutter/cupertino.dart';

import '../model/mystay_list_model.dart';
import '../service/mystay_api_service.dart';

class MyStayViewModel extends ChangeNotifier {
  final MyStayApiService _profileApiService = MyStayApiService();
  MyStayListModel myStayListModel = MyStayListModel();
  List<Result>? activeBookingList;
  List<Result>? completedBookingList;
  MyStayDetailsModel? myStayDetailsModel;
  RefundSplitUpModel? refundSplitUpModel;

  Future<void> getMyStayList() async {
    final MyStayListModel response = await _profileApiService.fetchMyStayList();
    myStayListModel = response;
    log('Total Stay List :: ${myStayListModel.result?.length}');
    if (myStayListModel.result != null) {
      completedBookingList = myStayListModel.result!
          .where((element) => element.checkOutStatus == '1')
          .toList();
      log('Completed Stay List :: ${completedBookingList?.length}');

      activeBookingList = myStayListModel.result!
          .where((element) =>
              element.checkOutStatus == '0' && element.earlyCout == null)
          .toList();
      log('Active Stay List :: ${activeBookingList?.length}');
    }

    notifyListeners();
  }

  Future<void> getMyStayDetails({required String bookingId}) async {
    final MyStayDetailsModel response =
        await _profileApiService.fetchMyStayDetails(bookingId: bookingId);
    myStayDetailsModel = response;
    notifyListeners();
  }
  Future<void> getRefundSplitUpDetails({required String bookingId}) async {
    final RefundSplitUpModel response =
    await _profileApiService.fetchRefundSplitUpDetails(bookingId: bookingId);
     refundSplitUpModel = response;
    notifyListeners();
  }
}
