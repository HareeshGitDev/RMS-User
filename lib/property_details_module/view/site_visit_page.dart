import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/property_details_module/viewModel/property_details_viewModel.dart';
import 'package:RentMyStay_user/theme/fonts.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../images.dart';
import '../../theme/custom_theme.dart';

class SiteVisitPage extends StatefulWidget {
  final String propId;
  final String name;
  final String phoneNumber;
  final String email;

  SiteVisitPage(
      {Key? key,
      required this.propId,
      required this.name,
      required this.email,
      required this.phoneNumber})
      : super(key: key);

  @override
  State<SiteVisitPage> createState() => SiteVisitPagestate();
}

class SiteVisitPagestate extends State<SiteVisitPage> {
  var _mainHeight;
  var _mainWidth;

  @override
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _nameController.text = widget.name;
    _phoneNumberController.text = widget.phoneNumber;
    _emailController.text = widget.email;
  }

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String showDate = 'Select Date For Visit';
  String typeValue = 'HH:MM';

  final List<bool> _selected = [
    true,
    false,
  ];
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
  void dispose() {
    _connectivitySubs.cancel();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus
        ? Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: _mainWidth,
              padding: EdgeInsets.all(_mainHeight * 0.015),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "SCHEDULE SITE VISIT",
                        style: TextStyle(
                            fontSize: getHeight(context: context, height: 18),
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FilterChip(
                            selected: _selected[0],
                            label: Container(
                              height: _mainHeight * 0.025,
                              child: Text(

                                'Virtual Visit',textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: _selected[0]
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: getHeight(context: context, height: 14)),
                              ),
                            ),
                            elevation: 2,
                            checkmarkColor:
                                _selected[0] ? Colors.white : Colors.black,
                            selectedColor: CustomTheme.appTheme,
                            backgroundColor: CustomTheme.white,
                            pressElevation: 1,
                            onSelected: (bool selected) {
                              if (selected == true) {
                                setState(() {
                                  _selected[0] = true;
                                  _selected[1] = false;
                                });
                              }
                            }),
                        FilterChip(
                            selected: _selected[1],
                            label: Container(
                              height: _mainHeight * 0.025,
                              child: Text(
                                'Physical Visit',
                                style: TextStyle(
                                    color: _selected[1]
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: getHeight(context: context, height: 14)),
                              ),
                            ),
                            elevation: 2,
                            checkmarkColor:
                                _selected[1] ? Colors.white : Colors.black,
                            selectedColor: CustomTheme.appTheme,
                            backgroundColor: CustomTheme.white,
                            pressElevation: 1,
                            onSelected: (bool selected) {
                              if (selected == true) {
                                setState(() {
                                  _selected[0] = false;
                                  _selected[1] = true;
                                });
                              }
                            }),
                      ],
                    ),
                    SizedBox(
                      height: _mainHeight * 0.01,
                    ),
                    Container(
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
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Name",
                            prefixIcon: Icon(Icons.person_outline,
                                color: Colors.grey, size: _mainHeight*0.022),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _mainHeight * 0.01,
                    ),
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
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,

                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "E-mail",
                            prefixIcon: Icon(Icons.email_outlined,
                                color: Colors.grey,  size: _mainHeight*0.022),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _mainHeight * 0.01,
                    ),
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
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone Number",
                            prefixIcon: Icon(Icons.phone_android_outlined,
                                color: Colors.grey,  size: _mainHeight*0.022),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _mainHeight * 0.01,
                    ),
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: -2,
                        color: Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? _date = await _pickDate(context);
                          if (_date != null) {
                            selectedDate = _date;
                            setState(() {
                              showDate = yyyyMMDDformatDate(selectedDate);
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              left: _mainWidth * 0.04,
                              right: _mainWidth * 0.04),
                          color: Colors.white,

                          height: _mainHeight * 0.060,
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_sharp,
                                color: Colors.grey,
                                size: _mainHeight*0.022,

                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(showDate),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _mainHeight * 0.01,
                    ),
                    Container(
                      height: _mainHeight * 0.060,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Neumorphic(
                        style: NeumorphicStyle(
                          depth: -2,
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            menuMaxHeight: _mainHeight * 0.8,
                            items: getTimeList
                                .map((type) => DropdownMenuItem(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: _mainWidth * 0.04,
                                    right: _mainWidth * 0.04),
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.alarm,
                                      color: Colors.grey,
                                      size: _mainHeight*0.022,

                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(type),
                                  ],
                                ),
                              ),
                              value: type,
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                typeValue = value.toString();
                              });
                            },
                            value: typeValue,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _mainHeight * 0.02,
                    ),
                    Center(
                      child: Container(
                        width: _mainWidth * 0.3,
                        height: _mainHeight * 0.04,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                CustomTheme.appTheme),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          onPressed: () async {
                            String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
                                "\\@" +
                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                                "(" +
                                "\\." +
                                "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
                                ")+";
                            RegExp regExp = RegExp(p);
                            if (_nameController.text.isEmpty) {
                              RMSWidgets.getToast(
                                  message: 'Please Enter Your Name',
                                  color: Colors.grey);
                              return;
                            }
                            if (_emailController.text.isEmpty ||
                                !regExp.hasMatch(_emailController.text)) {
                              RMSWidgets.getToast(
                                  message:
                                      'Please Enter Your Valid Email Address',
                                  color: Colors.grey);
                              return;
                            }
                            if (_phoneNumberController.text.isEmpty ||
                                _phoneNumberController.text.length < 10 ||
                                _phoneNumberController.text.length > 12) {
                              RMSWidgets.getToast(
                                  message:
                                      'Please Enter Your Correct Mobile Number',
                                  color: Colors.grey);
                              return;
                            }
                            if (showDate == 'Select Date For Visit' ||
                                typeValue == 'HH:MM') {
                              RMSWidgets.getToast(
                                  message: 'Please Select Date And Time',
                                  color: Colors.grey);
                              return;
                            }
                            RMSWidgets.showLoaderDialog(
                                context: context, message: 'Please wait...');
                            final viewModel =
                                Provider.of<PropertyDetailsViewModel>(context,
                                    listen: false);
                            int response = await viewModel.scheduleSiteVisit(
                              email: _emailController.text,
                              name: _nameController.text,
                              propId: widget.propId,
                              phoneNumber: _phoneNumberController.text,
                              date: '$typeValue   $showDate',
                              visitType: _selected[0] == true
                                  ? 'Virtual Visit'
                                  : 'Physical Visit',
                            );

                            Navigator.of(context).pop();
                            if (response == 200) {
                              Navigator.of(context).pop();
                              RMSWidgets.showSnackbar(
                                  context: context,
                                  message:
                                      'Congratulations,Your Site Visit is Scheduled.',
                                  color: CustomTheme.appTheme);
                            }
                          },
                          child: Center(child: Text("Confirm Visit")),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : RMSWidgets.networkErrorPage(context: context);
  }

  Widget _textInput(
      {required TextEditingController controller,
      required String hint,
      required IconData icon}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: -10,
          color: Colors.white,
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            prefixIcon: Icon(icon),
          ),
        ),
      ),
    );
  }

  List<String> get getTimeList => [
        'HH:MM',
        '08:00 AM',
        '09:00 AM',
        '10:00 AM',
        '11:00 AM',
        '12:00 PM',
        '01:00 PM',
        '02:00 PM',
        '03:00 PM',
        '04:00 PM',
        '05:00 PM',
        '06:00 PM',
        '07:00 PM',
        '08:00 PM',
      ];

  Future<DateTime?> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        confirmText: 'Selected',
        cancelText: 'Cancel',
        helpText: 'Date for Site Visit',
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      return picked;
    }
  }

  String zeroMonth(DateTime text) =>
      text.month < 10 ? '0${text.month}' : text.month.toString();

  String zeroDay(DateTime text) =>
      text.day < 10 ? '0${text.day}' : text.day.toString();

  String yyyyMMDDformatDate(DateTime text) =>
      '${text.year}-${zeroMonth(text)}-${zeroDay(text)}';
}
