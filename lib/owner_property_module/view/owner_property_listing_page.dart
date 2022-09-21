import 'dart:developer';

import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/owner_property_module/model/owner_property_details_model.dart';
import 'package:RentMyStay_user/owner_property_module/viewModel/owner_property_viewModel.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../language_module/model/language_model.dart';
import '../../property_details_module/amenities_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../../utils/view/rms_widgets.dart';

class OwnerPropertyListingPage extends StatefulWidget {
  const OwnerPropertyListingPage({Key? key}) : super(key: key);

  @override
  State<OwnerPropertyListingPage> createState() =>
      _OwnerPropertyListingPageState();
}

class _OwnerPropertyListingPageState extends State<OwnerPropertyListingPage> {
  late OwnerPropertyViewModel _viewModel;
  var _mainHeight;
  var _mainWidth;
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
    // TODO: implement initState
    super.initState();
    _viewModel = Provider.of<OwnerPropertyViewModel>(context, listen: false);
    _viewModel.getOwnerPropertyList(context: context);
    getLanguageData();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Text(nullCheck(
                list: context.watch<OwnerPropertyViewModel>().ownerPropertyLang)
            ? '${context.watch<OwnerPropertyViewModel>().ownerPropertyLang[39].name}'
            : 'My Properties'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
      ),
      body: Consumer<OwnerPropertyViewModel>(
        builder: (context, value, child) {
          return value.ownerPropertyListingModel.msg != null &&
                  value.ownerPropertyListingModel.data != null &&
                  value.ownerPropertyListingModel.data!.isNotEmpty
              ? Container(
                  height: _mainHeight,
                  width: _mainWidth,
                  color: Colors.white,
                  margin: EdgeInsets.only(
                      left: _mainWidth * 0.03,
                      right: _mainWidth * 0.03,
                      bottom: _mainHeight * 0.01,
                      top: _mainHeight * 0.02),
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        var data = value.ownerPropertyListingModel.data?[index];
                        return GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(
                              AppRoutes.ownerPropertyDetailsPage,
                              arguments: data?.propId),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            color: Colors.white,
                            child: Row(
                              children: [
                                Container(
                                  height: _mainHeight * 0.085,
                                  width: _mainWidth * 0.20,
                                  padding: EdgeInsets.only(
                                      right: _mainWidth * 0.02,
                                      bottom: _mainHeight * 0.005,
                                      left: _mainWidth * 0.02),
                                  child: CachedNetworkImage(
                                    imageUrl: data?.picLink != null &&
                                            data?.picLink!.length != 0
                                        ? data!.picLink![0].picWp.toString()
                                        : '',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                            child: Container(
                                              height: _mainHeight * 0.075,
                                              width: _mainWidth * 0.2,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            baseColor:
                                                Colors.grey[200] as Color,
                                            highlightColor:
                                                Colors.grey[350] as Color),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: _mainWidth * 0.66,
                                        child: Text(
                                          data?.title ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        )),
                                    SizedBox(
                                      height: _mainHeight * 0.005,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: CustomTheme.appTheme,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            // color: Colors.amber,
                                            width: _mainWidth * 0.58,
                                            child: Text(
                                              data?.addressDisplay
                                                      ?.replaceAll('-', ' ')
                                                      .replaceAll(',', ' ') ??
                                                  " ",
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: _mainHeight * 0.005,
                                    ),
                                    Container(
                                      width: _mainWidth * 0.66,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'PropId : ${data?.propId ?? ''}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            data?.active == '1'
                                                ? '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[40].name : 'Active'}'
                                                : '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[41].name : 'Not Active'}',
                                            style: TextStyle(
                                              color: data?.active == '1'
                                                  ? CustomTheme.myFavColor
                                                  : CustomTheme
                                                      .appThemeContrast,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount:
                          value.ownerPropertyListingModel.data?.length ?? 0,
                      separatorBuilder: (context, index) => const Divider()),
                )
              : value.ownerPropertyListingModel.msg != null &&
                      value.ownerPropertyListingModel.data == null
                  ? Center(
                      child: RMSWidgets.someError(context: context),
                    )
                  : value.ownerPropertyListingModel.msg != null &&
                          value.ownerPropertyListingModel.data != null &&
                          value.ownerPropertyListingModel.data!.isEmpty
                      ? RMSWidgets.noData(
                          context: context, message: 'No Any Properties Found.')
                      : Center(
                          child: RMSWidgets.getLoader(),
                        );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          choosePropertyDialog(context: context, value: _viewModel);
        },
        backgroundColor: CustomTheme.appTheme,
        child: const Icon(Icons.add),
      ),
    );
  }

  void choosePropertyDialog(
      {required BuildContext context, required OwnerPropertyViewModel value}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Center(
              child: Text(
                '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[42].name :'Property Options'}',
                style: TextStyle(
                    color: CustomTheme.appTheme,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ),
            content: Container(
              height: _mainHeight * 0.13,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushNamed(AppRoutes.hostPropertyPage);
                    },
                    child: Container(
                      //width: _mainWidth,

                      decoration: BoxDecoration(
                          border: Border.all(color: CustomTheme.appTheme),
                          borderRadius: BorderRadius.circular(15)),
                      alignment: Alignment.centerLeft,
                      height: _mainHeight * 0.05,
                      child: Center(
                        child: Text(
                          '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[43].name :'Host Your Property'}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: CustomTheme.appTheme),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _mainHeight * 0.02,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushNamed(AppRoutes.addPropertyPage, arguments: {
                        'fromPropertyDetails': false,
                      });
                    },
                    child: Container(
                      // width: _mainWidth,
                      decoration: BoxDecoration(
                          border: Border.all(color: CustomTheme.appTheme),
                          borderRadius: BorderRadius.circular(15)),
                      height: _mainHeight * 0.05,
                      child: Center(
                        child: Text(
                          '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[44].name :'Add Your Property'}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: CustomTheme.appTheme),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            elevation: 5,
          );
        });
  }
}
