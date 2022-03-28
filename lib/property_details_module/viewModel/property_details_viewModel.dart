import 'dart:developer';

import 'package:RentMyStay_user/property_details_module/amenities_model.dart';
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
  List<AmenitiesModel> amenitiesList = [];

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
      getAmenitiesKeyList(propertyDetailsModel?.amenitiesNew)
          .forEach((element) => log(element.toString()));
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
  Future<int> addToWishlist({
    required String propertyId,
  }) async =>
      await _detailsApiService.addToWishList(propertyId: propertyId);

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

  List<AmenitiesModel> getAmenitiesKeyList(AmenitiesNew? amenitiesNew) {
    if (amenitiesNew?.wifi == '1') {
      amenitiesList.add(AmenitiesModel(name: 'WiFi',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.airConditioning == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Air Conditioning',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.balcony == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Balcony',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.bikeParking == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Bike Parking',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.breakfast == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Breakfast',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.bucketsMugs == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Bucket Mugs',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.cableTv == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Cable TV',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.carParking == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Car Parking',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.centerTable == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Center Table',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.clubhouse == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Club House',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.cotMattress == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Cot Mattress',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.curtains == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Curtains',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.dustbin == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Dustbin',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.elevator == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Elevator',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.essentials == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Essentials',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.foodService == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Food Service',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.geysers == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Geysers',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.heating == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Heating',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.housekeeping == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Housekeeping',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.kitchen == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Kitchen',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.security == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Security',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.stoveCylinder == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Stove Cylinder',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.washingMachine == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Washing Machine',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.sofaDeewan == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Sofa Deewan',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.smoking == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Smoking',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.pool == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Pool',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.powerBackup == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Power Backup',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }
    if (amenitiesNew?.refrigerator == '1') {
      amenitiesList.add(AmenitiesModel(name: 'Refrigerator',
          imageUrl:
          'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/hsr.png?alt=media&token=d64fedfc-e2b5-404a-b703-5816046a2d2f'));
    }

    return amenitiesList;
  }
}
