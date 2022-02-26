import 'dart:developer';

import 'package:RentMyStay_user/property_module/model/wish_list_model.dart';
import 'package:RentMyStay_user/property_module/service/property_api_service.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/constants/enum_consts.dart';
import '../model/property_list_model.dart';

class PropertyViewModel extends ChangeNotifier {
  final PropertyApiService _propertyApiService = PropertyApiService();
  PropertyListModel propertyDetailsModel = PropertyListModel();
  WishListModel wishListModel=WishListModel();

  Future<void> getPropertyDetailsList({
    required String address,
    String? propertyType,
    required Property property,
  }) async {
    final PropertyListModel data =
        await _propertyApiService.fetchPropertyDetailsList(
            address: address, property: property, propertyType: propertyType);

    propertyDetailsModel = data;
    log('ALL PROPERTIES :: ${propertyDetailsModel.data?.length}');
    notifyListeners();
  }

  Future<String> addToWishlist({
    required String propertyId,
  }) async =>
      await _propertyApiService.addToWishList(propertyId: propertyId);

  Future<void> getWishList() async {
    final WishListModel data =
    await _propertyApiService.fetchWishList();
    wishListModel = data;
    log('ALL WishListed PROPERTIES :: ${wishListModel.data?.length}');
    notifyListeners();
  }
}
