import 'dart:developer';

import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/owner_property_module/model/owner_property_details_request_model.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/navigation_service.dart';
import '../viewModel/owner_property_viewModel.dart';

class AddPropertyPage extends StatefulWidget {
  String? propId;
  final bool fromPropertyDetails;
  final String? title;
  final String? propertyType;

  AddPropertyPage(
      {Key? key,
      this.propId,
      required this.fromPropertyDetails,
      this.title,
      this.propertyType})
      : super(key: key);

  @override
  State<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  late OwnerPropertyViewModel _viewModel;
  late SharedPreferenceUtil sharedPreferenceUtil = SharedPreferenceUtil();
  var _mainHeight;
  var _mainWidth;
  String propertyType = 'Select Your Property Type';
  final _propertyNameController = TextEditingController();

  List<String> get getPropertyTypeList => [
        'Select Your Property Type',
        'Furnished House',
        'Furnished Villa',
        'Guest Houses',
        'Hotel',
        'Semi Furnished House',
        'Service Apartment'
      ];
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
      _propertyNameController.text = widget.title.toString();
      propertyType = widget.propertyType ?? 'Select Your Property Type';
    }

  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(nullCheck(
            list: context.watch<OwnerPropertyViewModel>().ownerPropertyLang)
            ? '${context.watch<OwnerPropertyViewModel>().ownerPropertyLang[7].name}'
            :'Add Property'),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: Consumer<OwnerPropertyViewModel>(
        builder: (context, value, child) {
          return Container(
            height: _mainHeight,
            width: _mainWidth,
            color: Colors.white,
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  height: _mainHeight * 0.060,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: -2,
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: _propertyNameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[8].name :"Property Name"}',
                        prefixIcon: Icon(Icons.house, color: Colors.grey, size: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: _mainHeight * 0.04,
                ),
                Neumorphic(
                  style: NeumorphicStyle(
                    shadowLightColor: CustomTheme.appTheme.withAlpha(100),
                    shadowDarkColor: Colors.grey.shade200,
                    color: Colors.white,
                    lightSource: LightSource.bottom,
                    intensity: 2,
                    depth: 2,
                  ),
                  child: Container(
                    height: _mainHeight * 0.06,
                    width: _mainWidth,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        iconEnabledColor: CustomTheme.appTheme,
                        items: getPropertyTypeList
                            .map((type) => DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(type),
                          ),
                          value: type,
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            propertyType = value.toString();
                          });
                        },
                        value: propertyType,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: _mainHeight * 0.1,
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: _mainHeight * 0.05,
        margin: EdgeInsets.only(
            left: _mainWidth * 0.04,
            right: _mainWidth * 0.04,
            bottom: _mainHeight * 0.02),
        width: _mainWidth,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(CustomTheme.appTheme),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              )),
          child: Text(nullCheck(
              list: context.watch<OwnerPropertyViewModel>().ownerPropertyLang)
              ? '${context.watch<OwnerPropertyViewModel>().ownerPropertyLang[7].name}'
              :'Add Property'),
          onPressed: () async {
            if (_propertyNameController.text.isEmpty) {
              RMSWidgets.getToast(
                  message: 'Please Enter Property Name ',
                  color: CustomTheme.errorColor);
              return;
            }
            if (propertyType == 'Select Your Property Type') {
              RMSWidgets.getToast(
                  message: 'Please Select Property Type ',
                  color: CustomTheme.errorColor);
              return;
            }

            String value = '';
            switch (propertyType) {
              case 'Furnished House':
                value = '4';
                break;
              case 'Furnished Villa':
                value = '5';
                break;
              case 'Guest Houses':
                value = '7';
                break;
              case 'Hotel':
                value = '13';
                break;
              case 'Semi Furnished House':
                value = '30';
                break;
              case 'Service Apartment':
                value = '26';
                break;
            }
            if (widget.fromPropertyDetails) {
              OwnerPropertyDetailsRequestModel model =
                  OwnerPropertyDetailsRequestModel();
              model.propTypeId = value;
              model.title = _propertyNameController.text;
              model.propId = widget.propId;
              RMSWidgets.showLoaderDialog(context: context, message: 'Loading');
              int data =
                  await _viewModel.updatePropertyDetails(requestModel: model);
              Navigator.of(context).pop();
              if (data == 200) {
                Navigator.of(context).pop();
              }
            } else {
              RMSWidgets.showLoaderDialog(context: context, message: 'Loading');
              String propId = await _viewModel.createProperty(
                title: _propertyNameController.text,
                rent: '0',
                email: '${await sharedPreferenceUtil.getString(rms_email)}',
                roomType: '1',
                propertyType: value,
              );
              Navigator.of(context).pop();
              if (propId != 'failure') {
                Navigator.of(context)
                    .popAndPushNamed(AppRoutes.propertyRentPage, arguments: {
                  'fromPropertyDetails': false,
                  'propId': propId,
                });
              }
            }
          },
        ),
      ),
    );
  }
}
