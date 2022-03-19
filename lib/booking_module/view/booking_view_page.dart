import 'dart:developer';
import 'dart:ui';

import 'package:RentMyStay_user/Web_View_Container.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_amount_request_model.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_amounts_response_model.dart';
import 'package:RentMyStay_user/property_details_module/model/booking_credential_response_model.dart';
import 'package:RentMyStay_user/property_details_module/viewModel/property_details_viewModel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/color.dart';
import 'package:RentMyStay_user/utils/constants/app_consts.dart';
import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../images.dart';
import '../../property_details_module/model/property_details_util_model.dart';
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
  static const String fontFamily = 'hk-grotest';
  var _mainHeight;
  var _mainWidth;
  int _currentStep = 0;

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
  late Razorpay _razorpay;
  BookingCredentialResponseModel _bookingCredentialResponseModel =
      BookingCredentialResponseModel();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _viewModel = Provider.of<PropertyDetailsViewModel>(context, listen: false);
    initMethod();
  }

  Future<void> initMethod() async {
    _emailController.text = (widget.propertyDetailsUtilModel.email).toString();
    _nameController.text = (widget.propertyDetailsUtilModel.name).toString();
    _phoneNumberController.text =
        (widget.propertyDetailsUtilModel.mobile).toString();
    SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();
    checkInDate = await preferenceUtil.getString(rms_checkInDate) ??
        DateTimeService.ddMMYYYYformatDate(DateTime.now());
    checkOutDate = await preferenceUtil.getString(rms_checkOutDate) ??
        DateTimeService.ddMMYYYYformatDate(
            DateTime.now().add(const Duration(days: 1)));
    _viewModel.getBookingDetails(
        model: BookingAmountRequestModel(
      propId: (widget.propertyDetailsUtilModel.propId).toString(),
      token: (widget.propertyDetailsUtilModel.token).toString(),
      numOfGuests: (widget.propertyDetailsUtilModel.maxGuest).toString(),
      couponCode: '',
      fromDate: checkInDate,
      toDate: checkOutDate,
    ));
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    //return Consumer<BookingPage>(builder: (context, value, child){
    return Consumer<PropertyDetailsViewModel>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              widget.propertyDetailsUtilModel.buildingName ?? '',
              style: const TextStyle(
                fontFamily: fontFamily,
              ),
            ),
            titleSpacing: 0,
            backgroundColor: CustomTheme.appTheme,
          ),
          body: Container(
            height: _mainHeight,
            width: _mainWidth,
            padding: EdgeInsets.only(
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "You Are almost Done !",
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            widget.propertyDetailsUtilModel.title ?? '',
                            style: const TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          // color: Colors.amber,
                          // height: _mainHeight*0.55,
                          margin: EdgeInsets.only(top: 10, bottom: 10),
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
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _currentStep += 1;
                                          });
                                        },
                                        child: Text('Continue'),
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
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_currentStep <= 0) return;
                                          setState(() {
                                            _currentStep -= 1;
                                          });
                                        },
                                        child: Text('Cancel'),
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
                                  'Select Date',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: fontFamily,
                                      color: Colors.grey),
                                ),
                                state: StepState.complete,
                                content: _getSelectDateView(
                                    context: context,
                                    model: value.bookingAmountsResponseModel),
                              ),
                              Step(
                                isActive: true,
                                state: StepState.complete,
                                title: Text(
                                  'Guest Name* (As per Aadhar)',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: fontFamily,
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
                                      style: TextStyle(fontFamily: fontFamily),
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                            Icons.drive_file_rename_outline),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Step(
                                isActive: true,
                                state: StepState.complete,
                                title: Text(
                                  'Guest Mobile*',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: fontFamily,
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

                                      keyboardType: TextInputType.phone,
                                      controller: _phoneNumberController,
                                      style: TextStyle(fontFamily: fontFamily),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,

                                        //hintText: 'Email',
                                        prefixIcon: Icon(Icons.mobile_friendly),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Step(
                                isActive: true,
                                state: StepState.complete,
                                title: Text(
                                  'Guest Email*',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: fontFamily,
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
                                      enabled: false,
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _emailController,
                                      style: TextStyle(fontFamily: fontFamily),
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
                                  '${widget.propertyDetailsUtilModel.maxGuest} Guests',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: fontFamily,
                                      color: Colors.grey),
                                ),
                                state: StepState.editing,
                                content: Container(
                                  margin: EdgeInsets.only(left: 8),
                                ),
                              ),
                              Step(
                                isActive: true,
                                title: const Text(
                                  'Coupan Code',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: fontFamily,
                                      color: Colors.grey),
                                ),
                                state: StepState.editing,
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
                                            hintText: 'Enter coupan code here',
                                            prefixIcon: Icon(
                                                Icons.monetization_on_outlined),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        RMSWidgets.showLoaderDialog(
                                            context: context,
                                            message: 'Loading...');

                                        await _viewModel.getBookingDetails(
                                            model: BookingAmountRequestModel(
                                          propId: (widget
                                                  .propertyDetailsUtilModel
                                                  .propId)
                                              .toString(),
                                          token: (widget
                                                  .propertyDetailsUtilModel
                                                  .token)
                                              .toString(),
                                          numOfGuests: (widget
                                                  .propertyDetailsUtilModel
                                                  .maxGuest)
                                              .toString(),
                                          couponCode: _coupanController.text,
                                          fromDate: checkInDate,
                                          toDate: checkOutDate,
                                        ));
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        Navigator.of(context).pop();

                                        RMSWidgets.showSnackbar(
                                            context: context,
                                            message: (value
                                                .bookingAmountsResponseModel
                                                .message)!,
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
                                                    BorderRadius.circular(10)),
                                          )),
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
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    _showBreakdownBottomSheet(
                        context: context,
                        model: value.bookingAmountsResponseModel);
                  },
                  child: Container(
                    height: 30,
                    color: Colors.blueGrey.shade50,
                    alignment: Alignment.center,
                    width: _mainWidth,
                    child: RichText(
                        text: TextSpan(
                            text: 'Click to see ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                fontFamily: fontFamily,
                                color: Colors.black),
                            children: <TextSpan>[
                          TextSpan(
                            text: ' Price BreakDown',
                            style: TextStyle(
                              color: myFavColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: fontFamily,
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
                            '$rupee ${value.bookingAmountsResponseModel.amountPayable ?? 0}',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text('Payable Amount'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: _mainHeight * 0.06,
                        width: MediaQuery.of(context).size.width * 0.68,
                        child: ElevatedButton(
                          onPressed: () async {
                            RMSWidgets.showLoaderDialog(
                                context: context, message: 'Loading');
                            BookingCredentialResponseModel response =
                                await _viewModel.getBookingCredentials(
                                    model: BookingAmountRequestModel(
                              propId: (widget.propertyDetailsUtilModel.propId)
                                  .toString(),
                              token: (widget.propertyDetailsUtilModel.token)
                                  .toString(),
                              numOfGuests:
                                  (widget.propertyDetailsUtilModel.maxGuest)
                                      .toString(),
                              couponCode: '',
                              fromDate: checkInDate,
                              toDate: checkOutDate,
                              email: _emailController.text,
                              name: _nameController.text,
                              phone: _phoneNumberController.text,
                              depositAmount: value.bookingAmountsResponseModel
                                          .amountPayable !=
                                      null
                                  ? value
                                      .bookingAmountsResponseModel.amountPayable
                                      .toString()
                                  : '',
                            ));

                            Navigator.pop(context);

                            if (response.status?.toLowerCase() == 'success' &&
                                response.data != null &&
                                response.data?.redirect_api != null) {
                              _bookingCredentialResponseModel = response;
                              await openCheckout(model: response);
                            }
                          },
                          child: Text(
                            'Proceed Booking',
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 16,
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  CustomTheme.appTheme),
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
    );
  }

  Future<void> openCheckout(
      {required BookingCredentialResponseModel model}) async {
    if (model.data == null) {
      return;
    }
    var options = {
      'key': model.data?.key,
      'amount': model.data?.amount,
      'order_id': model.data?.orderId,
      'image': model.data?.image,
      'name': model.data?.name,
      'description': model.data?.description,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      "theme": {
        "color": model.data?.theme?.color,
      },
      'prefill': {
        'contact': model.data?.prefill?.contact,
        'email': model.data?.prefill?.email
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      log('Error :: ' + e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (response.orderId != null &&
        response.signature != null &&
        response.paymentId != null) {
      RMSWidgets.showLoaderDialog(
          context: context, message: 'Confirmation Pending...');
      await _viewModel
          .submitPaymentResponse(
              paymentId: response.paymentId!,
              paymentSignature: response.signature!,
              redirectApi:
                  _bookingCredentialResponseModel.data?.redirect_api ?? '')
          .then((value) {
        Navigator.of(context).pop();
        return Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.paymentStatusPage, (route) => false,
            arguments: {
              'status': 'success',
              'paymentId': response.paymentId,
              'amount': _bookingCredentialResponseModel.data?.amount.toString(),
              'buildingName': widget.propertyDetailsUtilModel.buildingName,
              'title': widget.propertyDetailsUtilModel.title,
            });
      }).catchError(
        (error) {
          Navigator.of(context).pop();
          log('Error :: ${error.toString()}');
        },
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.paymentStatusPage, (route) => false,
        arguments: {
          'status': 'failed',
          'amount': _bookingCredentialResponseModel.data?.amount.toString(),
          'buildingName': widget.propertyDetailsUtilModel.buildingName,
          'title': widget.propertyDetailsUtilModel.title,
        });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
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
      required BookingAmountsResponseModel model}) {
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
          RMSWidgets.showLoaderDialog(context: context, message: 'Loading...');

          checkInDate = DateTimeService.ddMMYYYYformatDate(
              dateRange.startDate ?? DateTime.now());
          checkOutDate = DateTimeService.ddMMYYYYformatDate(
              dateRange.endDate ?? DateTime.now().add(const Duration(days: 1)));

          await _viewModel.getBookingDetails(
              model: BookingAmountRequestModel(
            propId: (widget.propertyDetailsUtilModel.propId).toString(),
            token: (widget.propertyDetailsUtilModel.token).toString(),
            numOfGuests: (widget.propertyDetailsUtilModel.maxGuest).toString(),
            couponCode: '',
            fromDate: checkInDate,
            toDate: checkOutDate,
          ));
          Navigator.of(context).pop();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blueGrey.shade100),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.only(left: _mainWidth * 0.02, top: 10, bottom: 10),
        height: _mainHeight * 0.26,
        width: MediaQuery.of(context).size.width,
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
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Text(
                    'Edit',
                    style: TextStyle(color: CustomTheme.peach),
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
                    Text(
                        '${model.nights != null ? model.nights.toString() : 0} Nights'),
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
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    'Edit',
                    style: TextStyle(color: CustomTheme.peach),
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
      required BookingAmountsResponseModel model}) {
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
              padding: FxSpacing.fromLTRB(24, 24, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'See Payment BreakDown',
                        style: TextStyle(
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Unit Rent"),
                                  Text(model.totalAmount.toString()),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Deposite (Fully Refunded)"),
                                  Text(model.deposit.toString()),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Refferal discount"),
                                  Text(model.refferalDiscount.toString()),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("coupon discount"),
                                  Text(model.couponDiscount.toString()),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Pay ${model.amountPayable ?? 0} to Book the Property',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Pay ${model.amountRemaining ?? 0} Before CheckIn',
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
