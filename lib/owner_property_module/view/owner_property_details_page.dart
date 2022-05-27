import 'dart:developer';

import 'package:RentMyStay_user/owner_property_module/model/owner_property_details_model.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../property_details_module/amenities_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/app_consts.dart';
import '../../utils/service/navigation_service.dart';
import '../../webView_page.dart';
import '../viewModel/owner_property_viewModel.dart';

class OwnerPropertyDetailsPage extends StatefulWidget {
  final String propId;

  const OwnerPropertyDetailsPage({Key? key, required this.propId})
      : super(key: key);

  @override
  State<OwnerPropertyDetailsPage> createState() =>
      _OwnerPropertyDetailsPageState();
}

class _OwnerPropertyDetailsPageState extends State<OwnerPropertyDetailsPage> {
  late OwnerPropertyViewModel _viewModel;
  var _mainHeight;
  var _mainWidth;
  bool showEditButton = false;
  bool dailyFlag = false;
  bool monthlyFlag = false;
  bool moreThanThreeFlag = true;
  bool showAllAmenities = false;
  ValueNotifier<bool> showPics = ValueNotifier(true);
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<OwnerPropertyViewModel>(context, listen: false);
    _viewModel.getOwnerPropertyDetails(propId: widget.propId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Consumer<OwnerPropertyViewModel>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            titleSpacing: 0,
            title: Text('Edit Your Property'),
          ),
          body: value.ownerPropertyDetailsModel.msg != null &&
                  value.ownerPropertyDetailsModel.data != null &&
                  value.ownerPropertyDetailsModel.data?.propDetails != null
              ? Container(
                  height: _mainHeight,
                  width: _mainWidth,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder(
                          builder: (context, bool data, child) {
                            return GestureDetector(
                              onTap: () {},
                              child: Stack(
                                children: [
                                  Visibility(
                                    visible: data,
                                    replacement: YoutubePlayerBuilder(
                                      onEnterFullScreen: () {
                                        log('FullScreen');
                                      },
                                      player: YoutubePlayer(
                                        aspectRatio: 1.2,
                                        controller: value.youTubeController,
                                        showVideoProgressIndicator: true,
                                        topActions: const [
                                          Text(
                                            'Powered by RMS',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      builder: (BuildContext context,
                                          Widget player) {
                                        return player;
                                      },
                                    ),
                                    child: CarouselSlider(

                                      items:value.ownerPropertyDetailsModel.data?.photos?.map((e) => CachedNetworkImage(
                                                imageUrl: e.picWp ??'https://e6.pngbyte.com/pngpicture/73762/png-home-icon-png-Home-Button-With-Transparent-Background.png',
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10)),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    Shimmer.fromColors(
                                                        child: Container(
                                                          height:
                                                              _mainHeight * 0.3,
                                                          color: Colors.grey,
                                                        ),
                                                        baseColor: Colors
                                                            .grey[200] as Color,
                                                        highlightColor:
                                                            Colors.grey[350]
                                                                as Color),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ))
                                          .toList(),
                                      options: CarouselOptions(
                                          height: _mainHeight * 0.3,
                                          enlargeCenterPage: false,
                                          autoPlayInterval:
                                              const Duration(seconds: 4),
                                          autoPlay: true,
                                          aspectRatio: 16 / 9,
                                          autoPlayCurve: Curves.decelerate,
                                          enableInfiniteScroll: true,
                                          viewportFraction: 1),
                                    ),
                                  ),
                                  Visibility(
                                    visible: showEditButton,
                                    child: Positioned(
                                      right: _mainWidth * 0.02,
                                      child: IconButton(
                                        onPressed: () {
                                          if (value.ownerPropertyDetailsModel
                                                      .data !=
                                                  null &&
                                              value.ownerPropertyDetailsModel
                                                      .data?.propDetails !=
                                                  null) {
                                            Navigator.of(context).pushNamed(
                                                AppRoutes
                                                    .editPropertyPhotosPage,
                                                arguments: {
                                                  'fromPropertyDetails': true,
                                                  'videoLink': value
                                                          .ownerPropertyDetailsModel
                                                          .data
                                                          ?.propDetails
                                                          ?.videoLink ??
                                                      '',
                                                  'photosList':value.ownerPropertyDetailsModel.data?.photos ?? <Photos>[],
                                                  'propId': value
                                                      .ownerPropertyDetailsModel
                                                      .data
                                                      ?.propDetails
                                                      ?.propId,
                                                }).then((value) {
                                              showEditButton=false;
                                                  _viewModel.getOwnerPropertyDetails(
                                                    propId: widget.propId);
                                                });
                                          }
                                        },
                                        icon: Container(
                                          height: _mainHeight * 0.03,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                CustomTheme.appThemeContrast,
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: _mainHeight * 0.01,
                                    child: IconButton(
                                      onPressed: () {
                                        showPics.value = !showPics.value;
                                        value.youTubeController.reset();
                                      },
                                      icon: Icon(
                                        Icons.play_circle_outline,
                                        color: Colors.white,
                                        size: _mainWidth * 0.08,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          valueListenable: showPics,
                        ),
                        SizedBox(
                          height: _mainHeight * 0.02,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: _mainWidth * 0.03,
                              right: _mainWidth * 0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: _mainWidth * 0.8,
                                child: Text(
                                  value.ownerPropertyDetailsModel.data
                                          ?.propDetails?.title ??
                                      '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    if (value.ownerPropertyDetailsModel.data !=
                                            null &&
                                        value.ownerPropertyDetailsModel.data
                                                ?.propDetails !=
                                            null) {
                                      Navigator.of(context).pushNamed(
                                          AppRoutes.addPropertyPage,
                                          arguments: {
                                            'fromPropertyDetails': true,
                                            'title': value
                                                    .ownerPropertyDetailsModel
                                                    .data
                                                    ?.propDetails
                                                    ?.title ??
                                                '',
                                            'propId': value
                                                .ownerPropertyDetailsModel
                                                .data
                                                ?.propDetails
                                                ?.propId,
                                            'propertyType': value
                                                .ownerPropertyDetailsModel
                                                .data
                                                ?.propDetails
                                                ?.propType
                                          }).then((value) {
                                        showEditButton=false;
                                        _viewModel.getOwnerPropertyDetails(
                                            propId: widget.propId);
                                      });
                                    }
                                  },
                                  child: editButton())
                            ],
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.02,
                        ),
                        _getAmountView(
                            context: context,
                            value: value,
                            model: value
                                .ownerPropertyDetailsModel.data?.propDetails),
                        SizedBox(
                          height: _mainHeight * 0.02,
                        ),
                        Container(
                            padding: EdgeInsets.only(
                                left: _mainWidth * 0.03,
                                right: _mainWidth * 0.03),
                            child: getRoomDetails(value: value)),
                        SizedBox(
                          height: _mainHeight * 0.02,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: _mainWidth * 0.03,
                              right: _mainWidth * 0.03),
                          child: Row(

                            children: [
                              Text(
                                'Available Amenities',
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text( value.availableAmenitiesList.isEmpty?'  (No Amenity)':''),
                              Spacer(),
                              showEditButton
                                  ? GestureDetector(
                                      onTap: () {
                                        if (value.ownerPropertyDetailsModel
                                                    .data !=
                                                null &&
                                            value.ownerPropertyDetailsModel.data
                                                    ?.propDetails !=
                                                null) {
                                          List<AmenitiesModel> list = [];
                                          for (var element
                                              in value.allAmenitiesList) {
                                            list.add(AmenitiesModel(
                                                imageUrl: element.imageUrl,
                                                name: element.name,
                                                selected: element.selected));
                                            if (element.selected) {
                                              log('${element.name} -- ${element.selected}');
                                            }
                                          }
                                          Navigator.of(context).pushNamed(
                                              AppRoutes.amenitiesPage,
                                              arguments: {
                                                'fromPropertyDetails': true,
                                                'propId': value
                                                    .ownerPropertyDetailsModel
                                                    .data
                                                    ?.propDetails
                                                    ?.propId,
                                                'amenitiesList': list,
                                              }).then((value) {
                                            showEditButton=false;
                                            _viewModel.getOwnerPropertyDetails(
                                                propId: widget.propId);
                                          });
                                        }
                                      },
                                      child: editButton())
                                  : Container()
                            ],
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        value.availableAmenitiesList.isNotEmpty?getAvailableAmenities(
                            list: value.availableAmenitiesList):Container(),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        value.availableAmenitiesList.length > 5
                            ? GestureDetector(
                                onTap: () => setState(() {
                                  showAllAmenities = !showAllAmenities;
                                }),
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: _mainWidth * 0.03,
                                  ),
                                  child: Text(
                                    showAllAmenities
                                        ? 'View Less Amenities'
                                        : 'View All Amenities',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CustomTheme.appThemeContrast,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: _mainHeight * 0.03,
                        ),
                        Container(
                            padding: EdgeInsets.only(
                                left: _mainWidth * 0.03,
                                right: _mainWidth * 0.03),
                            child: Row(
                              children: [
                                Text(
                                  'Property Location',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Spacer(),
                                showEditButton
                                    ? GestureDetector(
                                        onTap: () {
                                          if (value.ownerPropertyDetailsModel
                                                      .data !=
                                                  null &&
                                              value.ownerPropertyDetailsModel
                                                      .data?.propDetails !=
                                                  null) {
                                            Navigator.of(context).pushNamed(
                                                AppRoutes.propertyLocationPage,
                                                arguments: {
                                                  'fromPropertyDetails': true,
                                                  'propId': value
                                                      .ownerPropertyDetailsModel
                                                      .data
                                                      ?.propDetails
                                                      ?.propId,
                                                  'latitude': value
                                                      .ownerPropertyDetailsModel
                                                      .data
                                                      ?.propDetails
                                                      ?.glat,
                                                  'longitude': value
                                                      .ownerPropertyDetailsModel
                                                      .data
                                                      ?.propDetails
                                                      ?.glng,
                                                  'propertyLocation': value
                                                      .ownerPropertyDetailsModel
                                                      .data
                                                      ?.propDetails
                                                      ?.addressDisplay,
                                                }).then((value) {
                                              showEditButton=false;
                                              _viewModel.getOwnerPropertyDetails(
                                                  propId: widget.propId);
                                            });
                                          }
                                        },
                                        child: editButton())
                                    : GestureDetector(
                                        onTap: () {
                                          if (value.ownerPropertyDetailsModel
                                                      .data !=
                                                  null &&
                                              value.ownerPropertyDetailsModel
                                                      .data?.propDetails !=
                                                  null) {
                                            Navigator.of(context).pushNamed(
                                                AppRoutes.propertyLocationPage,
                                                arguments: {
                                                  'fromPropertyDetails': true,
                                                  'propId': value
                                                      .ownerPropertyDetailsModel
                                                      .data
                                                      ?.propDetails
                                                      ?.propId,
                                                  'latitude': value
                                                      .ownerPropertyDetailsModel
                                                      .data
                                                      ?.propDetails
                                                      ?.glat,
                                                  'longitude': value
                                                      .ownerPropertyDetailsModel
                                                      .data
                                                      ?.propDetails
                                                      ?.glng,
                                                  'propertyLocation': value
                                                      .ownerPropertyDetailsModel
                                                      .data
                                                      ?.propDetails
                                                      ?.addressDisplay,
                                                }).then((value) {
                                              showEditButton=false;
                                              _viewModel.getOwnerPropertyDetails(
                                                  propId: widget.propId);
                                            });
                                          }
                                        },
                                        child: Text(
                                          'View',
                                          style: TextStyle(
                                              color:
                                                  CustomTheme.appThemeContrast,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                              ],
                            )),
                        SizedBox(
                          height: _mainHeight * 0.02,
                        ),
                        Container(
                            padding: EdgeInsets.only(
                                left: _mainWidth * 0.03,
                                right: _mainWidth * 0.03),
                            child: Row(
                              children: [
                                Text(
                                  'Details',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Spacer(),
                                showEditButton
                                    ? GestureDetector(
                                        onTap: () {
                                          if (value.ownerPropertyDetailsModel
                                                      .data !=
                                                  null &&
                                              value.ownerPropertyDetailsModel
                                                      .data?.propDetails !=
                                                  null) {
                                            Navigator.of(context).pushNamed(
                                                AppRoutes
                                                    .propertyDescriptionPage,
                                                arguments: {
                                                  'fromPropertyDetails': true,
                                                  'propId': value
                                                      .ownerPropertyDetailsModel
                                                      .data
                                                      ?.propDetails
                                                      ?.propId,
                                                  'description': value
                                                      .ownerPropertyDetailsModel
                                                      .data
                                                      ?.propDetails
                                                      ?.description,
                                                }).then((value) {
                                              showEditButton=false;
                                              _viewModel.getOwnerPropertyDetails(
                                                  propId: widget.propId);
                                            });
                                          }
                                        },
                                        child: editButton())
                                    : GestureDetector(
                                        onTap: () {
                                          if (value.ownerPropertyDetailsModel
                                                      .data !=
                                                  null &&
                                              value.ownerPropertyDetailsModel
                                                      .data?.propDetails !=
                                                  null) {
                                            Navigator.of(context).pushNamed(
                                                AppRoutes
                                                    .propertyDescriptionPage,
                                                arguments: {
                                                  'fromPropertyDetails': true,
                                                  'propId': value
                                                      .ownerPropertyDetailsModel
                                                      .data
                                                      ?.propDetails
                                                      ?.propId,
                                                  'description': value
                                                      .ownerPropertyDetailsModel
                                                      .data
                                                      ?.propDetails
                                                      ?.description,
                                                }).then((value) {
                                              showEditButton=false;
                                              _viewModel.getOwnerPropertyDetails(
                                                  propId: widget.propId);
                                            });
                                          }
                                        },
                                        child: Text(
                                          'Read',
                                          style: TextStyle(
                                              color:
                                                  CustomTheme.appThemeContrast,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                              ],
                            )),
                        SizedBox(
                          height: _mainHeight * 0.02,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: _mainWidth * 0.03,
                              right: _mainWidth * 0.03),
                          child: Row(
                            children: [
                              Text(
                                'House Rules',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              Spacer(),
                              showEditButton
                                  ? GestureDetector(
                                      onTap: () {
                                        if (value.ownerPropertyDetailsModel
                                                    .data !=
                                                null &&
                                            value.ownerPropertyDetailsModel.data
                                                    ?.propDetails !=
                                                null) {
                                          Navigator.of(context).pushNamed(
                                              AppRoutes.propertyRulesPage,
                                              arguments: {
                                                'fromPropertyDetails': true,
                                                'propId': value
                                                    .ownerPropertyDetailsModel
                                                    .data
                                                    ?.propDetails
                                                    ?.propId,
                                                'houseRules': value
                                                    .ownerPropertyDetailsModel
                                                    .data
                                                    ?.propDetails
                                                    ?.things2note,
                                              }).then((value) {
                                            showEditButton=false;
                                            _viewModel.getOwnerPropertyDetails(
                                                propId: widget.propId);
                                          });
                                        }
                                      },
                                      child: editButton())
                                  : GestureDetector(
                                      onTap: () {
                                        if (value.ownerPropertyDetailsModel
                                                    .data !=
                                                null &&
                                            value.ownerPropertyDetailsModel.data
                                                    ?.propDetails !=
                                                null) {
                                          Navigator.of(context).pushNamed(
                                              AppRoutes.propertyRulesPage,
                                              arguments: {
                                                'fromPropertyDetails': true,
                                                'propId': value
                                                    .ownerPropertyDetailsModel
                                                    .data
                                                    ?.propDetails
                                                    ?.propId,
                                                'houseRules': value
                                                    .ownerPropertyDetailsModel
                                                    .data
                                                    ?.propDetails
                                                    ?.things2note,
                                              }).then((value) {
                                            showEditButton=false;
                                            _viewModel.getOwnerPropertyDetails(
                                                propId: widget.propId);
                                          });
                                        }
                                      },
                                      child: Text(
                                        'Read',
                                        style: TextStyle(
                                            color: CustomTheme.appThemeContrast,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.02,
                        ),
                        Divider(
                          thickness: 0.7,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: _mainWidth * 0.03,
                              right: _mainWidth * 0.03),
                          child: Row(
                            children: [
                              Text(
                                'FAQ',
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () => _handleURLButtonPress(
                                    context, faqUrl, 'FAQ'),
                                child: Text(
                                  'Read',
                                  style: TextStyle(
                                      color: CustomTheme.appThemeContrast,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 0.7,
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: _mainWidth * 0.03,
                              right: _mainWidth * 0.03),
                          child: Row(
                            children: [
                              Text(
                                'Cancellation Policy',
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () => _handleURLButtonPress(
                                    context,
                                    cancellationPolicyUrl,
                                    'Cancellation Policy'),
                                child: Text(
                                  'Read',
                                  style: TextStyle(
                                      color: CustomTheme.appThemeContrast,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 0.7,
                        ),
                        SizedBox(
                          height: _mainHeight * 0.02,
                        ),
                        const Center(
                          child: Text(
                            'Map View',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.01,
                        ),
                        Container(
                          height: _mainHeight * 0.25,
                          width: _mainWidth,
                          padding: EdgeInsets.only(
                              left: _mainWidth * 0.03,
                              right: _mainWidth * 0.03),
                          child: GoogleMap(
                            myLocationButtonEnabled: false,
                            scrollGesturesEnabled: false,
                            markers: markers,
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    _viewModel.latitude, _viewModel.longitude),
                                zoom: 14),
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.02,
                        ),
                      ],
                    ),
                  ),
                )
              : value.ownerPropertyDetailsModel.msg != null &&
                      value.ownerPropertyDetailsModel.data == null
                  ? RMSWidgets.someError(context: context)
                  : Center(child: RMSWidgets.getLoader()),
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(
                left: _mainWidth * 0.03,
                right: _mainWidth * 0.03,
                bottom: _mainHeight * 0.01),
            child: Row(
              children: [
                Container(
                  height: _mainHeight * 0.05,
                  width: _mainWidth * 0.4,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            CustomTheme.appThemeContrast),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        )),
                    child: Text(showEditButton ? 'Save' : 'Edit'),
                    onPressed: () =>
                        setState(() => showEditButton = !showEditButton),
                  ),
                ),
                Spacer(),
                Container(
                  height: _mainHeight * 0.05,
                  width: _mainWidth * 0.4,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            CustomTheme.appTheme),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        )),
                    child: const Text('Proceed'),
                    onPressed: () =>Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      log('Called For Map');
      markers.add(Marker(
        markerId: MarkerId('id-1'),
        position: LatLng(_viewModel.latitude, _viewModel.longitude),
        infoWindow: InfoWindow(
          title: _viewModel.bName,
        ),
      ));
    });
  }

  Widget getAvailableAmenities({required List<AmenitiesModel> list}) {
    return ListTileTheme.merge(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            mainAxisExtent: _mainHeight * 0.05),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(
              left: _mainWidth * 0.04,
            ),
            child: Row(
              children: [
                Container(
                  height: _mainHeight * 0.03,
                  width: _mainWidth * 0.08,
                  //  padding: EdgeInsets.only(right: _mainWidth * 0.02),
                  child: CachedNetworkImage(
                    imageUrl: list[index].imageUrl,
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
                  width: _mainWidth * 0.03,
                ),
                Text(
                  list[index].name.toString(),
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
          );
        },
        itemCount: showAllAmenities
            ? list.length
            : list.length > 5
                ? 5
                : list.length,
      ),
    );
  }

  Widget getRoomDetails({required OwnerPropertyViewModel value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              Icons.person_outline_outlined,
              size: _mainHeight * 0.03,
              color: Colors.black38,
            ),
            Text(
              value.ownerPropertyDetailsModel.data?.propDetails?.maxGuests !=
                      null
                  ? (value.ownerPropertyDetailsModel.data?.propDetails
                              ?.maxGuests)
                          .toString() +
                      ' Guest'
                  : '0 Guest',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(
          width: _mainWidth * 0.1,
        ),
        Column(
          children: [
            Icon(
              Icons.bed_rounded,
              size: _mainHeight * 0.03,
              color: Colors.black38,
            ),
            Text(
              value.ownerPropertyDetailsModel.data?.propDetails?.bedrooms !=
                      null
                  ? (value.ownerPropertyDetailsModel.data?.propDetails
                              ?.bedrooms)
                          .toString() +
                      ' BedRoom'
                  : ' ',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(
          width: _mainWidth * 0.1,
        ),
        Column(
          children: [
            Icon(
              Icons.bathroom_outlined,
              size: _mainHeight * 0.03,
              color: Colors.black38,
            ),
            Text(
              value.ownerPropertyDetailsModel.data?.propDetails?.bathrooms !=
                      null
                  ? (value.ownerPropertyDetailsModel.data?.propDetails
                              ?.bathrooms)
                          .toString() +
                      ' BathRoom'
                  : ' ',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        showEditButton ? Spacer() : Container(),
        showEditButton
            ? GestureDetector(
                onTap: () {
                  if (value.ownerPropertyDetailsModel.data != null &&
                      value.ownerPropertyDetailsModel.data?.propDetails !=
                          null) {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.propertyRoomsBedsPage, arguments: {
                      'fromPropertyDetails': true,
                      'guestCount': value.ownerPropertyDetailsModel.data
                              ?.propDetails?.maxGuests ??
                          '0',
                      'bathRoomsCount': value.ownerPropertyDetailsModel.data
                              ?.propDetails?.bathrooms ??
                          '0',
                      'bedRoomsCount': value.ownerPropertyDetailsModel.data
                              ?.propDetails?.bedrooms ??
                          '0',
                      'propId': value
                          .ownerPropertyDetailsModel.data?.propDetails?.propId,
                    }).then((value) {
                      showEditButton=false;
                      _viewModel.getOwnerPropertyDetails(
                          propId: widget.propId);
                    });
                  }
                },
                child: editButton())
            : Container()
      ],
    );
  }

  Widget editButton() {
    return Visibility(
      visible: showEditButton,
      child: Container(
        height: _mainHeight * 0.03,
        child: CircleAvatar(
          backgroundColor: CustomTheme.appThemeContrast,
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _getAmountView(
      {required BuildContext context,
      PropDetails? model,
      required OwnerPropertyViewModel value}) {
    return Container(
        decoration: BoxDecoration(
          // color: Colors.amber,
          borderRadius: BorderRadius.circular(5),
        ),

        // height: _mainHeight * 0.17,
        width: _mainWidth,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: _mainWidth * 0.04,
                right: _mainWidth * 0.04,
              ),
              height: _mainHeight * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      if (dailyFlag) {
                        return;
                      } else if (monthlyFlag || moreThanThreeFlag) {
                        setState(() {
                          monthlyFlag = false;
                          moreThanThreeFlag = false;
                          dailyFlag = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: _mainHeight * 0.04,
                      width: _mainWidth * 0.3,
                      decoration: BoxDecoration(
                          color: dailyFlag
                              ? CustomTheme.appTheme
                              : Colors.blueGrey.shade100,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          )),
                      child: Text(
                        'Daily',
                        style: TextStyle(
                            fontSize: 14,
                            color: dailyFlag ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (monthlyFlag) {
                        return;
                      } else if (dailyFlag || moreThanThreeFlag) {
                        setState(() {
                          dailyFlag = false;
                          moreThanThreeFlag = false;
                          monthlyFlag = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: _mainHeight * 0.04,
                      width: _mainWidth * 0.3,
                      color: monthlyFlag
                          ? CustomTheme.appTheme
                          : Colors.blueGrey.shade100,
                      child: Text(
                        'Monthly',
                        style: TextStyle(
                            fontSize: 14,
                            color: monthlyFlag ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (moreThanThreeFlag) {
                        return;
                      } else if (dailyFlag || monthlyFlag) {
                        setState(() {
                          dailyFlag = false;
                          monthlyFlag = false;
                          moreThanThreeFlag = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: _mainHeight * 0.04,
                      width: _mainWidth * 0.3,
                      decoration: BoxDecoration(
                          color: moreThanThreeFlag
                              ? CustomTheme.appTheme
                              : Colors.blueGrey.shade100,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: Text(
                        '3+ Months',
                        style: TextStyle(
                            fontSize: 14,
                            color: moreThanThreeFlag
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            showEditButton
                ? Container()
                : SizedBox(
                    height: _mainHeight * 0.02,
                  ),
            Container(
                padding: EdgeInsets.only(
                  left: _mainWidth * 0.04,
                  right: _mainWidth * 0.04,
                ),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: () {
                      if (value.ownerPropertyDetailsModel.data != null &&
                          value.ownerPropertyDetailsModel.data?.propDetails !=
                              null) {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.propertyRentPage, arguments: {
                          'fromPropertyDetails': true,
                          'dailyRent': value.ownerPropertyDetailsModel.data
                                  ?.propDetails?.rent ??
                              '',
                          'monthlyRent': value.ownerPropertyDetailsModel.data
                                  ?.propDetails?.monthlyRent ??
                              '',
                          'longTermRent': value.ownerPropertyDetailsModel.data
                                  ?.propDetails?.rmsRent ??
                              '',
                          'longTermDeposit': value.ownerPropertyDetailsModel
                                  .data?.propDetails?.rmsDeposit ??
                              '',
                          'propId': value.ownerPropertyDetailsModel.data
                              ?.propDetails?.propId,
                        }).then((value) {
                          showEditButton=false;
                          _viewModel.getOwnerPropertyDetails(
                              propId: widget.propId);
                        });
                      }
                    },
                    child: editButton())),
            Container(
                padding: EdgeInsets.only(
                  left: _mainWidth * 0.04,
                  right: _mainWidth * 0.04,
                ),
                child:
                    _getRentView(context: context, model: model, value: value)),
            SizedBox(
              height: _mainHeight * 0.01,
            ),
          ],
        ));
  }

  Widget _getRentView(
      {required BuildContext context,
      PropDetails? model,
      required OwnerPropertyViewModel value}) {
    if (dailyFlag && (monthlyFlag == false && moreThanThreeFlag == false)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Rent',
            style: const TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          Text(
            model != null && model.rent != null && model.rent.toString() != '0'
                ? '$rupee ${model.rent}'
                : 'Unavailable',
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500),
          ),
        ],
      );
    } else if (monthlyFlag &&
        (dailyFlag == false && moreThanThreeFlag == false)) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rent',
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                model != null &&
                        model.monthlyRent != null &&
                        model.monthlyRent.toString() != '0'
                    ? '$rupee ${model.monthlyRent}'
                    : ' ',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Deposit',
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '$rupee 10000',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rent',
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                model != null &&
                        model.rmsRent != null &&
                        model.rmsRent.toString() != '0'
                    ? '$rupee ${model.rmsRent}'
                    : ' ',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Visibility(
            visible: !dailyFlag,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deposit',
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  model != null &&
                          model.rmsDeposit != null &&
                          model.rmsDeposit.toString() != '0'
                      ? '$rupee ${model.rmsDeposit}'
                      : ' ',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Web_View_Container(url, title)),
    );
  }
}
