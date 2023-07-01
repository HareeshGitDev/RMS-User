import 'dart:developer';
import 'dart:io';

import 'package:RentMyStay_user/my_stays/model/Invoice_Details_Model.dart';
import 'package:RentMyStay_user/my_stays/model/invoice_payment_model.dart';
import 'package:RentMyStay_user/my_stays/model/my_bank_details_model.dart';
import 'package:RentMyStay_user/my_stays/model/mystay_details_model.dart';
import 'package:RentMyStay_user/my_stays/model/refund_splitup_model.dart';
import 'package:RentMyStay_user/my_stays/model/ticket_response_model.dart';
import 'package:flutter/cupertino.dart';

import '../../language_module/model/language_model.dart';
import '../../language_module/service/language_api_service.dart';
import '../../property_details_module/model/booking_amount_request_model.dart';
import '../model/mystay_list_model.dart';
import '../service/mystay_api_service.dart';

class MyStayViewModel extends ChangeNotifier {
  final MyStayApiService _myStayApiService = MyStayApiService();
  MyStayListModel myStayListModel = MyStayListModel();
  List<Result>? activeBookingList;
  List<Result>? completedBookingList;
  MyStayDetailsModel? myStayDetailsModel;
  RefundSplitUpModel? refundSplitUpModel;
  InvoiceDetailsModel? invoiceDetailsModel;
  TicketResponseModel? ticketResponseModel;
  final LanguageApiService _languageApiService = LanguageApiService();
  List<LanguageModel> myStayLang = [];
  List<LanguageModel> bookingDetailsLang = [];
  List<LanguageModel> invoiceLang = [];
  List<LanguageModel> refundSplitUpLang = [];
  List<LanguageModel> feedBackLang = [];
  List<LanguageModel> ticketLang = [];
  MyBankDetailsModel myBankDetailsModel =MyBankDetailsModel();
  Future<void> getMyStayList({ required BuildContext context,}) async {
    final MyStayListModel response = await _myStayApiService.fetchMyStayList(context: context);
    myStayListModel = response;
    activeBookingList=response.data != null && response.data?.result != null && response.data?.result!.length != 0?response.data?.result:[];
    /*log('Total Stay List :: ${myStayListModel.data?.result?.length}');
    if (myStayListModel.data != null && myStayListModel.data?.result != null) {
      completedBookingList = myStayListModel.data?.result
              ?.where((element) => element.checkOutStatus == '1' || element.bookingStatus=='Cancel' )
              .toList() ??
          [];
      log('Completed Stay List :: ${completedBookingList?.length}');

      activeBookingList = myStayListModel.data?.result
              ?.where((element) =>
                  element.checkOutStatus == '0' && element.earlyCout == null && element.bookingStatus !='Cancel' && element.bookingStatus !='Processing' && element.bookingStatus !='Failed')
              .toList() ??
          [];
      log('Active Stay List :: ${activeBookingList?.length}');
    }*/

    notifyListeners();
  }

  Future<void> getMyBankDetails({required String bookingId, required BuildContext context,}) async {
    final MyBankDetailsModel response =
    await _myStayApiService.fetchMyBankDetails(bookingId: bookingId,context: context);
    myBankDetailsModel = response;
    notifyListeners();
  }

  Future<void> getMyStayDetails({required String bookingId, required BuildContext context,}) async {
    final MyStayDetailsModel response =
    await _myStayApiService.fetchMyStayDetails(bookingId: bookingId,context: context);
    myStayDetailsModel = response;
    notifyListeners();
  }

  Future<void> getRefundSplitUpDetails({required String bookingId, required BuildContext context,}) async {
    final RefundSplitUpModel response =
    await _myStayApiService.fetchRefundSplitUpDetails(bookingId: bookingId,context: context);
    refundSplitUpModel = response;
    notifyListeners();
  }

