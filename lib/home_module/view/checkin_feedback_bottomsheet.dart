import 'dart:developer';

import 'package:RentMyStay_user/home_module/viewModel/home_viewModel.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../theme/custom_theme.dart';

class CheckInFeedbackBottomSheet extends StatefulWidget {
  final String booking_id;
  final String buildingName;
  final String check_in;
  const CheckInFeedbackBottomSheet({Key? key,
    required this.buildingName,
    required this.booking_id,required this.check_in}) : super(key: key);

  @override
  State<CheckInFeedbackBottomSheet> createState() =>
      _CheckInFeedbackBottomSheetState();
}

class _CheckInFeedbackBottomSheetState
    extends State<CheckInFeedbackBottomSheet> {
  double bookingExperience=0;
  double checkInExperience=0;
  var bq1;
  var bq2;
  var bq3;
  var cq1;
  var cq2;
  var cq3;
  bool bq1Bool=false;
  bool bq2Bool=false;
  bool bq3Bool=false;
  bool cq1Bool=false;
  bool cq2Bool=false;
  bool cq3Bool=false;
TextEditingController comment=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(

            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(35))),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Check-in to",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.clear,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${widget.buildingName}",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${widget.check_in}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    "Your Opinion matters to us!!!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: CustomTheme.appThemeContrast2,

                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "How was your Booking Experience",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width,
                  child: RatingBar.builder(
                    //initialRating: 4,
                    itemCount: 5,
                    glow: true,
                    maxRating: 5.0,
                    itemSize: MediaQuery.of(context).size.height * 0.045,
                    itemPadding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.04),
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return Icon(
                            Icons.sentiment_very_dissatisfied,
                            color:
                            CustomTheme.appThemeContrast.withAlpha(150),
                          );
                        case 1:
                          return Icon(
                            Icons.sentiment_dissatisfied,
                            color:
                            CustomTheme.appThemeContrast.withAlpha(200),
                          );
                        case 2:
                          return Icon(
                            Icons.sentiment_neutral,
                            color:
                            CustomTheme.appThemeContrast.withAlpha(210),
                          );
                        case 3:
                          return Icon(
                            Icons.sentiment_satisfied,
                            color:
                            CustomTheme.appThemeContrast.withAlpha(230),
                          );
                        case 4:
                          return Icon(
                            Icons.sentiment_very_satisfied,
                            color: CustomTheme.appThemeContrast,
                          );
                        default:
                          return Container();
                      }
                    },
                    onRatingUpdate: (double rating) {
                      setState(() {
                        bookingExperience = rating * 1;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Visibility(
                    visible:
                    bookingExperience != null && bookingExperience <= 3,
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Text("Was the sales representative unprofessional"),
                          value: bq1Bool,
                          onChanged: (bool? value) { setState((){

                            bq1Bool =value!;
                            log("Data $bq1Bool");
                            if(value !=null && value==true) {
                              bq1 =
                              "Unprofessional ";
                            }
                            else{
                              bq1="";
                            }
                          }); },

                        ),
                        CheckboxListTile(
                          title: Text("Didnt Explain the term and Policies"), value: bq2Bool,

                          onChanged: (bool? value) {

                            setState((){
                              bq2Bool=value!;
                              if(value !=null && value==true) {
                                bq2 =
                                "t&c ";
                              }
                              else{
                                bq2="";
                              }
                            });
                          },

                        ),
                        CheckboxListTile(
                          title: Text("No proper support"), value: bq3Bool, onChanged: (bool? value) {
                          log("oye");
                          setState((){
                            bq3Bool=value!;
                            if(value !=null && value==true) {
                              bq3 =
                              "no proper response ";
                            }
                            else{
                              bq3="";
                            }
                          });
                        },

                        ),
                      ],
                    )
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "How was your Check-in Experience",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width,
                  child: RatingBar.builder(
                    //initialRating: 4,
                    itemCount: 5,
                    glow: true,
                    maxRating: 5.0,
                    itemSize: MediaQuery.of(context).size.height * 0.045,
                    itemPadding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.04),
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return Icon(
                            Icons.sentiment_very_dissatisfied,
                            color:
                            CustomTheme.appThemeContrast.withAlpha(150),
                          );
                        case 1:
                          return Icon(
                            Icons.sentiment_dissatisfied,
                            color:
                            CustomTheme.appThemeContrast.withAlpha(200),
                          );
                        case 2:
                          return Icon(
                            Icons.sentiment_neutral,
                            color:
                            CustomTheme.appThemeContrast.withAlpha(210),
                          );
                        case 3:
                          return Icon(
                            Icons.sentiment_satisfied,
                            color:
                            CustomTheme.appThemeContrast.withAlpha(230),
                          );
                        case 4:
                          return Icon(
                            Icons.sentiment_very_satisfied,
                            color: CustomTheme.appThemeContrast,
                          );
                        default:
                          return Container();
                      }
                    },
                    onRatingUpdate: (double rating) {
                      setState(() {
                        checkInExperience = rating * 1;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Visibility(
                    visible:
                    checkInExperience != null && checkInExperience <= 3,
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Text("Caretaker not available during check-in"),
                          value: cq1Bool,
                          onChanged: (bool? value) { setState((){

                            cq1Bool =value!;
                            log("Data $cq1Bool");
                            if(value !=null && value==true) {
                              cq1 =
                              "CT not available, ";
                            }
                            else{
                              cq1="";
                            }
                          }); },

                        ),
                        CheckboxListTile(
                          title: Text("Cleanliness of the room"), value: cq2Bool,

                          onChanged: (bool? value) {

                            setState((){
                              cq2Bool=value!;
                              if(value !=null && value==true) {
                                cq2 =
                                "Cleanliness of the room ";
                              }
                              else{
                                cq2="";
                              }
                            });
                          },

                        ),
                        CheckboxListTile(
                          title: const Text("Amenities Promised not given"), value: cq3Bool,
                          onChanged: (bool? value) {
                            log("oye");
                            setState((){
                              cq3Bool=value!;
                              if(value !=null && value==true) {
                                cq3 =
                                "Amenities not provided";
                              }
                              else{
                                cq3="";
                              }
                            });
                          },

                        ),
                      ],
                    )

                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:  EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextFormField(
                    maxLines: 3,
                    controller: comment,
                    decoration: InputDecoration(

                   hintText: "Enter Comments",
                    fillColor: Colors.white,

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: CustomTheme.appThemeContrast2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                  )
                  ),
                ),

                bookingExperience !=null && checkInExperience !=null ? SizedBox(height: 20,):Container(),
                bookingExperience !=null && checkInExperience  !=null ?Container(
                  width:double.infinity,
                 decoration: BoxDecoration(
                   color: CustomTheme.appThemeContrast,
                   borderRadius: BorderRadius.all(Radius.circular(17))
                 ),
                  child: TextButton(

                  onPressed: () async{
                    RMSWidgets.showLoaderDialog(context: context, message: "Sharing your response");
                    HomeViewModel _homeViewModel=HomeViewModel();
                 var response=await   _homeViewModel.checkinFeedbackPost(context: context,
                     booking_rating: bookingExperience,

                     check_in_rating: checkInExperience, check_in_comment: cq1+cq2+cq3, sales_comment: bq1+bq2+bq3, comment: comment.text, booking_id: widget.booking_id);

                Navigator.pop(context);
                Navigator.pop(context);
                if(response==200) {
                  RMSWidgets.getToast(
                      message: "Your review is submitted Thank you",
                      color: Colors.green);
                }
                else{
                  RMSWidgets.getToast(
                      message: "Sorry Review could not be sent!!!",
                      color: Colors.red);
                }
                },

                child: const Text("Submit Review",style: TextStyle(

                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),),
                ),):Container(),
                bookingExperience !=null && checkInExperience !=null ? SizedBox(height: 20,):Container(),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
