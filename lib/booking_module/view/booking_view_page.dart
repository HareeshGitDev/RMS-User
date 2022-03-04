import 'dart:developer';

import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/color.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../images.dart';
import '../../property_details_module/model/property_details_util_model.dart';
import '../../utils/date_range/blackout_date_range.dart';

class BookingPage extends StatefulWidget {
  final PropertyDetailsUtilModel propertyDetailsUtilModel;

  BookingPage({Key? key,required this.propertyDetailsUtilModel}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateRangePickerNavigationMode _navigationMode =
      DateRangePickerNavigationMode.scroll;
  static const String fontFamily = 'hk-grotest';
  var _mainHeight;
  var _mainWidth;
  int _currentStep = 0;
  DateTime selectedDate = DateTime.now();
  String showDate = 'Select Date For Visit';
  String checkInDate=yyyyMMDDformatDate(DateTime.now());
  String checkOutDate=yyyyMMDDformatDate(DateTime.now().add(const Duration(days: 1)));
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();



  @override
  void initState() {
    super.initState();
    log('UTIL MODEL :: ${widget.propertyDetailsUtilModel.toJosn()}');
    _emailController.text=(widget.propertyDetailsUtilModel.email).toString();
    _nameController.text=(widget.propertyDetailsUtilModel.name).toString();
    _phoneNumberController.text=(widget.propertyDetailsUtilModel.mobile).toString();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    //return Consumer<BookingPage>(builder: (context, value, child){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.propertyDetailsUtilModel.buildingName ?? '',style: const TextStyle(
          fontFamily: fontFamily,


        ),),
        titleSpacing: 0,
        backgroundColor: CustomTheme.skyBlue,
      ),
      body: Container(
        color: Colors.white,
        height: _mainHeight,
        width: _mainWidth,
        padding: EdgeInsets.only(top: 20,),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "You Are almost Done !",
                style: TextStyle(fontSize: 24,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w500

                ),

              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(widget.propertyDetailsUtilModel.title ?? '',style: const TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,



                    ),textAlign: TextAlign.center,),
                    Container(
                     // color: Colors.amber,
                      height: _mainHeight*0.55,
                      margin: EdgeInsets.all(10),
                      child: Stepper(

                        /*controlsBuilder:
                            (BuildContext context, ControlsDetails details) {
                          return Container();
                        },*/
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
                        steps: <Step>[
                          Step(
                            isActive: true,
                            state: StepState.complete,
                            title: Text('Guest Name* (As per AAdhar)',style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: fontFamily,
                              color: Colors.grey

                            ),),
                            content: Container(
                                decoration: BoxDecoration(
                                 borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.amber,
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
                                  style: TextStyle(
                                      fontFamily: fontFamily
                                  ),

                                   controller: _nameController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    //hintText: 'Email',
                                    prefixIcon: Icon(Icons.drive_file_rename_outline),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Step(
                            isActive: true,
                            state: StepState.complete,
                            title: Text('Guest Mobile*',style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: fontFamily,
                                color: Colors.grey

                            ),),
                            content: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                color: Colors.amber,
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
                                  style: TextStyle(
                                      fontFamily: fontFamily
                                  ),
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
                            title:  Text('Guest Email*',style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: fontFamily,
                                color: Colors.grey

                            ),),
                            content: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                color: Colors.amber,
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
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,style: TextStyle(
                                  fontFamily: fontFamily
                                ),
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
                            title:  Text('Select Date',style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: fontFamily,
                                color: Colors.grey

                            ),),
                            state: StepState.editing,
                            content: GestureDetector(
                              onTap: () async {
                                PickerDateRange? dateRange =
                                    await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                  builder: (context) => const SelectDates(),
                                ));
                                if(dateRange != null){
                                 setState(() {
                                   checkInDate=yyyyMMDDformatDate(dateRange.startDate ?? DateTime.now());
                                   checkOutDate=yyyyMMDDformatDate(dateRange.endDate ?? DateTime.now().add(const Duration(days: 1)));
                                 });
                                }
                              },
                              child: Container(

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.blueGrey.shade100),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.only(left: 15),

                                height: 180,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('CheckIn Date'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(checkInDate),
                                    Spacer(),
                                    SizedBox(
                                        height: 40,
                                        child: VerticalDivider(width: 40,thickness: 1,color: Colors.grey,endIndent: 1,indent: 1,)),

                                    Text('24 Days'),

                                    SizedBox(
                                        height: 40,
                                        child: VerticalDivider(width: 40,thickness: 1,color: Colors.grey,endIndent: 1,indent: 1,)),
                                    Spacer(),
                                    Text('CheckOut Date'),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(checkOutDate),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          Step(
                            isActive: true,
                            title:  Text('Guests',style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: fontFamily,
                                color: Colors.grey

                            ),),
                            state: StepState.editing,
                            content: Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Text('2 Guests'),
                            ),
                          ),
                          Step(
                            isActive: true,
                            title: const Text('Referral Code',style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: fontFamily,
                                color: Colors.grey

                            ),),
                            state: StepState.editing,
                            content: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                color: Colors.amber,
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
                                  keyboardType: TextInputType.emailAddress,
                                  // controller: _emailController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    //hintText: 'Email',
                                    prefixIcon: Icon(Icons.monetization_on_outlined),
                                  ),
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
      ),
      bottomNavigationBar: Container(
        height: _mainHeight*0.06,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: _mainWidth*0.05, right: _mainWidth*0.05, bottom: _mainHeight*0.01),

        child: SizedBox(
            width: _mainWidth*0.4,
            height: _mainHeight*0.05,
            child: ElevatedButton(
              onPressed: () async {

              },
              child: Text('Proceed Booking',style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 16,

              ),),
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(
                      CustomTheme.skyBlue),
                  shape: MaterialStateProperty.all<
                      RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10)),
                  )),
            )),
      ),
    );
    //}
    //);;
  }



  static String zeroMonth(DateTime text) =>
      text.month < 10 ? '0${text.month}' : text.month.toString();

  static String zeroDay(DateTime text) =>
      text.day < 10 ? '0${text.day}' : text.day.toString();

  static String yyyyMMDDformatDate(DateTime text) =>
      '${text.year}-${zeroMonth(text)}-${zeroDay(text)}';
}

