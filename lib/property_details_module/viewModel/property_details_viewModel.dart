import 'package:RentMyStay_user/property_details_module/model/booking_amount_request_model.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_amounts_response_model.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_credential_response_model.dart';
import 'package:RentMyStay_user/property_details_module/model/property_details_model.dart';
import 'package:RentMyStay_user/property_details_module/service/property_details_api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PropertyDetailsViewModel extends ChangeNotifier {
  final PropertyDetailsApiService _detailsApiService =
      PropertyDetailsApiService();
  BookingAmountsResponseModel? bookingAmountsResponseModel;

  PropertyDetailsModel? propertyDetailsModel;
  List<String> amentiesKeyList = [];

  YoutubePlayerController youTubeController = YoutubePlayerController(
    initialVideoId: '',
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: false,
      controlsVisibleAtStart: false,
    ),
  );

  Future<void> getPropertyDetails({required String propId}) async {
    final response =
        await _detailsApiService.fetchPropertyDetails(propId: propId);
    propertyDetailsModel = response;

    if (propertyDetailsModel != null &&
        propertyDetailsModel?.amenitiesNew != null) {
      getAmentiesKeyList(propertyDetailsModel?.amenitiesNew);
    }

    if (propertyDetailsModel != null &&
        propertyDetailsModel?.details != null &&
        propertyDetailsModel?.details?.videoLink != null) {
      youTubeController = YoutubePlayerController(
        initialVideoId: (propertyDetailsModel?.details?.videoLink).toString(),
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          controlsVisibleAtStart: false,
        ),
      );
    }

    notifyListeners();
  }

  Future<String> scheduleSiteVisit(
      {required Map<String, dynamic> scheduleVisitData}) async {
    return await _detailsApiService.scheduleSiteVisit(data: scheduleVisitData);
  }

  Future<void> getBookingDetails(
      {required BookingAmountRequestModel model}) async {
    final response = await _detailsApiService.fetchBookingAmounts(model: model);
    bookingAmountsResponseModel = response;
    notifyListeners();
  }

  Future<BookingCredentialResponseModel> getBookingCredentials(
      {required BookingAmountRequestModel model}) async {
    return await _detailsApiService.fetchBookingCredentials(model: model);
  }

  Future<dynamic> submitPaymentResponse(
      {required String paymentId,
      required String paymentSignature,
      required String redirectApi}) async {
    return await _detailsApiService.submitPaymentResponse(
        paymentId: paymentId,
        paymentSignature: paymentSignature,
        redirectApi: redirectApi);
  }

  List<String> getAmentiesKeyList(AmenitiesNew? amenitiesNew) {
    return [];
  }
}
