import 'dart:async';
import 'dart:developer';


import 'package:RentMyStay_user/utils/view/webView_page.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_amount_request_model.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_amounts_response_model.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_credential_response_model.dart';
import 'package:RentMyStay_user/property_details_module/viewModel/property_details_viewModel.dart';
import 'package:RentMyStay_user/utils/constants/app_consts.dart';
import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../images.dart';
import '../../language_module/model/language_model.dart';
import '../../payment_module/model/payment_request_model.dart';
import '../../theme/custom_theme.dart';
import '../model/property_details_util_model.dart';
import '../../utils/constants/enum_consts.dart';
import '../../utils/date_range/blackout_date_range.dart';
import '../../utils/service/date_time_service.dart';
import '../../utils/view/calander_page.dart';

class BookingPage extends StatefulWidget {
  final PropertyDetailsUtilModel propertyDetailsUtilModel;


  BookingPage({Key? key, required this.propertyDetailsUtilModel})
      : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late ThemeData theme;

  var _mainHeight;
  var _mainWidth;
  int _currentStep = 0;
  int maxGuest=0;
List bookingTypeData=[];
var bookingType;
var bookingTypeDisplay;
  DateTime selectedDate = DateTime.now();
  String showDate = 'Select Date For Visit';
  String checkInDate = DateTimeService.ddMMYYYYformatDate(DateTime.now());
  String checkOutDate = DateTimeService.ddMMYYYYformatDate(
      DateTime.now().add(const Duration(days: 1)));
  final _emailController = TextEditingController();
  final _coupanController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  late PropertyDetailsViewModel _viewModel;
  SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();
  late StreamSubscription<ConnectivityResult> _connectivitySubs;
  final Connectivity _connectivity = Connectivity();
  bool _connectionStatus = true;

