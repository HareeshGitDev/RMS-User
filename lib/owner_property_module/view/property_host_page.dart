import 'dart:developer';

import 'package:RentMyStay_user/owner_property_module/viewModel/owner_property_viewModel.dart';
import 'package:RentMyStay_user/utils/model/current_location_model.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/location_service.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/service/shared_prefrences_util.dart';

class HostPropertyPage extends StatefulWidget {
  const HostPropertyPage({Key? key}) : super(key: key);

  @override
  State<HostPropertyPage> createState() => _HostPropertyPageState();
}

class _HostPropertyPageState extends State<HostPropertyPage> {
  var _mainHeight;
  late OwnerPropertyViewModel _viewModel;
  var _mainWidth;
  var name = '';
  var email = '';
  var mobilenumber = '';
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _commentsController = TextEditingController();

  int units = 0;
  String? lat;
  String? lang;
  SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();
  Future<void> pref() async {
    name = (await preferenceUtil.getString(rms_name) ?? '').toString();
    email = (await preferenceUtil.getString(rms_email) ?? '').toString();
    mobilenumber = (await preferenceUtil.getString(rms_phoneNumber) ?? '').toString();
    _nameController.text = name;
    _phoneController.text = mobilenumber;
    _emailController.text = email;

  }


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
    pref();
    _viewModel = Provider.of<OwnerPropertyViewModel>(context, listen: false);
    getLanguageData();


  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(nullCheck(
            list: context.watch<OwnerPropertyViewModel>().ownerPropertyLang)
            ? '${context.watch<OwnerPropertyViewModel>().ownerPropertyLang[32].name}'
            :'Add Host'),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: Consumer<OwnerPropertyViewModel>(builder:(context, value, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            height: _mainHeight,
            width: _mainWidth,
            color: Colors.white,
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(

                    alignment: Alignment.centerLeft,
                    // height: _mainHeight * 0.060,
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
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:'${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[33].name : "Owner Name"}',
                          prefixIcon:
                          Icon(Icons.person, color: Colors.grey, size: 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _mainHeight * 0.015,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    // height: _mainHeight * 0.060,
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
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[34].name :"Email"}',
                          prefixIcon: Icon(Icons.email_outlined,
                              color: Colors.grey, size: 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _mainHeight * 0.015,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    //height: _mainHeight * 0.060,
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
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[35].name :"Phone Number"}',
                          prefixIcon: Icon(Icons.phone_android,
                              color: Colors.grey, size: 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _mainHeight * 0.015,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    //  height: _mainHeight * 0.060,
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
                        controller: _addressController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[36].name :"Property Address"}',
                          prefixIcon: Icon(Icons.my_location,
                              color: Colors.grey, size: 20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _mainHeight * 0.02,
                  ),
                  Container(
                    height: 50,
                    width: _mainWidth,
                    child: Row(
                      children: [
                        Text(
                          '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[37].name :'Number of Units'} : ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        DropdownButton<int>(
                            borderRadius: BorderRadius.circular(20),
                            elevation: 65,
                            value: units,
                            iconEnabledColor: CustomTheme.appThemeContrast,
                            style: TextStyle(color: CustomTheme.appTheme),
                            menuMaxHeight: _mainHeight * 0.35,
                            items: List.generate(51, (index) => index)
                                .map(
                                  (e) => DropdownMenuItem<int>(
                                value: e,
                                child: Text(
                                  e.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                            )
                                .toList(),
                            onChanged: (int? val) {
                              setState(() {
                                units = int.parse(val.toString());
                              });
                            }),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: _mainHeight * 0.2,
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
                        maxLines: 5,
                        controller: _commentsController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                          border: InputBorder.none,
                          hintText: '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[29].name :"Description"}...',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
            left: _mainWidth * 0.04,
            right: _mainWidth * 0.04,
            bottom: _mainHeight * 0.02),
        height: _mainHeight * 0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: _mainWidth * 0.4,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        CustomTheme.appThemeContrast),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                    )),
                onPressed: () async {
                  CurrentLocationModel location =
                      await LocationService.getCurrentPlace(context: context);
                  if (location.fullAddress != null) {
                    lat = location.latitude;
                    lang = location.longitude;
                    _addressController.text = location.fullAddress.toString();
                  }
                },
                child: Center(child: Text(nullCheck(
                    list: context.watch<OwnerPropertyViewModel>().ownerPropertyLang)
                    ? '${context.watch<OwnerPropertyViewModel>().ownerPropertyLang[26].name}'
                    :"Capture Location")),
              ),
            ),
            Container(
              width: _mainWidth * 0.4,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(CustomTheme.appTheme),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                    )),
                onPressed: () async {
                  if (_nameController.text.isEmpty) {
                    RMSWidgets.showSnackbar(
                        context: context,
                        message: 'Please enter Owner Name',
                        color: CustomTheme.errorColor);
                    return;
                  }
                  if (_emailController.text.isEmpty) {
                    RMSWidgets.showSnackbar(
                        context: context,
                        message: 'Please enter E-mail',
                        color: CustomTheme.errorColor);
                    return;
                  }
                  if (_phoneController.text.isEmpty ||
                      (_phoneController.text.length < 10 ||
                          _phoneController.text.length > 12)) {
                    RMSWidgets.showSnackbar(
                        context: context,
                        message: 'Please enter Valid Phone Number',
                        color: CustomTheme.errorColor);
                    return;
                  }
                  if (_addressController.text.isEmpty) {
                    RMSWidgets.showSnackbar(
                        context: context,
                        message: 'Please enter Property Address',
                        color: CustomTheme.errorColor);
                    return;
                  }
                  if (units == 0) {
                    RMSWidgets.showSnackbar(
                        context: context,
                        message: 'Please Select no. of Property Units',
                        color: CustomTheme.errorColor);
                    return;
                  }
                  String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                      "\\@" +
                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                      "(" +
                      "\\." +
                      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                      ")+";
                  RegExp regExp = RegExp(p);

                  if (!regExp.hasMatch(_emailController.text)) {
                    RMSWidgets.showSnackbar(
                        context: context,
                        message: 'Please Enter Valid E-Mail',
                        color: CustomTheme.errorColor);
                    return;
                  }

                  RMSWidgets.showLoaderDialog(
                      context: context, message: 'Loading');
                  int response = await _viewModel.hostProperty(
                    context: context,
                      ownerName: _nameController.text,
                      email: _emailController.text,
                      phone: _phoneController.text,
                      address: _addressController.text,
                      units: units.toString(),
                      comment: _commentsController.text.isEmpty
                          ? _commentsController.text
                          : '',
                      lat: lat ?? '',
                      lang: lang ?? '');
                  Navigator.of(context).pop();
                  if (response == 200) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.dashboardPage, (route) => false);
                  }
                },
                child: Center(child: Text(nullCheck(
                    list: context.watch<OwnerPropertyViewModel>().ownerPropertyLang)
                    ? '${context.watch<OwnerPropertyViewModel>().ownerPropertyLang[38].name}'
                    :"Submit")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
