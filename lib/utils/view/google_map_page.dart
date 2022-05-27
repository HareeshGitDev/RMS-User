import 'dart:developer';

import 'package:RentMyStay_user/owner_property_module/viewModel/owner_property_viewModel.dart';
import 'package:RentMyStay_user/utils/model/current_location_model.dart';
import 'package:RentMyStay_user/utils/service/location_service.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../theme/custom_theme.dart';

class GoogleMapPage extends StatefulWidget {
  final String? latitude;
  final String? longitude;

  const GoogleMapPage(
      {Key? key, required this.longitude, required this.latitude})
      : super(key: key);

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  MarkerId markerId = MarkerId('1');
  LatLng currentPosition = LatLng(12.967140, 77.736558);
  late GoogleMapController _mapController;
  Set<Marker> markers = {};
  var _mainHeight;
  var _mainWidth;
  bool showSearchResults = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.latitude != null && widget.longitude != null){
      currentPosition = LatLng(double.parse(widget.latitude.toString()),double.parse(widget.latitude.toString()));
    }

  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Set<Marker> _createMarker() {
    //markers.clear();
    markers.add(Marker(
        markerId: markerId,
        icon: BitmapDescriptor.defaultMarker,
        position: currentPosition,
        infoWindow: InfoWindow(title: 'Position'),
        draggable: true,
        onDrag: _onDragEnd));
    return markers;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    // markers.clear();
    setState(() {
      currentPosition = position.target;
      markers.add(Marker(markerId: markerId, position: position.target));
    });
  }

  void _onDragEnd(LatLng position) {
    currentPosition = LatLng(position.latitude, position.longitude);
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: currentPosition, zoom: 18)));
    _createMarker();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Consumer<OwnerPropertyViewModel>(
        builder: (context, value, child) {
          return GestureDetector(
            onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
            child: Container(

              height: _mainHeight,
              width: _mainWidth,
              color: Colors.white,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: currentPosition, zoom: 14),
                    onMapCreated: _onMapCreated,
                    markers: _createMarker(),
                    onCameraMove: _onCameraMove,
                  ),
                  Positioned(
                    top: _mainHeight * 0.12,
                    left: _mainWidth * 0.05,
                    child: showSearchResults
                        ? Container(
                            height: _mainHeight * 0.32,
                            width: _mainWidth * 0.9,
                            child: showSuggestions(value: value))
                        : Container(),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: _mainWidth * 0.04,
                        right: _mainWidth * 0.04,
                        top: _mainHeight * 0.06),
                    height: 45,
                    child: Neumorphic(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      style: NeumorphicStyle(
                        shadowLightColor: CustomTheme.appTheme.withAlpha(150),
                        shadowDarkColor: CustomTheme.appTheme.withAlpha(150),
                        color: Colors.white,
                        lightSource: LightSource.bottom,
                        intensity: 5,
                        depth: 2,
                      ),
                      child: TextFormField(
                        controller: _searchController,
                        onChanged: (text) async {
                          if (text.length < 3) {
                            return;
                          }
                          showSearchResults = true;
                          await value.getSearchedPlace(text);
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                'Search by Locality , Landmark or City',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500),
                            prefixIcon: BackButton(),
                            suffixIcon: _searchController.text.isNotEmpty?IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.black,
                              ),

                              onPressed: () async {
                                FocusScope.of(context).requestFocus(FocusNode());
                                _searchController.clear();

                                setState(() {
                                  showSearchResults = false;
                                });
                              },
                            ):Container(
                              height: 0,
                              width: 0,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Container(

          height: _mainHeight * 0.05,
          width: _mainWidth * 0.4,
          margin: EdgeInsets.only(
              left: _mainWidth * 0.04,
              right: _mainWidth * 0.04,
              bottom: _mainHeight * 0.02),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(CustomTheme.appTheme),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                )),
            child: const Text('Continue'),
            onPressed: ()async {
              RMSWidgets.showLoaderDialog(context: context, message: 'Loading');
              CurrentLocationModel location=await LocationService.getCurrentPlace(lat: currentPosition.latitude,lang: currentPosition.longitude);
              Navigator.of(context).pop();
             Navigator.of(context).pop(location);
            },
          ),
        ),
      ),
    );
  }

  Widget showSuggestions({required OwnerPropertyViewModel value}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.only(top:10),

        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async{

               FocusScope.of(context).requestFocus(FocusNode());
               Map<String,double>? latLng= await value.getAddressByPlaceID(value.locations[index].placeId);

               _searchController.text = value.locations[index].location;
               showSearchResults = false;
               if(latLng !=null){
                 _onDragEnd(LatLng(latLng['lat']!.toDouble(), latLng['lng']!.toDouble()));

               }
              },
              child: Container(
                //color: Colors.cyanAccent,
                padding: EdgeInsets.only(
                  left: _mainWidth * 0.02,
                ),
                height: _mainHeight * 0.045,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: _mainHeight * 0.022,
                      color: CustomTheme.appTheme,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: _mainWidth * 0.8,
                      child: Text(
                        value.locations[index].location,
                        style: TextStyle(
                            fontSize: 14,
                            color: CustomTheme.appTheme,
                            fontWeight: FontWeight.w500),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: value.locations.length,
          separatorBuilder: (context, index) => Divider(
            thickness: 1,
          ),
        ));
  }
}
