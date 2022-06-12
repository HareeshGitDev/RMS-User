import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../../utils/view/rms_widgets.dart';
import '../model/owner_property_details_request_model.dart';
import '../viewModel/owner_property_viewModel.dart';

class PropertyRoomsBedsPage extends StatefulWidget {
  final String propId;
  String? guestCount;
  String? bedRoomsCount;
  String? bathRoomsCount;
  final bool fromPropertyDetails;

  PropertyRoomsBedsPage(
      {Key? key,
      required this.propId,
      required this.fromPropertyDetails,
      this.guestCount,
      this.bathRoomsCount,
      this.bedRoomsCount})
      : super(key: key);

  @override
  State<PropertyRoomsBedsPage> createState() => _PropertyRoomsBedsPageState();
}

class _PropertyRoomsBedsPageState extends State<PropertyRoomsBedsPage> {
  late OwnerPropertyViewModel _viewModel;
  var _mainHeight;
  var _mainWidth;
  int guestCount = 0;

  int bedRoomsCount = 0;
  int bathRoomsCount = 0;
  SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();

  getLanguageData() async {
    await _viewModel.getLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'ownerPropertyPage');
  }
  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<OwnerPropertyViewModel>(context, listen: false);
    getLanguageData();
    if (widget.fromPropertyDetails) {
      guestCount = int.parse(widget.guestCount.toString());
      bathRoomsCount = int.parse(widget.bathRoomsCount.toString());
      bedRoomsCount = int.parse(widget.bedRoomsCount.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(nullCheck(
            list: context.watch<OwnerPropertyViewModel>().ownerPropertyLang)
            ? '${context.watch<OwnerPropertyViewModel>().ownerPropertyLang[16].name}'
            :'Rooms & Beds'),
        titleSpacing: 0,
      ),
      body: Consumer<OwnerPropertyViewModel>(
        builder: (context, value, child) {
          return Container(
            padding: EdgeInsets.only(
                left: _mainWidth * 0.03,
                right: _mainWidth * 0.03,
                top: _mainHeight * 0.02,
                bottom: _mainHeight * 0.02),
            height: _mainHeight,
            width: _mainWidth,
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[17].name :'Just a little more about your Apartment...'}',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: _mainHeight * 0.04,
                ),
                Text(
                  '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[18].name :'Max Guests'}',
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomTheme.appThemeContrast,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: _mainHeight * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: _mainHeight * 0.05,
                      width: _mainWidth * 0.1,
                      decoration: BoxDecoration(
                          color: CustomTheme.appTheme,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      child: IconButton(
                        onPressed: () {
                          if (guestCount != 0) {
                            setState(() {
                              guestCount = guestCount - 1;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.arrow_left_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      height: _mainHeight * 0.05,
                      width: _mainWidth * 0.6,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: Text(
                        guestCount.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      height: _mainHeight * 0.05,
                      width: _mainWidth * 0.1,
                      decoration: BoxDecoration(
                          color: CustomTheme.appTheme,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            guestCount = guestCount + 1;
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: _mainHeight * 0.03,
                ),
                Text(
                  '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[19].name :'No. of Bed Rooms'}',
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomTheme.appThemeContrast,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: _mainHeight * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: _mainHeight * 0.05,
                      width: _mainWidth * 0.1,
                      decoration: BoxDecoration(
                          color: CustomTheme.appTheme,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      child: IconButton(
                        onPressed: () {
                          if (bedRoomsCount != 0) {
                            setState(() {
                              bedRoomsCount = bedRoomsCount - 1;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.arrow_left_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      height: _mainHeight * 0.05,
                      width: _mainWidth * 0.6,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: Text(
                        bedRoomsCount.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      height: _mainHeight * 0.05,
                      width: _mainWidth * 0.1,
                      decoration: BoxDecoration(
                          color: CustomTheme.appTheme,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            bedRoomsCount = bedRoomsCount + 1;
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: _mainHeight * 0.03,
                ),
                Text(
                  '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[20].name :'No. of Bath Rooms'}',
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomTheme.appThemeContrast,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: _mainHeight * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: _mainHeight * 0.05,
                      width: _mainWidth * 0.1,
                      decoration: BoxDecoration(
                          color: CustomTheme.appTheme,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      child: IconButton(
                        onPressed: () {
                          if (bathRoomsCount != 0) {
                            setState(() {
                              bathRoomsCount = bathRoomsCount - 1;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.arrow_left_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      height: _mainHeight * 0.05,
                      width: _mainWidth * 0.6,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: Text(
                        bathRoomsCount.toString(),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      height: _mainHeight * 0.05,
                      width: _mainWidth * 0.1,
                      decoration: BoxDecoration(
                          color: CustomTheme.appTheme,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            bathRoomsCount = bathRoomsCount + 1;
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  height: _mainHeight * 0.05,
                  width: _mainWidth,
                  margin: EdgeInsets.only(
                      bottom: _mainHeight * 0.01,
                      left: _mainWidth * 0.03,
                      right: _mainWidth * 0.03),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(CustomTheme.appTheme),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        )),
                    child: Text(nullCheck(
                        list: context.watch<OwnerPropertyViewModel>().ownerPropertyLang)
                        ? '${context.watch<OwnerPropertyViewModel>().ownerPropertyLang[6].name}'
                        :'Save'),
                    onPressed: () async {

                      OwnerPropertyDetailsRequestModel model =
                      OwnerPropertyDetailsRequestModel();
                      model.bedrooms = bedRoomsCount.toString();
                      model.bathrooms = bathRoomsCount.toString();
                      model.maxGuests = guestCount.toString();
                      model.propId = widget.propId;
                      RMSWidgets.showLoaderDialog(
                          context: context, message: 'Loading');
                      int data = await _viewModel.updatePropertyDetails(
                          requestModel: model);
                      Navigator.of(context).pop();
                      if (data == 200) {
                        widget.fromPropertyDetails?Navigator.of(context).pop():Navigator.of(context)
                            .popAndPushNamed(AppRoutes.propertyDescriptionPage, arguments: {
                          'fromPropertyDetails': false,
                          'propId': widget.propId,
                        });;
                      }

                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
