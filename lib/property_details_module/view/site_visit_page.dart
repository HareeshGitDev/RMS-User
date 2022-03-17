import 'dart:developer';


import 'package:RentMyStay_user/property_details_module/viewModel/property_details_viewModel.dart';
import 'package:RentMyStay_user/utils/color.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutx/themes/text_style.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/button/button.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../images.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/date_range/blackout_date_range.dart';
import '../../utils/date_range/simple_date_range.dart';
import '../../utils/service/shared_prefrences_util.dart';

class SiteVisitPage extends StatefulWidget {
  final String propId;
  final String name;
  final String phoneNumber;
  final String email;


  SiteVisitPage({Key? key, required this.propId,required this.name,required this.email,required this.phoneNumber}) : super(key: key);

  @override
  State<SiteVisitPage> createState() => SiteVisitPagestate();
}

class SiteVisitPagestate extends State<SiteVisitPage> {
  @override
  void initState() {
    _nameController.text=widget.name;
    _phoneNumberController.text=widget.phoneNumber;
    _emailController.text=widget.email;
    super.initState();
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
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Center(
                child: Text(
                  "Site Visit",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Center(
                child: Text(
                  "Fill up to schedule a visit to a Place ",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    child: FilterChip(
                        selected: _selected[0],
                        label: Text('Virtual visit'),
                        elevation: 10,
                        selectedColor: CustomTheme.peach,
                        pressElevation: 5,
                        onSelected: (bool selected) {
                          if (selected == true) {
                            setState(() {

                              _selected[0] = true;
                              _selected[1] = false;
                            });
                          }
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: FilterChip(
                        selected: _selected[1],
                        selectedColor: CustomTheme.peach,
                        label: Text('Physical visit'),
                        elevation: 10,
                        pressElevation: 5,
                        onSelected: (bool selected) {
                          if (selected == true) {
                            setState(() {
                              _selected[0] = false;
                              _selected[1] = true;
                            });
                          }
                        }),
                  ),
                  // Container(padding: EdgeInsets.all(5),decoration: BoxDecoration(border:Border.all(color: CustomTheme.skyBlue),borderRadius: BorderRadius.all(Radius.circular(20)) ),margin: EdgeInsets.all(10),child: Text("Virtual SiteVisit")),
                  //Container(padding: EdgeInsets.all(5),decoration: BoxDecoration(border:Border.all(color: CustomTheme.skyBlue),borderRadius: BorderRadius.all(Radius.circular(20)) ),margin: EdgeInsets.all(10),child: Text("Physical SiteVisit")),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 45,
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Name",
                        prefixIcon: Icon(Icons.person_outline,
                            color: Colors.grey, size: 20),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 45,
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
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "E-mail",
                      prefixIcon: Icon(Icons.email_outlined,
                          color: Colors.grey, size: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 45,
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
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Phone Number",
                      prefixIcon: Icon(Icons.phone_android_outlined,
                          color: Colors.grey, size: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Neumorphic(
                style: NeumorphicStyle(
                  depth: -10,
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
                    padding: EdgeInsets.only(left: 15),
                    color: Colors.white,
                    height: 45,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_sharp,
                          color: Colors.grey,
                          size: 20,
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
                height: 15,
              ),
              Container(
                width: 100,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: CustomTheme.peach,

                  borderRadius: BorderRadius.all(Radius.circular(20)),


                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Container(),
                    elevation: 10,
                    menuMaxHeight: 300,
                    items: getTimeList
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
                        typeValue = value.toString();
                      });
                    },
                    value: typeValue,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: 150,
                  height: 50,
                  margin: EdgeInsets.only(bottom: 5, top: 15),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(CustomTheme.appTheme),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    onPressed: () async {
                      if(_nameController.text.isEmpty){
                        RMSWidgets.getToast(message: 'Please Enter Your Name', color: Colors.grey);
                      }
                      else{
                        if(_emailController.text.isEmpty){
                          RMSWidgets.getToast(message: 'Please Enter Your Email Address', color: Colors.grey);
                        }
                        else{
                          if(_phoneNumberController.text.isEmpty){
                            RMSWidgets.getToast(message: 'Please Enter Your Mobile Number', color: Colors.grey);
                          }
                          else{
                            if(showDate=='Select Date For Visit' || typeValue=='HH:MM')
                              {
                                RMSWidgets.getToast(message: 'Please Select Date And Time', color: Colors.grey);
                              }
                            else{
                              RMSWidgets.showLoaderDialog(context: context, message: 'Please wait...');
                              SharedPreferenceUtil _shared = SharedPreferenceUtil();
                              String? token =
                              await _shared.getString(rms_registeredUserToken);

                              Map<String, dynamic> scheduleVisitData = {
                                'email': _emailController.text,
                                'propid': widget.propId,
                                'name': _nameController.text,
                                'app_token': token,
                                'phone': _phoneNumberController.text,
                                'date': '$typeValue   $showDate',
                                'visit_type': _selected[0] == true
                                    ? 'Virtual Visit'
                                    : 'Physical Visit',
                              };
                              final viewModel = Provider.of<PropertyDetailsViewModel>(
                                  context,
                                  listen: false);
                              String response = await viewModel.scheduleSiteVisit(
                                  scheduleVisitData: scheduleVisitData);

                              Navigator.of(context).pop();
                              if(response.toLowerCase() =='success'){
                                Navigator.of(context).pop();
                                RMSWidgets.showSnackbar(context: context, message: 'Congratulations,Your Site Visit is Scheduled.', color: CustomTheme.appTheme);
                                log('Response From Site Visit is :: $response');
                              }
                            }

                          }
                        }
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
    );
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
