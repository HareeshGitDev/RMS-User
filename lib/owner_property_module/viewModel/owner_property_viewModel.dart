import 'dart:developer';
import 'dart:io';

import 'package:RentMyStay_user/owner_property_module/model/owner_property_details_model.dart';
import 'package:RentMyStay_user/owner_property_module/model/owner_property_details_request_model.dart';
import 'package:RentMyStay_user/owner_property_module/model/owner_property_listing_model.dart';
import 'package:RentMyStay_user/owner_property_module/service/owner_property_api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../property_details_module/amenities_model.dart';
import '../../property_module/model/location_model.dart';
import '../../utils/constants/api_urls.dart';
import '../../utils/constants/app_consts.dart';
import '../../utils/service/rms_user_api_service.dart';

class OwnerPropertyViewModel extends ChangeNotifier {
  final OwnerPropertyApiService _apiService = OwnerPropertyApiService();
  late OwnerPropertyListingModel ownerPropertyListingModel =
      OwnerPropertyListingModel();
  late OwnerPropertyDetailsModel ownerPropertyDetailsModel =
      OwnerPropertyDetailsModel();
  List<AmenitiesModel> availableAmenitiesList = [];
  List<AmenitiesModel> allAmenitiesList = [];
  double latitude = 12.967140;
  double longitude = 77.736558;
  String bName = '';
  List<LocationModel> locations = [];
  YoutubePlayerController youTubeController = YoutubePlayerController(
    initialVideoId: 'w74c6Wnsz8g',
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      mute: true,
      controlsVisibleAtStart: false,
    ),
  );

  void getOwnerPropertyList() async {
    final data = await _apiService.fetchOwnerPropertyList();
    ownerPropertyListingModel = data;
    notifyListeners();
  }

  void getOwnerPropertyDetails({required String propId}) async {
    final data = await _apiService.fetchOwnerPropertyDetails(propId: propId);
    ownerPropertyDetailsModel = data;
    if (ownerPropertyDetailsModel.data != null &&
        ownerPropertyDetailsModel.data?.propDetails != null &&
        ownerPropertyDetailsModel.data?.propDetails?.amenities != null) {
      availableAmenitiesList.clear();
      allAmenitiesList.clear();
      getAvailableAmenitiesList(
          ownerPropertyDetailsModel.data?.propDetails?.amenities?[0]);
      getAllAmenitiesList(
          ownerPropertyDetailsModel.data?.propDetails?.amenities?[0]);
    }
    if (ownerPropertyDetailsModel.data != null &&
        ownerPropertyDetailsModel.data?.propDetails != null &&
        ownerPropertyDetailsModel.data?.propDetails?.glat != null &&
        ownerPropertyDetailsModel.data?.propDetails?.glng != null) {
      latitude =
          double.parse('${ownerPropertyDetailsModel.data?.propDetails?.glat}');
      longitude =
          double.parse('${ownerPropertyDetailsModel.data?.propDetails?.glng}');
      bName = '${ownerPropertyDetailsModel.data?.propDetails?.propertyName}';
    }
    notifyListeners();
  }

  void getAllAmenitiesList(Amenities? amenities) {
    allAmenitiesList = [
      AmenitiesModel(
          selected: amenities?.wifi == '1' ? true : false,
          name: 'WiFi',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Wifi-01.png?alt=media&token=6269ba23-7e0f-4bbe-9fd7-7469e9c6b083'),
      AmenitiesModel(
          selected: amenities?.airConditioning == '1' ? true : false,
          name: 'Air Conditioning',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/air-conditioner.png?alt=media&token=5ecf649a-1bb8-4fb3-ae3d-39475e640a73'),
      AmenitiesModel(
          selected: amenities?.balcony == '1' ? true : false,
          name: 'Balcony',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/balcony-01.png?alt=media&token=dc83c8fe-2563-4ebc-8d37-ee31bd9ec182'),
      AmenitiesModel(
          selected: amenities?.bikeParking == '1' ? true : false,
          name: 'Bike Parking',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Bike-Parking-01.png?alt=media&token=9b9408bf-7f00-464a-8897-570c59a139ef'),
      AmenitiesModel(
          selected: amenities?.breakfast == '1' ? true : false,
          name: 'Breakfast',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/breakfast-01.png?alt=media&token=6aa86d6c-77a4-4b68-8354-b6756d8209af'),
      AmenitiesModel(
          selected: amenities?.bucketsMugs == '1' ? true : false,
          name: 'Bucket Mugs',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/bucket-01.png?alt=media&token=67de579c-dbc7-422f-8840-f956ac59680e'),
      AmenitiesModel(
          selected: amenities?.cableTv == '1' ? true : false,
          name: 'Cable TV',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Cable-Tv.png?alt=media&token=eb60e8db-3baf-4622-95c8-28e30bbef6d9'),
      AmenitiesModel(
          selected: amenities?.carParking == '1' ? true : false,
          name: 'Car Parking',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Car-parking-01.png?alt=media&token=cd6bfcac-e838-4e8d-aa21-73a32f373f5b'),
      AmenitiesModel(
          selected: amenities?.centerTable == '1' ? true : false,
          name: 'Center Table',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/center_table-01.png?alt=media&token=bb30ed03-5a45-4c3e-a333-7e5d6f95c32f'),
      AmenitiesModel(
          selected: amenities?.clubhouse == '1' ? true : false,
          name: 'Club House',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/club%20house.png?alt=media&token=2a5c3004-7854-489c-a302-542397895737'),
      AmenitiesModel(
          selected: amenities?.cotMattress == '1' ? true : false,
          name: 'Cot Mattress',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/cot_mattress-01.png?alt=media&token=591695d6-6be0-4456-86ef-d1252f89536b'),
      AmenitiesModel(
          selected: amenities?.curtains == '1' ? true : false,
          name: 'Curtains',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/curtain-01.png?alt=media&token=5a067a72-be5c-445b-847f-8a95f3a126bb'),
      AmenitiesModel(
          selected: amenities?.dustbin == '1' ? true : false,
          name: 'Dustbin',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/dustbin-01.png?alt=media&token=a07d7082-a6b1-4689-a574-477e02201e6d'),
      AmenitiesModel(
          selected: amenities?.elevator == '1' ? true : false,
          name: 'Elevator',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/elevator-01.png?alt=media&token=02d5f07b-5aea-4a55-b97a-43414e7d4465'),
      AmenitiesModel(
          selected: amenities?.essentials == '1' ? true : false,
          name: 'Essentials',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/essentials-heating-01.png?alt=media&token=82a3f461-75a3-4492-8dfd-15fc32a9eb41'),
      AmenitiesModel(
          selected: amenities?.foodService == '1' ? true : false,
          name: 'Food Service',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/food-service-01.png?alt=media&token=8ff55604-ca4d-42ed-b1aa-b7976a36740d'),
      AmenitiesModel(
          selected: amenities?.geysers == '1' ? true : false,
          name: 'Geysers',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/geysers-01.png?alt=media&token=508e860a-9eda-48f7-8e27-8b2a6602016e'),
      AmenitiesModel(
          selected: amenities?.heating == '1' ? true : false,
          name: 'Heating',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/essentials-heating-01.png?alt=media&token=82a3f461-75a3-4492-8dfd-15fc32a9eb41'),
      AmenitiesModel(
          selected: amenities?.housekeeping == '1' ? true : false,
          name: 'Housekeeping',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/housekeeping-01.png?alt=media&token=d53bd84f-b88c-4162-a06e-9f7c8fef904a'),
      AmenitiesModel(
          selected: amenities?.kitchen == '1' ? true : false,
          name: 'Kitchen',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/kitchen-01.png?alt=media&token=286fb61a-b33b-439b-b527-04b04fe345b3'),
      AmenitiesModel(
          selected: amenities?.security == '1' ? true : false,
          name: 'Security',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/security-01.png?alt=media&token=d7299698-17c6-4238-a408-bb203604c6b9'),
      AmenitiesModel(
          selected: amenities?.stoveCylinder == '1' ? true : false,
          name: 'Stove Cylinder',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/stove_cylinder-01.png?alt=media&token=6836cc7e-0b85-4375-a578-705bf5ffca8e'),
      AmenitiesModel(
          selected: amenities?.washingMachine == '1' ? true : false,
          name: 'Washing Machine',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/washing-machine-01.png?alt=media&token=283dccfe-8a2c-48b9-83fd-f0a738ec81cc'),
      AmenitiesModel(
          selected: amenities?.sofaDeewan == '1' ? true : false,
          name: 'Sofa Deewan',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/sofa-01.png?alt=media&token=320dd081-072a-482a-98c1-1b0987f2dd4d'),
      AmenitiesModel(
          selected: amenities?.smoking == '1' ? true : false,
          name: 'Smoking',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Smooking-01.png?alt=media&token=803753e6-81b0-486c-8529-ae6edd9d4297'),
      AmenitiesModel(
          selected: amenities?.pool == '1' ? true : false,
          name: 'Pool',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Pool-01.png?alt=media&token=3050113e-28bd-441b-9dac-6b2d85232577'),
      AmenitiesModel(
          selected: amenities?.powerBackup == '1' ? true : false,
          name: 'Power Backup',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/power-backup-01.png?alt=media&token=71487acf-17c6-4687-bbe4-9dc6b48f81c1'),
      AmenitiesModel(
          selected: amenities?.refrigerator == '1' ? true : false,
          name: 'Refrigerator',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/refrigerator-01.png?alt=media&token=102cccf8-df60-48ad-b3e7-d8bb6e4b9782'),
    ];
  }

  void getAvailableAmenitiesList(Amenities? amenities) {
    if (amenities?.wifi == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'WiFi',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Wifi-01.png?alt=media&token=6269ba23-7e0f-4bbe-9fd7-7469e9c6b083'),
      );
    }
    if (amenities?.airConditioning == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Air Conditioning',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/air-conditioner.png?alt=media&token=5ecf649a-1bb8-4fb3-ae3d-39475e640a73'),
      );
    }
    if (amenities?.balcony == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
          name: 'Balcony',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/balcony-01.png?alt=media&token=dc83c8fe-2563-4ebc-8d37-ee31bd9ec182',
        ),
      );
    }
    if (amenities?.bikeParking == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Bike Parking',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Bike-Parking-01.png?alt=media&token=9b9408bf-7f00-464a-8897-570c59a139ef'),
      );
    }
    if (amenities?.breakfast == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Breakfast',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/breakfast-01.png?alt=media&token=6aa86d6c-77a4-4b68-8354-b6756d8209af'),
      );
    }
    if (amenities?.bucketsMugs == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Bucket Mugs',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/bucket-01.png?alt=media&token=67de579c-dbc7-422f-8840-f956ac59680e'),
      );
    }
    if (amenities?.cableTv == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Cable TV',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Cable-Tv.png?alt=media&token=eb60e8db-3baf-4622-95c8-28e30bbef6d9'),
      );
    }
    if (amenities?.carParking == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Car Parking',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Car-parking-01.png?alt=media&token=cd6bfcac-e838-4e8d-aa21-73a32f373f5b'),
      );
    }
    if (amenities?.centerTable == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Center Table',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/center_table-01.png?alt=media&token=bb30ed03-5a45-4c3e-a333-7e5d6f95c32f'),
      );
    }
    if (amenities?.clubhouse == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Club House',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/club%20house.png?alt=media&token=2a5c3004-7854-489c-a302-542397895737'),
      );
    }
    if (amenities?.cotMattress == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Cot Mattress',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/cot_mattress-01.png?alt=media&token=591695d6-6be0-4456-86ef-d1252f89536b'),
      );
    }
    if (amenities?.curtains == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Curtains',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/curtain-01.png?alt=media&token=5a067a72-be5c-445b-847f-8a95f3a126bb'),
      );
    }
    if (amenities?.dustbin == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Dustbin',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/dustbin-01.png?alt=media&token=a07d7082-a6b1-4689-a574-477e02201e6d'),
      );
    }
    if (amenities?.elevator == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Elevator',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/elevator-01.png?alt=media&token=02d5f07b-5aea-4a55-b97a-43414e7d4465'),
      );
    }
    if (amenities?.essentials == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Essentials',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/essentials-heating-01.png?alt=media&token=82a3f461-75a3-4492-8dfd-15fc32a9eb41'),
      );
    }
    if (amenities?.foodService == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Food Service',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/food-service-01.png?alt=media&token=8ff55604-ca4d-42ed-b1aa-b7976a36740d'),
      );
    }
    if (amenities?.geysers == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Geysers',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/geysers-01.png?alt=media&token=508e860a-9eda-48f7-8e27-8b2a6602016e'),
      );
    }
    if (amenities?.heating == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Heating',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/essentials-heating-01.png?alt=media&token=82a3f461-75a3-4492-8dfd-15fc32a9eb41'),
      );
    }
    if (amenities?.housekeeping == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Housekeeping',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/housekeeping-01.png?alt=media&token=d53bd84f-b88c-4162-a06e-9f7c8fef904a'),
      );
    }
    if (amenities?.kitchen == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Kitchen',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/kitchen-01.png?alt=media&token=286fb61a-b33b-439b-b527-04b04fe345b3'),
      );
    }
    if (amenities?.security == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Security',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/security-01.png?alt=media&token=d7299698-17c6-4238-a408-bb203604c6b9'),
      );
    }
    if (amenities?.stoveCylinder == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Stove Cylinder',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/stove_cylinder-01.png?alt=media&token=6836cc7e-0b85-4375-a578-705bf5ffca8e'),
      );
    }
    if (amenities?.washingMachine == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Washing Machine',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/washing-machine-01.png?alt=media&token=283dccfe-8a2c-48b9-83fd-f0a738ec81cc'),
      );
    }
    if (amenities?.sofaDeewan == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Sofa Deewan',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/sofa-01.png?alt=media&token=320dd081-072a-482a-98c1-1b0987f2dd4d'),
      );
    }
    if (amenities?.smoking == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Smoking',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Smooking-01.png?alt=media&token=803753e6-81b0-486c-8529-ae6edd9d4297'),
      );
    }
    if (amenities?.pool == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Pool',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/Pool-01.png?alt=media&token=3050113e-28bd-441b-9dac-6b2d85232577'),
      );
    }
    if (amenities?.powerBackup == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Power Backup',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/power-backup-01.png?alt=media&token=71487acf-17c6-4687-bbe4-9dc6b48f81c1'),
      );
    }
    if (amenities?.refrigerator == '1') {
      availableAmenitiesList.add(
        AmenitiesModel(
            name: 'Refrigerator',
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/refrigerator-01.png?alt=media&token=102cccf8-df60-48ad-b3e7-d8bb6e4b9782'),
      );
    }
  }

  Future<String> createProperty({
    required String title,
    required String email,
    required String rent,
    required String propertyType,
    required String roomType,
  }) async =>
      await _apiService.createProperty(
          title: title,
          email: email,
          rent: rent,
          propertyType: propertyType,
          roomType: roomType);

  Future<int> updatePropertyDetails({
    required OwnerPropertyDetailsRequestModel requestModel,
  }) async =>
      await _apiService.updatePropertyDetails(requestModel: requestModel);

  Future<void> getSearchedPlace(String searchText) async {
    RMSUserApiService apiService = RMSUserApiService();

    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchText&types=geocode&key=$googleMapKey&components=country:in';
    final data = await apiService.getApiCallWithURL(endPoint: url)
        as Map<String, dynamic>;

    if (data['status'] == 'OK' && data['predictions'] != null) {
      Iterable iterable = data['predictions'];
      locations = iterable
          .map((suggestion) => LocationModel(
              location: '${suggestion['description']}',
              placeId: '${suggestion['place_id']} '))
          .toList();
      notifyListeners();
    }
  }

  Future<Map<String, double>?> getAddressByPlaceID(String placeId) async {
    RMSUserApiService apiService = RMSUserApiService();
    log('Place ID :: $placeId');
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId.trim()}&fields=geometry&key=$googleMapKey';
    final data = await apiService.getApiCallWithURL(endPoint: url)
        as Map<String, dynamic>;

    if (data['status'] == 'OK' &&
        data['result'] != null &&
        data['result']['geometry'] != null &&
        data['result']['geometry']['location'] != null) {
      return {
        'lat': data['result']['geometry']['location']['lat'],
        'lng': data['result']['geometry']['location']['lng']
      };
    }
    return null;
  }

  Future<int> uploadPropPics(
          {required String propId, required List<File> imageList}) async =>
      await _apiService.uploadPropPics(propId: propId, imageList: imageList);

  Future<int> deletePropPics({
    required String picId,
  }) async =>
      await _apiService.deletePropPics(picId: picId);

  Future<int> hostProperty(
          {required String ownerName,
          required String email,
          required String phone,
          required String address,
          String? comment,
          required String units,
          String? lat,
          String? lang}) async =>
      _apiService.hostProperty(
          ownerName: ownerName,
          email: email,
          phone: phone,
          address: address,
          units: units,
          lang: lang,
          lat: lat,
          comment: comment);
}