class SelectDates extends StatefulWidget {
  const SelectDates({Key? key}) : super(key: key);

  @override
  _SelectDatesState createState() => _SelectDatesState();
}

class _SelectDatesState extends State<SelectDates> {
  DateRangePickerNavigationMode _navigationMode =
      DateRangePickerNavigationMode.scroll;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Moving/MoveOut Date'),
        titleSpacing: 0,
        backgroundColor: CustomTheme.skyBlue,
      ),
      body: Container(
        child: _getDates(context: context),
      ),
    );
  }

  Widget _getDates({required BuildContext context}) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: SfDateRangePicker(
        enableMultiView: true,
        endRangeSelectionColor: CustomTheme.peach,
        startRangeSelectionColor: CustomTheme.peach,
        confirmText: 'SELECT',
        onCancel: () => Navigator.pop(context),
        onSubmit: (dynamic data) {
          if (data is PickerDateRange &&
              data.startDate != null &&
              data.endDate != null) {
            Navigator.pop(context, data);
          } else {
            RMSWidgets.showSnackbar(
                context: context,
                message: 'Please Select Valid Date Range',
                color: Colors.red);
          }
        },
        initialSelectedRange: PickerDateRange(
            DateTime.now(), DateTime.now().add(const Duration(days: 1))),
        todayHighlightColor: myFavColor,
        selectionShape: DateRangePickerSelectionShape.rectangle,
        showActionButtons: true,
        headerStyle: DateRangePickerHeaderStyle(
            backgroundColor: Theme.of(context).cardTheme.color),
        navigationDirection: DateRangePickerNavigationDirection.vertical,
        selectionMode: DateRangePickerSelectionMode.range,
        monthViewSettings:
            const DateRangePickerMonthViewSettings(enableSwipeSelection: false),
        showNavigationArrow: false,
        navigationMode: _navigationMode,
      ),
    );
  }
}
