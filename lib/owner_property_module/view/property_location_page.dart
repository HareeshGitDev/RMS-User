import 'dart:developer';

import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/utils/model/current_location_model.dart';
import 'package:RentMyStay_user/utils/view/google_map_page.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../theme/custom_theme.dart';
import '../../utils/service/location_service.dart';
import '../../utils/service/navigation_service.dart';
import '../model/owner_property_details_request_model.dart';
import '../viewModel/owner_property_viewModel.dart';

class PropertyLocationPage extends StatefulWidget {
  final String propId;
  String? propertyLocation;
  final bool fromPropertyDetails;
  String? latitude;
  String? longitude;

  PropertyLocationPage(
      {Key? key,
      required this.propId,
      required this.fromPropertyDetails,
      this.propertyLocation,
      this.latitude,
      this.longitude})
      : super(key: key);

  @override
  State<PropertyLocationPage> createState() => _PropertyLocationPageState();
}

class _PropertyLocationPageState extends State<PropertyLocationPage> {
  late OwnerPropertyViewModel _viewModel;
  var _mainHeight;
  var _mainWidth;
  bool editable = false;
  final _addressController = TextEditingController();
  CurrentLocationModel currentLocation = CurrentLocationModel();

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<OwnerPropertyViewModel>(context, listen: false);
    _addressController.text = widget.propertyLocation ?? '';
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Text('Property Location'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          height: _mainHeight,
          width: _mainWidth,
          color: Colors.white,
          padding: EdgeInsets.only(
              left: _mainWidth * 0.04,
              right: _mainWidth * 0.04,
              top: _mainHeight * 0.02,
              bottom: _mainHeight * 0.02),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Enter Your Property Location',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black),
                ),
                SizedBox(
                  height: _mainHeight * 0.02,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  height: _mainHeight * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: -2,
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      maxLines: 4,
                      controller: _addressController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10, top: 10),
                        border: InputBorder.none,
                        hintText: "Property Location",
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: _mainHeight * 0.1,
                ),
                const Text(
                  'Select Property Location on Map',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black),
                ),
                GestureDetector(
                  onTap: () async {
                    var locationDetails = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ChangeNotifierProvider<OwnerPropertyViewModel>(
                          child: GoogleMapPage(
                            longitude: widget.longitude,
                            latitude: widget.latitude,
                          ),
                          create: (BuildContext context) =>
                              OwnerPropertyViewModel(),
                        ),
                      ),
                    ) as CurrentLocationModel?;
                    if (locationDetails != null &&
                        locationDetails.fullAddress != null) {
                      currentLocation = locationDetails;
                      _addressController.text =
                          currentLocation.fullAddress.toString();
                    }
                  },
                  child: Container(
                      // alignment: Alignment.topCenter,
                      height: _mainHeight * 0.15,
                      width: _mainWidth * 0.7,
                      child: Image.asset(
                        Images.googleMapImage,
                        fit: BoxFit.cover,
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
            left: _mainWidth * 0.04,
            right: _mainWidth * 0.04,
            bottom: _mainHeight * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: _mainHeight * 0.05,
              width: _mainWidth * 0.4,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        CustomTheme.appThemeContrast),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    )),
                child: Text('Current Location'),
                onPressed: () async {
                  RMSWidgets.showLoaderDialog(
                      context: context, message: 'Loading');
                  currentLocation =
                      await LocationService.getCurrentPlace(context: context);
                  Navigator.of(context).pop();
                  if (currentLocation.fullAddress != null) {
                    _addressController.text =
                        currentLocation.fullAddress.toString();
                  }
                },
              ),
            ),
            Container(
              height: _mainHeight * 0.05,
              width: _mainWidth * 0.4,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(CustomTheme.appTheme),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    )),
                child: const Text('Save'),
                onPressed: () async {
                  if ((currentLocation.fullAddress != null &&
                          currentLocation.fullAddress!.isNotEmpty) ||
                      _addressController.text.isNotEmpty) {
                    OwnerPropertyDetailsRequestModel model =
                        OwnerPropertyDetailsRequestModel();
                    model.city = currentLocation.city;
                    model.state = currentLocation.state;
                    model.zipCode = currentLocation.zipCode;
                    model.country = currentLocation.country;
                    model.addressDisplay =
                        currentLocation.fullAddress ?? _addressController.text;
                    model.glat = currentLocation.latitude;
                    model.glng = currentLocation.longitude;

                    model.propId = widget.propId;
                    RMSWidgets.showLoaderDialog(
                        context: context, message: 'Loading');
                    int data = await _viewModel.updatePropertyDetails(
                        requestModel: model);
                    Navigator.of(context).pop();
                    if (data == 200) {
                      widget.fromPropertyDetails
                          ? Navigator.of(context).pop()
                          : Navigator.of(context).popAndPushNamed(
                              AppRoutes.editPropertyPhotosPage,
                              arguments: {
                                  'fromPropertyDetails': false,
                                  'propId': widget.propId,
                                });
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