  Future<void> getInvoiceDetails({ required BuildContext context,required String bookingId}) async {
    final InvoiceDetailsModel response =
    await _myStayApiService.fetchInvoiceDetails(bookingId: bookingId,context: context);
    invoiceDetailsModel = response;
    notifyListeners();
  }

  Future<int> submitFeedbackAndBankDetails(
      {required String bookingId,
        required String email,
        required String ratings,
        required String account_number,
        required String account_name,
        required String ifsc_code,
        required String bank_name,
        //required String buildingRatings,
        required BuildContext context,
        required String suggestions,
        //required String friendRecommendation,
        required String friendRecommendRatings,
        required String source}) async {
    final int response = await _myStayApiService.submitFeedbackAndBankDetails(
      context: context,
      bookingId: bookingId,
      email: email,
      ratings: ratings,

      //buildingRatings: buildingRatings,
      friendRecommendRatings: friendRecommendRatings,
      suggestions: suggestions,
      /*friendRecommendation: friendRecommendation,*/ bank_name: bank_name, account_number: account_number, account_name: account_name, ifsc_code: ifsc_code, source:source,


    );
    return response;
  }

  Future<int> checkInAndCheckOut(
      {required String bookingId, required BuildContext context, required bool checkIn}) async {
    final int response = await _myStayApiService.checkInAndCheckOut(
        context: context,
        bookingId: bookingId, checkIn: checkIn);
    return response;
  }

  Future<void> getTicketList({ required BuildContext context,}) async {
    final response = await _myStayApiService.fetchTicketList(context: context);
    ticketResponseModel = response;
    notifyListeners();
  }

  Future<int> updateTicketStatus(
      {required String status, required BuildContext context, required String ticketId}) async =>
      await _myStayApiService.updateTicketStatus(
          status: status, ticketId: ticketId);

  Future<void> uploadImage({
    required String filePath,
    required BuildContext context,
  }) async {
    final response = await _myStayApiService.fetchTicketList(context: context);
    ticketResponseModel = response;
    notifyListeners();
  }

  Future<int> generateTicket(
      {required String bookingId,
        required String requirements,
        required String propertyId,
        required String description,
        required String address,
        List<File>? imageList}) async {
    return await _myStayApiService.generateTicket(
      bookingId: bookingId,
      requirements: requirements,
      propertyId: propertyId,
      description: description,
      address: address,
      imageList: imageList,
    );
  }

  Future<String> downloadInvoice({
    required String bookingId,
    required String invoiceId,
    required BuildContext context,
  }) async {
    return await _myStayApiService.downloadInvoice(
        context: context,
        bookingId: bookingId, invoiceId: invoiceId);
  }

  Future<InvoicePaymentModel> fetchInvoicePaymentCredentials(
      {required BookingAmountRequestModel model, required BuildContext context,}) async {
    return await _myStayApiService.fetchInvoicePaymentCredentials(model: model,context: context);
  }

  Future<int> updateInvoiceUTRPayment({
    required String invoiceId,
    required String utrNumber,
    required BuildContext context,
    required String bookingId,
  }) async =>
      await _myStayApiService.updateInvoiceUTRPayment(
          context: context,
          invoiceId: invoiceId, utrNumber: utrNumber, bookingId: bookingId);

  Future<void> getLanguagesData(
      {required String language, required String pageName}) async {
    final response = await _languageApiService.fetchLanguagesData(
        language: language, pageName: pageName);

    if (pageName == 'MyStays') {
      myStayLang = response;
    } else if (pageName == 'BookingDetails') {
      bookingDetailsLang = response;
    } else if (pageName == 'FeedbackForm') {
      feedBackLang = response;
    } else if (pageName == 'Invoices') {
      invoiceLang = response;
    } else if (pageName == 'Refundsplitup') {
      refundSplitUpLang = response;
    }else if (pageName == 'ticketPage') {
      ticketLang = response;
    }

    notifyListeners();
  }
}
