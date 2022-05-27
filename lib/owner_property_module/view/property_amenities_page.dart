import 'dart:developer';

import 'package:RentMyStay_user/property_details_module/amenities_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/custom_theme.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/view/rms_widgets.dart';
import '../model/owner_property_details_request_model.dart';
import '../viewModel/owner_property_viewModel.dart';

class PropertyAmenitiesPage extends StatefulWidget {
  final String propId;
  final List<AmenitiesModel> amenitiesList;
  final bool fromPropertyDetails;

  PropertyAmenitiesPage(
      {Key? key,
      required this.propId,
      required this.fromPropertyDetails,
      required this.amenitiesList})
      : super(key: key);

  @override
  State<PropertyAmenitiesPage> createState() => _PropertyAmenitiesPageState();
}

class _PropertyAmenitiesPageState extends State<PropertyAmenitiesPage> {
  late OwnerPropertyViewModel _viewModel;
  var _mainHeight;
  var _mainWidth;
  List<AmenitiesModel> updatedAmenitiesList = [];

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<OwnerPropertyViewModel>(context, listen: false);
    updatedAmenitiesList = widget.amenitiesList;
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Amenities'),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Container(
        height: _mainHeight,
        width: _mainWidth,
        color: Colors.white,
        padding: EdgeInsets.only(
            left: _mainWidth * 0.04,
            right: _mainWidth * 0.04,
            top: _mainHeight * 0.02,
            bottom: _mainHeight * 0.02),
        child: Column(
          children: [
            const Text(
              'Pick More Amenities',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black),
            ),
            SizedBox(
              height: _mainHeight * 0.02,
            ),
            Container(
              height: _mainHeight * 0.7,
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    var data = updatedAmenitiesList[index];
                    return Row(
                      children: [
                        Container(
                          height: _mainHeight * 0.03,
                          width: _mainWidth * 0.08,
                          //  padding: EdgeInsets.only(right: _mainWidth * 0.02),
                          child: CachedNetworkImage(
                            imageUrl: data.imageUrl,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                //borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Shimmer.fromColors(
                                child: Container(
                                  height: _mainHeight * 0.03,
                                  width: _mainWidth * 0.08,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    // borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                baseColor: Colors.grey[200] as Color,
                                highlightColor: Colors.grey[350] as Color),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: _mainWidth * 0.05,
                        ),
                        Text(
                          data.name.toString(),
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                        Spacer(),
                        Checkbox(
                            activeColor: CustomTheme.appTheme,
                            value: data.selected,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => data.selected = val);
                              }
                            }),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: updatedAmenitiesList.length),
            ),
            Spacer(),
            Container(
              height: _mainHeight * 0.05,
              width: _mainWidth,
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
                  Map<String, dynamic> amenity = {};

                  for (var element in updatedAmenitiesList) {
                    if (element.selected) {
                      amenity[element.name.toLowerCase().replaceAll(' ', '_').toString().trim()] =
                          "1";
                    }
                  }

                  OwnerPropertyDetailsRequestModel model =
                      OwnerPropertyDetailsRequestModel();
                  model.amenity = amenity;
                  model.propId = widget.propId;
                  RMSWidgets.showLoaderDialog(
                      context: context, message: 'Loading');
                  int data = await _viewModel.updatePropertyDetails(
                      requestModel: model);
                  Navigator.of(context).pop();

                  if (data == 200) {
                    widget.fromPropertyDetails
                        ? Navigator.of(context).pop()
                        : Navigator.of(context)
                        .pushNamed(AppRoutes.ownerPropertyDetailsPage, arguments: {
                      'propId':widget.propId,
                    });
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
