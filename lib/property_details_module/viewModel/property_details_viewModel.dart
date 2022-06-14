import 'dart:developer';

import 'package:RentMyStay_user/property_details_module/amenities_model.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_amount_request_model.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_amounts_response_model.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_credential_response_model.dart';
import 'package:RentMyStay_user/property_details_module/model/property_details_model.dart';
import 'package:RentMyStay_user/property_details_module/service/property_details_api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../language_module/model/language_model.dart';
import '../../language_module/service/language_api_service.dart';

class PropertyDetailsViewModel extends ChangeNotifier {
  final PropertyDetailsApiService _detailsApiService =
      PropertyDetailsApiService();
  BookingAmountsResponseModel? bookingAmountsResponseModel;

  PropertyDetailsModel? propertyDetailsModel;
  List<AmenitiesModel> amenitiesList = [];
  final LanguageApiService _languageApiService = LanguageApiService();
  List<LanguageModel> propertyDetailsLang = [];
  List<LanguageModel> bookingAmountLang = [];

  YoutubePlayerController youTubeController = YoutubePlayerController(

    initialVideoId: '',
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: true,
      controlsVisibleAtStart: false,
    ),
  );

  Future<void> getPropertyDetails({required String propId}) async {
    final response =
        await _detailsApiService.fetchPropertyDetails(propId: propId);
    propertyDetailsModel = response;
    if (propertyDetailsModel != null &&
        propertyDetailsModel?.data != null &&
        propertyDetailsModel?.data?.amenities != null) {
      getAmenitiesList(propertyDetailsModel?.data?.amenities);
    }

    if (propertyDetailsModel != null &&
        propertyDetailsModel?.data != null &&
        propertyDetailsModel?.data?.details != null &&
        propertyDetailsModel?.data?.details?.videoLink != null &&
        propertyDetailsModel?.data?.details?.videoLink?.trim() != ''
    ) {

      youTubeController = YoutubePlayerController(
        initialVideoId:
            (propertyDetailsModel?.data?.details?.videoLink).toString(),
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: true,
          controlsVisibleAtStart: false,
        ),
      );
    }

    notifyListeners();
  }

  Future<int> scheduleSiteVisit(
      {required String email,
      required String propId,
      required String name,
      required String phoneNumber,
      required String date,
      required String visitType}) async {
    return await _detailsApiService.scheduleSiteVisit(
        email: email,
        name: name,
        propId: propId,
        phoneNumber: phoneNumber,
        date: date,
        visitType: visitType);
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

  void getAmenitiesList(Amenities? amenitiesNew) {
    if (amenitiesNew?.wifi == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'WiFi',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Wifi-01.png?alt=media&token=6269ba23-7e0f-4bbe-9fd7-7469e9c6b083'));
    }
    if (amenitiesNew?.airConditioning == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Air Conditioning',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/air-conditioner.png?alt=media&token=5ecf649a-1bb8-4fb3-ae3d-39475e640a73'));
    }
    if (amenitiesNew?.balcony == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Balcony',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/balcony-01.png?alt=media&token=dc83c8fe-2563-4ebc-8d37-ee31bd9ec182'));
    }
    if (amenitiesNew?.bikeParking == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Bike Parking',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Bike-Parking-01.png?alt=media&token=9b9408bf-7f00-464a-8897-570c59a139ef'));
    }
    if (amenitiesNew?.breakfast == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Breakfast',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/breakfast-01.png?alt=media&token=6aa86d6c-77a4-4b68-8354-b6756d8209af'));
    }
    if (amenitiesNew?.bucketsMugs == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Bucket Mugs',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/bucket-01.png?alt=media&token=67de579c-dbc7-422f-8840-f956ac59680e'));
    }
    if (amenitiesNew?.cableTv == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Cable TV',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Cable-Tv.png?alt=media&token=eb60e8db-3baf-4622-95c8-28e30bbef6d9'));
    }
    if (amenitiesNew?.carParking == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Car Parking',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Car-parking-01.png?alt=media&token=cd6bfcac-e838-4e8d-aa21-73a32f373f5b'));
    }
    if (amenitiesNew?.centerTable == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Center Table',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/center_table-01.png?alt=media&token=bb30ed03-5a45-4c3e-a333-7e5d6f95c32f'));
    }
    if (amenitiesNew?.clubhouse == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Club House',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/club%20house.png?alt=media&token=2a5c3004-7854-489c-a302-542397895737'));
    }
    if (amenitiesNew?.cotMattress == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Cot Mattress',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/cot_mattress-01.png?alt=media&token=591695d6-6be0-4456-86ef-d1252f89536b'));
    }
    if (amenitiesNew?.curtains == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Curtains',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/curtain-01.png?alt=media&token=5a067a72-be5c-445b-847f-8a95f3a126bb'));
    }
    if (amenitiesNew?.dustbin == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Dustbin',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/dustbin-01.png?alt=media&token=a07d7082-a6b1-4689-a574-477e02201e6d'));
    }
    if (amenitiesNew?.elevator == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Elevator',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/elevator-01.png?alt=media&token=02d5f07b-5aea-4a55-b97a-43414e7d4465'));
    }
    if (amenitiesNew?.essentials == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Essentials',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/essentials-heating-01.png?alt=media&token=82a3f461-75a3-4492-8dfd-15fc32a9eb41'));
    }
    if (amenitiesNew?.foodService == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Food Service',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/food-service-01.png?alt=media&token=8ff55604-ca4d-42ed-b1aa-b7976a36740d'));
    }
    if (amenitiesNew?.geysers == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Geysers',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/geysers-01.png?alt=media&token=508e860a-9eda-48f7-8e27-8b2a6602016e'));
    }
    if (amenitiesNew?.heating == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Heating',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/essentials-heating-01.png?alt=media&token=82a3f461-75a3-4492-8dfd-15fc32a9eb41'));
    }
    if (amenitiesNew?.housekeeping == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Housekeeping',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/housekeeping-01.png?alt=media&token=d53bd84f-b88c-4162-a06e-9f7c8fef904a'));
    }
    if (amenitiesNew?.kitchen == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Kitchen',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/kitchen-01.png?alt=media&token=286fb61a-b33b-439b-b527-04b04fe345b3'));
    }
    if (amenitiesNew?.security == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Caretaker',
          imageUrl:
              'https://www.rentmystay.com/resource/img/guard.png'));
    }
    if (amenitiesNew?.stoveCylinder == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Stove Cylinder',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/stove_cylinder-01.png?alt=media&token=6836cc7e-0b85-4375-a578-705bf5ffca8e'));
    }
    if (amenitiesNew?.washingMachine == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'WM(Common)',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/washing-machine-01.png?alt=media&token=283dccfe-8a2c-48b9-83fd-f0a738ec81cc'));
    }
    if (amenitiesNew?.sofaDeewan == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Sofa/Deewan',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/sofa-01.png?alt=media&token=320dd081-072a-482a-98c1-1b0987f2dd4d'));
    }
    if (amenitiesNew?.smoking == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Smoking',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Smooking-01.png?alt=media&token=803753e6-81b0-486c-8529-ae6edd9d4297'));
    }
    if (amenitiesNew?.pool == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Pool',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Pool-01.png?alt=media&token=3050113e-28bd-441b-9dac-6b2d85232577'));
    }
    if (amenitiesNew?.powerBackup == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Power Backup',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/power-backup-01.png?alt=media&token=71487acf-17c6-4687-bbe4-9dc6b48f81c1'));
    }
    if (amenitiesNew?.refrigerator == '1') {
      amenitiesList.add(AmenitiesModel(
          name: 'Refrigerator',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/refrigerator-01.png?alt=media&token=102cccf8-df60-48ad-b3e7-d8bb6e4b9782'));
    }
  }
  Future<void> getPropertyDetailsLanguagesData(
      {required String language, required String pageName}) async {
    final response = await _languageApiService.fetchLanguagesData(
        language: language, pageName: pageName);
    propertyDetailsLang = response;
    notifyListeners();
  }
  Future<void> getBookingPageLanguagesData(
      {required String language, required String pageName}) async {
    final response = await _languageApiService.fetchLanguagesData(
        language: language, pageName: pageName);
    bookingAmountLang = response ;
    notifyListeners();
  }
}
