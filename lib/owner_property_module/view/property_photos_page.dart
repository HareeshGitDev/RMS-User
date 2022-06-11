import 'dart:developer';
import 'dart:io';

import 'package:RentMyStay_user/owner_property_module/model/owner_property_details_model.dart';
import 'package:RentMyStay_user/theme/fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/capture_photos_page.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../../utils/view/rms_widgets.dart';
import '../model/owner_property_details_request_model.dart';
import '../viewModel/owner_property_viewModel.dart';

class EditPropertyPhotosPage extends StatefulWidget {
  final String propId;
  String? videoLink;
  List<Photos>? photosList;
  final bool fromPropertyDetails;

  EditPropertyPhotosPage(
      {Key? key,
      required this.propId,
      this.videoLink,
      required this.fromPropertyDetails,
      this.photosList = const []})
      : super(key: key);

  @override
  State<EditPropertyPhotosPage> createState() => _EditPropertyPhotosPageState();
}

class _EditPropertyPhotosPageState extends State<EditPropertyPhotosPage> {
  List<File> imageList = [];
  late OwnerPropertyViewModel _viewModel;
  var _mainHeight;
  var _mainWidth;
  final _videoLinkController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel = Provider.of<OwnerPropertyViewModel>(context, listen: false);
    getLanguageData();
  }

  SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();

  getLanguageData() async {
    await _viewModel.getLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'ownerPropertyPage');
  }
  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Text(nullCheck(
            list: context.watch<OwnerPropertyViewModel>().ownerPropertyLang)
            ? '${context.watch<OwnerPropertyViewModel>().ownerPropertyLang[0].name}'
            :'Edit Photos'),
      ),
      body: Consumer<OwnerPropertyViewModel>(
        builder: (context, value, child) {
          return Container(
            height: _mainHeight,
            width: _mainWidth,
            color: Colors.white,
            padding: EdgeInsets.only(
                top: _mainHeight * 0.02,
                bottom: _mainHeight * 0.02),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: _mainWidth * 0.04,
                        right: _mainWidth * 0.04,
                    ),
                    child: Text(
                      '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[1].name :'Upload Youtube Video Url'}',
                      style: TextStyle(
                          fontSize: getHeight(context: context, height: 20),
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: _mainHeight * 0.01,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: _mainWidth * 0.04,
                      right: _mainWidth * 0.04,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: -3,
                        color: Colors.white,
                      ),
                      child: TextFormField(

                        controller: _videoLinkController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "https://www.youtube.com/watch?v=ouom1NLs16I",
                          prefixIcon: Icon(Icons.video_library),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _mainHeight * 0.02,
                  ),
                  Container(
                    height: _mainHeight * 0.05,
                    padding: EdgeInsets.only(

                      right: _mainWidth * 0.04,
                    ),
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all<Color>(CustomTheme.appThemeContrast),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          )),
                      child: Text('${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[2].name :'Upload Video'}'),
                      onPressed: () async {
                        if(_videoLinkController.text.isEmpty || _videoLinkController.text.length <5){
                          RMSWidgets.showSnackbar(context: context, message: 'Please Enter Valid Youtube Url', color: CustomTheme.errorColor);
                          return;
                        }
                        RMSWidgets.showLoaderDialog(
                            context: context, message: 'Loading');
                        OwnerPropertyDetailsRequestModel model=OwnerPropertyDetailsRequestModel(
                            propId: widget.propId,
                            videoLink: _videoLinkController.text
                        );
                        int data = await _viewModel.updatePropertyDetails(requestModel: model);
                        Navigator.of(context).pop();
                        log(data.toString());
                        if (data == 200) {
                          widget.fromPropertyDetails
                              ? Navigator.of(context).pop()
                              : Navigator.of(context).popAndPushNamed(
                              AppRoutes.amenitiesPage,
                              arguments: {
                                'fromPropertyDetails': false,
                                'propId': widget.propId,
                              });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: _mainHeight * 0.05,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: _mainHeight*0.005),
                    alignment: Alignment.center,
                    width: _mainWidth,
                    color: CustomTheme.appTheme,
                    child: Text(
                      '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[3].name :'Capture Photos'}',
                      style: TextStyle(
                          fontSize: getHeight(context: context, height: 20),
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: _mainHeight * 0.02,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: _mainWidth * 0.04,
                      right: _mainWidth * 0.04,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final String? model =
                            await CapturePhotoPage.captureImageByGallery(
                              context: context,
                              function: (imagePath) async {},
                            );
                            log(model.toString());
                            if (model != null) {
                              setState(() {
                                imageList.add(File(model));
                              });
                            }
                          },
                          child: Container(
                            width: _mainWidth * 0.4,
                            height: _mainHeight * 0.05,
                            decoration: BoxDecoration(
                              border: Border.all(color: CustomTheme.appTheme),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  color: CustomTheme.appTheme,
                                  size: _mainHeight*0.025,
                                ),
                                SizedBox(
                                  width: _mainWidth * 0.03,
                                ),
                                Container(
                                  child: Text(
                                    '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[4].name :"Gallery"}',
                                    style: TextStyle(
                                      color: CustomTheme.appTheme,
                                      fontSize: getHeight(context: context, height:14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final String? model =
                            await CapturePhotoPage.captureImageByCamera(
                              context: context,
                              function: (imagePath) async {},
                            );
                            if (model != null) {
                              setState(() {
                                imageList.add(File(model));
                              });
                            }
                          },
                          child: Container(
                            width: _mainWidth * 0.4,
                            height: _mainHeight * 0.05,
                            decoration: BoxDecoration(
                              border: Border.all(color: CustomTheme.appTheme),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color: CustomTheme.appTheme,
                                  size: _mainHeight*0.025,
                                ),
                                SizedBox(
                                  width: _mainWidth * 0.03,
                                ),
                                Container(
                                  child: Text(
                                    '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[5].name :"Camera"}',
                                    style: TextStyle(
                                      color: CustomTheme.appTheme,
                                      fontSize: getHeight(context: context, height: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: _mainHeight * 0.04,
                  ),
                  widget.fromPropertyDetails && widget.photosList != null && widget.photosList!.isNotEmpty
                      ? Container(
                    padding: EdgeInsets.only(
                      left: _mainWidth * 0.04,
                      right: _mainWidth * 0.04,
                    ),
                    height: _mainHeight * 0.15,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: widget.photosList![index].picWp ?? '',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      width: _mainWidth * 0.4,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                        child: Container(
                                          height: _mainHeight * 0.15,
                                          color: Colors.grey,
                                        ),
                                        baseColor: Colors.grey[200] as Color,
                                        highlightColor:
                                        Colors.grey[350] as Color),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                            ),
                            Positioned(
                              child: GestureDetector(
                                onTap: () async {
                                  if(widget.photosList != null && widget.photosList!.isNotEmpty){
                                    RMSWidgets.showLoaderDialog(
                                        context: context, message: 'Loading');
                                    int status = await _viewModel.deletePropPics(
                                        picId: widget.photosList![index].id
                                            .toString());
                                    Navigator.of(context).pop();
                                    if (status == 200) {
                                      setState(() {
                                        widget.photosList!.removeAt(index);
                                      });
                                    }
                                  }

                                },
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.clear,
                                    color: CustomTheme.appTheme,
                                    size: 16,
                                  ),
                                  backgroundColor:
                                  CustomTheme.white.withAlpha(250),
                                  radius: 12,
                                ),
                              ),
                              right: 0,
                            )
                          ],
                        );
                      },
                      itemCount: widget.photosList!.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10,
                      ),
                    ),
                  )
                      : Container(),
                  widget.fromPropertyDetails && widget.photosList != null && widget.photosList!.isNotEmpty
                      ? SizedBox(
                    height: _mainHeight * 0.03,
                  )
                      : Container(),
                  Container(
                    padding: EdgeInsets.only(
                      left: _mainWidth * 0.04,
                      right: _mainWidth * 0.04,
                    ),
                    height: _mainHeight * 0.15,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                imageList[index],
                                fit: BoxFit.cover,
                                width: _mainWidth * 0.4,
                              ),
                            ),
                            Positioned(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => imageList.removeAt(index)),
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.clear,
                                    color: CustomTheme.appTheme,
                                    size: 16,
                                  ),
                                  backgroundColor: CustomTheme.white.withAlpha(250),
                                  radius: 12,
                                ),
                              ),
                              right: 0,
                            )
                          ],
                        );
                      },
                      itemCount: imageList.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10,
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
        height: _mainHeight * 0.05,
        width: _mainWidth,
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
          child:  Text(nullCheck(
              list: context.watch<OwnerPropertyViewModel>().ownerPropertyLang)
              ? '${context.watch<OwnerPropertyViewModel>().ownerPropertyLang[6].name}'
              :'Save'),
          onPressed: () async {
            RMSWidgets.showLoaderDialog(context: context, message: 'Loading');
            int data = await _viewModel.uploadPropPics(
                propId: widget.propId, imageList: imageList);
            Navigator.of(context).pop();
            log(data.toString());
            if (data == 200) {
              widget.fromPropertyDetails
                  ? Navigator.of(context).pop()
                  : Navigator.of(context)
                      .popAndPushNamed(AppRoutes.amenitiesPage, arguments: {
                      'fromPropertyDetails': false,
                      'propId': widget.propId,
                    });
            }
          },
        ),
      ),
    );
  }
}