  Future<void> initConnectionStatus() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      log(e.toString());
    }
    if (!mounted) {
      return null;
    }

    _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() => _connectionStatus = true);
        break;
      case ConnectivityResult.mobile:
        setState(() => _connectionStatus = true);
        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = false);
        break;
      case ConnectivityResult.ethernet:
        setState(() => _connectionStatus = true);
        break;
      default:
        setState(() => _connectionStatus = false);
        break;
    }
  }



  @override
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _viewModel = Provider.of<PropertyDetailsViewModel>(context, listen: false);
    getLanguageData();
    initMethod();
    maxGuest=widget.propertyDetailsUtilModel.maxGuest ?? 0;
  }

  @override
  void dispose() {
    _connectivitySubs.cancel();
    super.dispose();
  }

  getLanguageData() async {
    await _viewModel.getBookingPageLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'bookingpage');
  }

  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty  ? true : false;

  Future<void> initMethod() async {
    _emailController.text = (widget.propertyDetailsUtilModel.email).toString();
    _nameController.text = (widget.propertyDetailsUtilModel.name).toString();
    _phoneNumberController.text =
        (widget.propertyDetailsUtilModel.mobile).toString();

    checkInDate = await preferenceUtil.getString(rms_checkInDate) ??
        DateTimeService.ddMMYYYYformatDate(DateTime.now());
    checkOutDate = await preferenceUtil.getString(rms_checkOutDate) ??
        DateTimeService.ddMMYYYYformatDate(
            DateTime.now().add(const Duration(days: 1)));
    log("OYE HOYE");
    var fromDate= DateTime.parse(checkInDate);
    var toDate=    DateTime.parse(checkOutDate);
  int difference= toDate.difference(fromDate).inDays;

    log(">>>>> $difference");
   // int difference= ;

   await _viewModel.getBookingDetails(
      context: context,
        model: BookingAmountRequestModel(
      propId: (widget.propertyDetailsUtilModel.propId).toString(),
      token: (widget.propertyDetailsUtilModel.token).toString(),
      numOfGuests: (widget.propertyDetailsUtilModel.maxGuest).toString(),
      couponCode: '',
      fromDate: checkInDate,
      toDate: checkOutDate,
     bookingType: widget.propertyDetailsUtilModel.bookingType !=null?widget.propertyDetailsUtilModel.bookingType:""

    ));
   bookingTypeData.add("Flexi Rent ${widget.propertyDetailsUtilModel.flexiRent}");
   bookingTypeData.add("Regular Rent ${widget.propertyDetailsUtilModel.longTermRent}");
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus?Consumer<PropertyDetailsViewModel>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              '${widget.propertyDetailsUtilModel.buildingName ?? ''} (${widget.propertyDetailsUtilModel.propId})',
              style: const TextStyle(

              ),
            ),
            centerTitle: false,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            titleSpacing: 0,
            backgroundColor: CustomTheme.appTheme,
          ),
          body: Container(
            height: _mainHeight,
            width: _mainWidth,

            child: SingleChildScrollView(
              child: Column(
                children: [
                  value.bookingAmountsResponseModel == null
                      ? const Text('')
                      : value.bookingAmountsResponseModel != null &&
                              value.bookingAmountsResponseModel?.msg
                                      ?.toString()
                                      .toLowerCase() ==
                                  'success'
                          ? const Text('')
                          : Container(
                              height: _mainHeight*0.045,
                              width: _mainWidth,
                              padding: EdgeInsets.only(left: 15, right: 5),
                              color: CustomTheme.errorColor,
                              alignment: Alignment.center,
                              child: Text(
                                  '${value.bookingAmountsResponseModel?.msg?.replaceFirst('failure', '').trim()} Please Select Other Dates.',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[0].name : "You are almost done !"}',
                    style: TextStyle(
                        fontSize: 24,

                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: _mainHeight*0.01,

                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding:EdgeInsets.only(left: _mainWidth*0.02, right: _mainWidth*0.025),
                          child: Text(
                            widget.propertyDetailsUtilModel.title ?? '',
                            style: const TextStyle(

                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: _mainHeight*0.01,),
                          child: Stepper(
                            controlsBuilder: (context, details) {
                              if (details.stepIndex == 5) {
                                return Container();
                              } else {
                                return Container(
                                  height: 40,
                                  //  color: Colors.green,
                                  margin: EdgeInsets.only(top: 5, bottom: 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Visibility(
                                        visible: details.stepIndex > 0,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_currentStep <= 0) return;
                                            setState(() {
                                              _currentStep -= 1;
                                            });
                                          },
                                          child: Text(
                                              '${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[4].name : 'Prev'}'),
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .all<Color>(CustomTheme
                                                          .appThemeContrast),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              )),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _currentStep += 1;
                                          });
                                        },
                                        child: Text(
                                            '${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[3].name : 'Next'}'),
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    CustomTheme.appTheme),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            )),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            currentStep: _currentStep,
                            onStepContinue: () {
                              log('Continue Called');
                              if (_currentStep >= 5) return;
                              setState(() {
                                _currentStep += 1;
                              });
                            },
                            onStepCancel: () {
                              log('Cancel Called');
                              if (_currentStep <= 0) return;
                              setState(() {
                                _currentStep -= 1;
                              });
                            },
                            onStepTapped: (pos) {
                              log('Tapped Called');
                              setState(() {
                                _currentStep = pos;
                              });
                            },
                            physics: const NeverScrollableScrollPhysics(),
                            steps: <Step>[
                              Step(
                                isActive: true,
                                title: Text(
                                  '${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[1].name : 'Select Date'}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,

                                      color: Colors.grey),
                                ),
                                subtitle: Text('${showformatDate(checkInDate)}   to   ${showformatDate(checkOutDate)}'),
                                state: StepState.complete,
                                content: _getSelectDateView(
                                    context: context,
                                    model: value.bookingAmountsResponseModel ??
                                        BookingAmountsResponseModel(),
                                    value: value),
                              ),
//                             Step(
//
//                                   isActive: false,
//                                   state: StepState.complete,
//                                   title: const Text("Booking Type" ,style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//
//                                       color: Colors.grey),),
//                                   content: Container(
//                                     width: double.infinity,
//                                     decoration: BoxDecoration(
//                                       borderRadius:
//                                       BorderRadius.all(Radius.circular(20)),
//                                     ),
//                                     child: Neumorphic(
//                                       padding: EdgeInsets.only(left: 10),
//
//                                       style: NeumorphicStyle(
//                                         depth: -3,
//                                         color: Colors.white,
//                                       ),
//                                       child: DropdownButtonHideUnderline(
//                                         child: DropdownButton(
//                                           hint: Text("SELECT BOOKING TYPE"),
//                                             value: bookingTypeDisplay,
//                                             onChanged: (val) {
// if(val=="Flexi Rent ${value.bookingAmountsResponseModel?.data?.rent}"){
//   setState((){
//     bookingType="Short Term";
//     bookingTypeDisplay=val;
//   });
// }
// else{
//   setState((){
//     bookingType="Long Term";
//     bookingTypeDisplay=val;
//
//   });
// }
// print(">>>>  ${bookingType}");
//                                         }, items:
//                                           bookingTypeData.map((e) {return  DropdownMenuItem(child: Text(e.toString(),),
//
//                                           value: e.toString(),
//                                           );}
//
//         ).toList()
//
//                                  ),
//                                       ),
//                                     ),
//                                   )
//                                   //:Container(
//                                     // width: double.infinity,
//                                     // decoration: BoxDecoration(
//                                     //   borderRadius:
//                                     //   BorderRadius.all(Radius.circular(20)),
//                                     // ),
//                                     // child: Neumorphic(
//                                     //   padding: EdgeInsets.only(left: 10,right: 20,top: 10,bottom: 10),
//                                     //
//                                     //   style: NeumorphicStyle(
//                                     //     depth: -3,
//                                     //     color: Colors.white,
//                                     //   ),child: Text("Flexi Rent")),),
//                             ),
                              Step(subtitle: Text(_nameController.text),
                                isActive: true,
                                state: StepState.complete,
                                title: Text(
                                  '${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[5].name : 'Guest Name* (As per Aadhar)'}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,

                                      color: Colors.grey),
                                ),
                                content: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Neumorphic(
                                    style: NeumorphicStyle(
                                      depth: -3,
                                      color: Colors.white,
                                    ),
                                    child: TextFormField(
                                      /*validator: (value) {
                                    if (value != null && value.length < 6) {
                                      return "Enter proper email";
                                    }
                                    return null;
                                  },*/

                                      controller: _nameController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                            Icons.drive_file_rename_outline),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Step(
                                subtitle: Text(_phoneNumberController.text),
                                isActive: true,
                                state: StepState.complete,
                                title: Text(
                                  '${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[6].name : 'Guest Mobile*'}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,

                                      color: Colors.grey),
                                ),
                                content: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Neumorphic(
                                    style: NeumorphicStyle(
                                      depth: -3,
                                      color: Colors.white,
                                    ),
                                    child: TextFormField(
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      keyboardType: TextInputType.phone,
                                      maxLength: 10,

                                      controller: _phoneNumberController,

                                      decoration: InputDecoration(
                                        border: InputBorder.none,


                                        prefixIcon: Icon(Icons.mobile_friendly),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Step(
                                subtitle: Text(_emailController.text),
                                isActive: true,
                                state: StepState.complete,
                                title: Text(
                                  '${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[7].name : 'Guest Email*'}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,

                                      color: Colors.grey),
                                ),
                                content: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Neumorphic(
                                    style: NeumorphicStyle(
                                      depth: -3,
                                      color: Colors.white,
                                    ),
                                    child: TextFormField(
                                    /*  validator: (value) {
                                    if (value != null && !value.contains('@')) {
                                      return "Enter proper email";
                                    }
                                    return null;
                                  },*/
                                      enabled: true,
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _emailController,

                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        //hintText: 'Email',
                                        prefixIcon: Icon(Icons.email_outlined),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Step(
                                isActive: true,
                                title: Text(
                                  '$maxGuest ${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[8].name : 'Guest '}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,

                                      color: Colors.grey),
                                ),
                                state: StepState.complete,
                                content: Container(
                                  margin: EdgeInsets.only(bottom: _mainHeight*0.01,),
                                  height: _mainHeight * 0.05,
                                  width: _mainWidth*0.3,
                                  child:  Neumorphic(
                                    style: NeumorphicStyle(
                                      shadowLightColor: CustomTheme.appTheme.withAlpha(100),
                                      shadowDarkColor: Colors.grey.shade200,
                                      color: Colors.white,
                                      lightSource: LightSource.bottom,
                                      intensity: 2,
                                      depth: 2,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        iconEnabledColor: CustomTheme.appTheme,
                                        items: widget.propertyDetailsUtilModel.guestList
                                            ?.map((type) => DropdownMenuItem(
                                          child: Padding(
                                            padding:  EdgeInsets.only(left:_mainWidth*0.04),
                                            child: Text(type.toString()),
                                          ),
                                          value: type,
                                        ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            maxGuest = value as int;
                                          });
                                        },
                                        value: maxGuest,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Step(
                                isActive: true,
                                title: Text(
                                  '${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[9].name : 'Coupon Code'}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,

                                      color: Colors.grey),
                                ),
                                state: StepState.complete,
                                content: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Neumorphic(
                                        style: NeumorphicStyle(
                                          depth: -3,
                                          color: Colors.white,
                                        ),
                                        child: TextFormField(
                                          controller: _coupanController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Enter coupon code here',
                                            prefixIcon: Icon(
                                                Icons.monetization_on_outlined),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (_coupanController.text.isEmpty ||
                                            _coupanController.text.length < 5) {
                                          RMSWidgets.showSnackbar(
                                              context: context,
                                              message:
                                                  'Please Enter Valid Coupon Code',
                                              color: CustomTheme.errorColor);
                                          return;
                                        }
                                        RMSWidgets.showLoaderDialog(
                                            context: context,
                                            message: 'Loading...');
                                        var fromDate= DateTime.parse(checkInDate);
                                        var toDate=    DateTime.parse(checkOutDate);
                                        int difference= toDate.difference(fromDate).inDays;
                                        await _viewModel.getBookingDetails(
                                          context: context,
                                            model: BookingAmountRequestModel(
                                          propId: (widget
                                                  .propertyDetailsUtilModel
                                                  .propId)
                                              .toString(),
                                          token: (widget
                                                  .propertyDetailsUtilModel
                                                  .token)
                                              .toString(),
                                          numOfGuests:maxGuest.toString(),
                                          couponCode: _coupanController.text,
                                          fromDate: checkInDate,
                                          toDate: checkOutDate,
                                          bookingType:widget.propertyDetailsUtilModel.bookingType

                                            ));
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        Navigator.of(context).pop();

                                        RMSWidgets.showSnackbar(
                                            context: context,
                                            message:
                                                '${value.bookingAmountsResponseModel?.data?.userMsg}',
                                            color: Colors.green);
                                      },
                                      child: Text('Apply'),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                CustomTheme.appTheme),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: _mainHeight*0.11,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: value.bookingAmountsResponseModel != null &&
                          value.bookingAmountsResponseModel?.data != null
                      ? () async {
                          _showBreakdownBottomSheet(
                              context: context,
                              model: value.bookingAmountsResponseModel ??
                                  BookingAmountsResponseModel(),
                              value: value);
                        }
                      : () {},
                  child: Container(
                    height: _mainHeight*0.04,
                    color: Colors.blueGrey.shade50,
                    alignment: Alignment.center,
                    width: _mainWidth,
                    child: RichText(

                        text: TextSpan(
                            text:
                                '${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[10].name : 'Click to see '}',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,

                                color: Colors.black),
                            children: <TextSpan>[
                          TextSpan(
                            text:
                                ' ${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[11].name : ' Price BreakDown'}',
                            style: TextStyle(
                              color: CustomTheme.myFavColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,

                            ),
                          ),
                        ])),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      color: Colors.white,
                      height: _mainHeight * 0.06,
                      width: MediaQuery.of(context).size.width * 0.4,
                      margin: EdgeInsets.only(
                          left: _mainWidth * 0.05,
                          right: _mainWidth * 0.05,
                          bottom: _mainHeight * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            '$rupee ${value.bookingAmountsResponseModel?.data?.advanceAmount ?? 0}',
                            style: TextStyle(
                              fontSize: 20,

                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                              '${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[12].name : 'Payable Amount'}'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: _mainHeight * 0.06,
                        width: MediaQuery.of(context).size.width * 0.68,
                        child: ElevatedButton(
                          onPressed: value.bookingAmountsResponseModel !=
                                      null &&
                                  value.bookingAmountsResponseModel?.data !=
                                      null
                              ? () async {

                              String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                  "\\@" +
                                  "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                                  "(" +
                                  "\\." +
                                  "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                                  ")+";
                              RegExp regExp = RegExp(p);

                              if(_nameController.text.isEmpty){
                                RMSWidgets.getToast(message: 'Please Enter Valid Name.', color: CustomTheme.errorColor);
                                return;
                              }
                              if(_phoneNumberController.text.length <10 ){
                                RMSWidgets.getToast(message: 'Please Enter Valid Mobile Number.', color: CustomTheme.errorColor);
                                return;
                              }
                              if(_emailController.text.isEmpty || !regExp.hasMatch(_emailController.text)){
                                RMSWidgets.getToast(message: 'Please Enter Valid Email.', color: CustomTheme.errorColor);
                                return;
                              }

                                  RMSWidgets.showLoaderDialog(
                                      context: context, message: 'Loading');
                                  BookingCredentialResponseModel response =
                                      await _viewModel.getBookingCredentials(
                                        context: context,
                                          model: BookingAmountRequestModel(
                                    propId:
                                        (widget.propertyDetailsUtilModel.propId)
                                            .toString(),
                                    token:
                                        (widget.propertyDetailsUtilModel.token)
                                            .toString(),
                                    numOfGuests: (widget
                                            .propertyDetailsUtilModel.maxGuest)
                                        .toString(),
                                    couponCode: '',
                                    fromDate: checkInDate,
                                    toDate: checkOutDate,
                                    cartId: value.bookingAmountsResponseModel
                                        ?.data?.cartId
                                        .toString(),
                                    email: _emailController.text,
                                    name: _nameController.text,
                                    phone: _phoneNumberController.text,
                                    depositAmount:
                                        value.bookingAmountsResponseModel !=
                                                    null &&
                                                value.bookingAmountsResponseModel
                                                        ?.data?.advanceAmount !=
                                                    null
                                            ? value.bookingAmountsResponseModel
                                                ?.data?.advanceAmount
                                                .toString()
                                            : '',
                                  ));

                                  Navigator.pop(context);

                                  if (response.msg?.toLowerCase() ==
                                          'success' &&
                                      response.data != null &&
                                      response.data?.prefill != null &&
                                      response.data?.amount != null &&
                                      response.data?.key != null &&
                                      response.data?.orderId != null &&
                                      response.data?.callbackApi != null) {
                                    // _bookingCredentialResponseModel = response;
                                    Navigator.of(context).pushNamed(
                                        AppRoutes.razorpayPaymentPage,
                                        arguments: PaymentRequestModel(
                                            name: response.data?.prefill?.name ??
                                                '',
                                            color: response.data?.theme?.color ??
                                                '',
                                            email:
                                                response.data?.prefill?.email ??
                                                    '',
                                            image: response.data?.image ?? '',
                                            amount:
                                                (response.data?.amount ?? '')
                                                    .toString(),
                                            contactNumber: response
                                                    .data?.prefill?.contact ??
                                                '',
                                            description:
                                                response.data?.description ??
                                                    'RMS Payment',
                                            orderId:
                                                response.data?.orderId ?? '',
                                            paymentMode:
                                                PaymentMode.FromProperty,
                                            razorPayKey:
                                                response.data?.key ?? '',
                                            redirectApi:
                                                response.data?.callbackApi ?? '',
                                            extraInfo: ''));
                                  }
                                }
                              : () {},
                          child: Text(
                            '${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[13].name : 'Proceed Booking'}',
                            style: const TextStyle(

                              fontSize: 16,
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  value.bookingAmountsResponseModel != null &&
                                          value.bookingAmountsResponseModel
                                                  ?.data !=
                                              null
                                      ? CustomTheme.appTheme
                                      : Colors.grey),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ):RMSWidgets.networkErrorPage(context: context);
  }

  static String showformatDate(String da) {
    var a = da.split('-');
    String month = '';
    switch (a[1]) {
      case '01':
        month = "January";
        break;
      case '02':
        month = "February";
        break;
      case '03':
        month = "March";
        break;
      case '04':
        month = "April";
        break;
      case '05':
        month = "May";
        break;
      case '06':
        month = "June";
        break;
      case '07':
        month = "July";
        break;
      case '08':
        month = "August";
        break;
      case '09':
        month = "September";
        break;
      case '10':
        month = "October";
        break;
      case '11':
        month = "November";
        break;
      case '12':
        month = "December";
        break;
    }
    return '${a[2]} ${month}, ${a[0]}';
  }

  Widget _getSelectDateView(
      {required BuildContext context,
      required BookingAmountsResponseModel model,
      required PropertyDetailsViewModel value}) {
    return GestureDetector(
      onTap: () async {
        PickerDateRange? dateRange =
            await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CalenderPage(
              initialDatesRange: PickerDateRange(
            DateTime.parse(checkInDate),
            DateTime.parse(checkOutDate),
          )),
        ));
        if (dateRange != null) {

          checkInDate = DateTimeService.ddMMYYYYformatDate(
              dateRange.startDate ?? DateTime.now());
          checkOutDate = DateTimeService.ddMMYYYYformatDate(
              dateRange.endDate ?? DateTime.now().add(const Duration(days: 1)));

          await preferenceUtil.setString(rms_checkInDate, checkInDate);
          await preferenceUtil.setString(rms_checkOutDate, checkOutDate);
          var fromDate= DateTime.parse(checkInDate);
          var toDate=    DateTime.parse(checkOutDate);
          int difference= toDate.difference(fromDate).inDays;
          if(difference>90){
await showModalBottomSheet(
    isScrollControlled: true,
    context: context, builder: (context){
  return BookingTypeDropDown(bookingTypeData: bookingTypeData, regularRent: widget.propertyDetailsUtilModel.longTermRent, flexiRent: widget.propertyDetailsUtilModel.flexiRent,
  );
});
RMSWidgets.showLoaderDialog(context: context, message: 'Loading...');

var bookingType=await preferenceUtil.getString(rms_BookingType);
            await _viewModel.getBookingDetails(
                context: context,
                model: BookingAmountRequestModel(
                    propId: (widget.propertyDetailsUtilModel.propId).toString(),
                    token: (widget.propertyDetailsUtilModel.token).toString(),
                    numOfGuests: (widget.propertyDetailsUtilModel.maxGuest).toString(),
                    couponCode: '',
                    fromDate: checkInDate,
                    toDate: checkOutDate,
                    bookingType: bookingType,

                ));

        Navigator.pop(context);
          }
          else {
            RMSWidgets.showLoaderDialog(context: context, message: 'Loading...');


await preferenceUtil.setString(rms_BookingType, difference>29?"Short Term":"Daily");
            await _viewModel.getBookingDetails(
                context: context,
                model: BookingAmountRequestModel(
                    propId: (widget.propertyDetailsUtilModel.propId).toString(),
                    token: (widget.propertyDetailsUtilModel.token).toString(),
                    numOfGuests: (widget.propertyDetailsUtilModel.maxGuest)
                        .toString(),
                    couponCode: '',
                    fromDate: checkInDate,
                    toDate: checkOutDate,
                    bookingType: difference > 90 ? "Long Term" : difference > 29
                        ? "Short Term"
                        : "Daily"

                ));
            Navigator.of(context).pop();
          }
        //  Navigator.of(context).pop();
        }
        else {
          RMSWidgets.showLoaderDialog(context: context, message: 'Loading...');

          checkInDate = DateTimeService.ddMMYYYYformatDate(
               DateTime.now());
          checkOutDate = DateTimeService.ddMMYYYYformatDate(
            DateTime.now().add(const Duration(days: 1)));

          await preferenceUtil.setString(rms_checkInDate, checkInDate);
          await preferenceUtil.setString(rms_checkOutDate, checkOutDate);
          var fromDate= DateTime.parse(checkInDate);
          var toDate=    DateTime.parse(checkOutDate);
          int difference= toDate.difference(fromDate).inDays;
          if(difference>90){
            await showModalBottomSheet(

                context: context, builder: (context){
              return BookingTypeDropDown(bookingTypeData: bookingTypeData, regularRent: widget.propertyDetailsUtilModel.longTermRent, flexiRent: widget.propertyDetailsUtilModel.flexiRent,
              );
            });
            RMSWidgets.showLoaderDialog(context: context, message: 'Loading...');

            var bookingType=await preferenceUtil.getString(rms_BookingType);
            await _viewModel.getBookingDetails(
                context: context,
                model: BookingAmountRequestModel(
                  propId: (widget.propertyDetailsUtilModel.propId).toString(),
                  token: (widget.propertyDetailsUtilModel.token).toString(),
                  numOfGuests: (widget.propertyDetailsUtilModel.maxGuest).toString(),
                  couponCode: '',
                  fromDate: checkInDate,
                  toDate: checkOutDate,
                  bookingType: bookingType,

                ));

            Navigator.pop(context);
          }
          else {
            RMSWidgets.showLoaderDialog(context: context, message: 'Loading...');

            await preferenceUtil.setString(rms_BookingType, difference>29?"Short Term":"Daily");
            await _viewModel.getBookingDetails(
                context: context,
                model: BookingAmountRequestModel(
                    propId: (widget.propertyDetailsUtilModel.propId).toString(),
                    token: (widget.propertyDetailsUtilModel.token).toString(),
                    numOfGuests: (widget.propertyDetailsUtilModel.maxGuest)
                        .toString(),
                    couponCode: '',
                    fromDate: checkInDate,
                    toDate: checkOutDate,
                    bookingType: difference > 90 ? "Long Term" : difference > 29
                        ? "Short Term"
                        : "Daily"

                ));
            Navigator.of(context).pop();
          }
        }
      },
      child: model.msg == null
          ? RMSWidgets.showShimmer(
              height: _mainHeight * 0.26, width: _mainWidth, borderCorner: 15)
          : Neumorphic(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 5),
            style: NeumorphicStyle(
              shadowLightColor: CustomTheme.appTheme.withAlpha(180),
              //CustomTheme.appTheme.withAlpha(150),
              shadowDarkColor: Colors.grey.shade400,

              color: Colors.white,
              lightSource: LightSource.bottom,
              intensity: 5,
              depth: 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(showformatDate(checkInDate),
                              style: TextStyle(fontSize: 16)),
                          SizedBox(
                            height: 5,
                          ),
                          Text('CheckIn: 12:00PM',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      Text(
                        'Edit',
                        style: TextStyle(color: CustomTheme.appThemeContrast),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                            height: 40,
                            child: VerticalDivider(
                              width: 40,
                              thickness: 1,
                              color: Colors.grey,
                              endIndent: 5,
                              indent: 5,
                            )),
                        RichText(
                            text: TextSpan(
                                text:
                                    '${model.data?.nights != null ? model.data?.nights.toString() : 0}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,

                                    color: Colors.grey),
                                children: <TextSpan>[
                              TextSpan(
                                text:
                                    ' ${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[2].name : ' Nights'}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,

                                    color: Colors.grey),
                              ),
                            ])),
                        SizedBox(
                            height: 40,
                            child: VerticalDivider(
                              width: 40,
                              thickness: 1,
                              color: Colors.grey,
                              endIndent: 5,
                              indent: 5,
                            )),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(showformatDate(checkOutDate),
                              style: TextStyle(fontSize: 16)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'CheckOut: 11:00AM',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        'Edit',
                        style: TextStyle(color: CustomTheme.appThemeContrast),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showBreakdownBottomSheet(
      {required BuildContext context,
      required BookingAmountsResponseModel model,
      required PropertyDetailsViewModel value}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            child: Padding(
              padding: EdgeInsets.all(24,),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        '${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[14].name : 'See Payment BreakDown'}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Material(
                        elevation: 4,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Visibility(
                                visible: model.data!.nights!<29?true:false,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${model.data!.nights!< 29?"Daily Rent":model.data!.nights!>90?"Regular Rent":"Flexi Rent"}"
                                        ),
                                    Text('${model.data?.rent}'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: model.data!.nights!>29?true:false,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("House Rent Per month"
                                    ),
                                    Text('${model.data?.om_rent}'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: model.data!.nights!>29?true:false,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("PM(Property Management Fee)"
                                    ),
                                    Text('${model.data?.sa_rent}'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible:  model.data!.nights!>29?true:false,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[16].name : "Deposit (Fully Refunded)"}'),
                                    Text('${model.data?.deposit}'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: model.data!.nights!>29?10:0,
                              ),
                              Visibility(
                                visible: model.data?.refferalDiscount != 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[17].name : "Referral discount"}'),
                                    Text('${model.data?.refferalDiscount}'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                visible: model.data!.nights!>29?true:false,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width:250,
                                      child: const Text(
                                          'On-Boarding Charge(One Time Payable)'),
                                    ),
                                    Text('${model.data!.nights!>29?1000:0}'),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: model.data!.nights!>29?10:0,
                              ),
                              Visibility(
                                visible: model.data?.couponDiscount != 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${nullCheck(list: value.bookingAmountLang) ? value.bookingAmountLang[18].name : "Coupon discount"}'),
                                    Text('${model.data?.couponDiscount}'),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Pay ${model.data?.advanceAmount ?? 0} to Book the Property',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Pay ${model.data?.pendingAmount ?? 0} Before CheckIn',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
class BookingTypeDropDown extends StatefulWidget {
  var flexiRent;
  List bookingTypeData;
  var regularRent;

 BookingTypeDropDown({
 required this.flexiRent,required this.bookingTypeData, required this.regularRent,
});

  @override
  State<BookingTypeDropDown> createState() => _BookingTypeDropDownState();
}

class _BookingTypeDropDownState extends State<BookingTypeDropDown> {
  var bookingType;
  var bookingTypeDisplay;
  SharedPreferenceUtil util=SharedPreferenceUtil();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20,top: 20,bottom: 20,right: 20),
  height: MediaQuery.of(context).size.height/3,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Booking Type" ,style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,

                  color: Colors.grey),),
              Neumorphic(
                padding: EdgeInsets.only(left: 10),

                style: NeumorphicStyle(
                  depth: -3,
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      hint: Text("SELECT BOOKING TYPE"),
                      value: bookingTypeDisplay,
                      onChanged: (val) {
                        if(val=="Flexi Rent ${widget.flexiRent}"){
                          setState((){
                            bookingType="Short Term";
                            bookingTypeDisplay=val;
                          });
                        }
                        else{
                          setState((){
                            bookingType="Long Term";
                            bookingTypeDisplay=val;

                          });
                        }
                        print(">>>>  ${bookingType}");
                      }, items:
                widget.bookingTypeData.map((e) {return  DropdownMenuItem(child: Text(e.toString(),),

                    value: e.toString(),
                  );}

                  ).toList()

                  ),
                ),
              ),
            ],
          ),

          Container(
            width: double.infinity,
            //    color: CustomTheme.appThemeContrast,
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.all(Radius.circular(20)),
              color: CustomTheme.appThemeContrast,
            ),
            child: TextButton(onPressed: ()async{
await util.setString(rms_BookingType, bookingType);
Navigator.pop(context);
            },
                child: Text("Done",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),)),
          )
        ],
      ),
    );
  }
}
