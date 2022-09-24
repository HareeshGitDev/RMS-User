import 'dart:developer';

import 'dart:io';

import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/custom_theme.dart';
import '../../utils/service/capture_photos_page.dart';

class CheckOutForm extends StatefulWidget {
  String bookingId;
  CheckOutForm({required this.bookingId});

  @override
  State<CheckOutForm> createState() => _CheckOutFormState();
}

class _CheckOutFormState extends State<CheckOutForm> {
  var paymentType;
  var careTakerReview;
  TextEditingController careTakerCommentController=TextEditingController();
  bool ?isRefundUpdated;

  TextEditingController accountHolderNumber=TextEditingController();
  TextEditingController accountHolderName=TextEditingController();
  TextEditingController ifscCodeContoller=TextEditingController();
  TextEditingController referNameController=TextEditingController();
  TextEditingController referContactController=TextEditingController();
  TextEditingController billPaymentReasonController=TextEditingController();
  bool ?isBillPaid;
late File imageString;
bool imageDone=false;
  List<File> imageList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        centerTitle: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        titleSpacing: -10,
        backgroundColor: CustomTheme.appTheme,
        title: Padding(
          padding: EdgeInsets.all(10),
          child: Text("Check-Out Form"),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              /// care taker
              Card(

                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headerLabel(labelText: "CARETAKER REVIEW"),
                      SizedBox(height: 5,),
                      Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: [
                        InkWell(
                          onTap:(){
                            setState((){
                              careTakerReview="good";
                            });
                          },
                          child: Container(padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: careTakerReview=="good"?CustomTheme.appThemeContrast2:Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                border: Border.all(color: careTakerReview=="good"?CustomTheme.appThemeContrast2:Colors.grey)
                            ),

                            child: Text("GOOD", style: TextStyle(
                                color: careTakerReview=="good"?Colors.white:Colors.black
                            ),),),
                        ),
                        SizedBox(width: 5,),
                        InkWell(
                          onTap:(){
                            setState((){
                              careTakerReview="average";
                            });
                          },
                          child: Container(padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: careTakerReview=="average"?CustomTheme.appThemeContrast2:Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                border: Border.all(color: careTakerReview=="average"?CustomTheme.appThemeContrast2:Colors.grey)
                            ),

                            child: Text("AVERAGE",

                              style: TextStyle(
                                  color: careTakerReview=="average"?Colors.white:Colors.black
                              ),
                            ),),
                        ),
                        SizedBox(width: 5,),
                        InkWell(

                            onTap:(){
                              setState((){
                                careTakerReview="satisfied";
                              });
                            },
                          child: Container(padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: careTakerReview=="satisfied"?CustomTheme.appThemeContrast2:Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                border: Border.all(color: careTakerReview=="satisfied"?CustomTheme.appThemeContrast2:Colors.grey)
                            ),

                            child:Text("SATISFIED",

                              style: TextStyle(
                                  color: careTakerReview=="satisfied"?Colors.white:Colors.black
                              ),
                            ),),
                        ),
                        SizedBox(width: 5,),
                        InkWell(
                          onTap:(){
                            setState((){
                              careTakerReview="bad";
                            });
                          },
                          child: Container(padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:careTakerReview=="bad"?CustomTheme.appThemeContrast2:Colors.white ,
                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                border: Border.all(color: careTakerReview=="bad"?CustomTheme.appThemeContrast2:Colors.grey)
                            ),

                            child: Text("BAD",

                            style: TextStyle(
                              color: careTakerReview=="bad"?Colors.white:Colors.black
                            ),
                            ),),
                        )
                      ],),
                      SizedBox(height: 4,),
                      Text("Comment"),
                      SizedBox(height: 4,),
                      TextFormField(
                        controller: careTakerCommentController,
                        decoration: new InputDecoration(
                          hintText: "Enter Care Taker Review",
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(7.0),
                            borderSide: new BorderSide(),
                          ),

                          //fillColor: Colors.green
                        ),
                      maxLines: 5,
                      ),
                    ],
                  ),
                ),
              ),


              SizedBox(height: 10,),
              /// Refund Bank Details
              Card(
                child:Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      headerLabel(labelText: "REFUND BANK DETAILS UPDATED"),
                      Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: [
                        InkWell(
                          onTap:(){
                            setState((){
                              isRefundUpdated=true;
                            });
                          },
                          child: Container(padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                          color: isRefundUpdated !=null && isRefundUpdated==true?CustomTheme.appThemeContrast2:Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                border: Border.all(color: isRefundUpdated !=null && isRefundUpdated==true?CustomTheme.appThemeContrast2:Colors.grey)

                            ),

                            child: Text("YES",
                            style: TextStyle(
                 color: isRefundUpdated !=null && isRefundUpdated==true?Colors.white:Colors.black

                            ),
                            ),),
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                          onTap:(){
                            setState((){
                              isRefundUpdated=false;
                            });
                          },
                          child: Container(padding: EdgeInsets.all(10),

                            decoration: BoxDecoration(
                                color: isRefundUpdated !=null && isRefundUpdated!=true?CustomTheme.appThemeContrast2:Colors.white,

                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                border: Border.all(color: isRefundUpdated !=null && isRefundUpdated!=true?CustomTheme.appThemeContrast2:Colors.grey)
                            ),

                            child: Text("NO",style: TextStyle(color:isRefundUpdated !=null && isRefundUpdated!=true? Colors.white:Colors.black),),),
                        )
                      ],),
                      SizedBox(height: 5,),
                  isRefundUpdated ==null || isRefundUpdated ==true?Container():    Container(
                        margin: EdgeInsets.only(left: 2,right: 10,bottom: 10),
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            border: Border.all(color: Colors.grey)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Account Holder Name"),
                            SizedBox(height: 4,),
                            TextFormField(
                              controller: accountHolderName,
                              decoration: new InputDecoration(
                                hintText: "Enter Holder Name",
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(7.0),
                                  borderSide: new BorderSide(),
                                ),
                                //fillColor: Colors.green
                              ),),
                            SizedBox(height: 10,),
                            Text("Account Number"),
                            SizedBox(height: 4,),
                            TextFormField(
                              controller: accountHolderNumber,
                              decoration: new InputDecoration(
                                hintText: "Enter Account Number",
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(7.0),
                                  borderSide: new BorderSide(),
                                ),
                                //fillColor: Colors.green
                              ),),
                            SizedBox(height: 10,),
                            Text("IFSC Code"),
                            SizedBox(height: 4,),
                            TextFormField(
                              controller: ifscCodeContoller,
                              decoration: new InputDecoration(
                                hintText: "Enter IFSC Code",
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(7.0),
                                  borderSide: new BorderSide(),
                                ),
                                //fillColor: Colors.green
                              ),),
                            SizedBox(height: 10,)
                          ],
                        ),
                      ),
                    ],
                  ),
                ) ,
              ),

              SizedBox(height: 10,),
              Card(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    headerLabel(labelText: "REFERENCE"),
                    SizedBox(height: 5,),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          border: Border.all(color: Colors.grey)
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: [
                        Text("Refer name"),
                        SizedBox(height: 4,),
                        TextFormField(
                          controller: referNameController,
                          decoration: new InputDecoration(
                            hintText: "Refer Name",
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(7.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),),
                        SizedBox(height: 10,),
                        Text("Contact Number"),
                        SizedBox(height: 4,),
                        TextFormField(
                          controller: referContactController,
                          decoration: new InputDecoration(
                            hintText: "Contact Number",
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(7.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),),
                        SizedBox(height: 10,)
                      ],),
                    ),
                  ],),
                ),
              ),

              SizedBox(height: 10,),
              Card(
                child: Container( width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      border: Border.all(color: Colors.grey)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    headerLabel(labelText: "E-BILL Paid"),
                    SizedBox(height: 5,),
                    Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: [

                      InkWell(
                        onTap:(){
                          setState((){
                            isBillPaid=true;
                          });
                        },
                        child: Container(padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: isBillPaid !=null && isBillPaid ==true?CustomTheme.appThemeContrast2:Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(7)),
                              border: Border.all(color:isBillPaid !=null && isBillPaid ==true?CustomTheme.appThemeContrast2:Colors.grey)
                          ),

                          child: Text("PAID",
                            style: TextStyle(color: isBillPaid !=null && isBillPaid ==true?Colors.white:Colors.black)

                            ,),),
                      ),
                      SizedBox(width: 10,),
                      InkWell(
                        onTap:(){
                          setState((){
                            isBillPaid=false;
                          });
                        },
                        child: Container(padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isBillPaid !=null && isBillPaid !=true?CustomTheme.appThemeContrast2:Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(7)),
                              border: Border.all(color:isBillPaid !=null && isBillPaid !=true?CustomTheme.appThemeContrast2: Colors.grey)
                          ),

                          child: Text("UNPAID",
                              style: TextStyle(
                                  color: isBillPaid !=null && isBillPaid !=true?Colors.white:Colors.black)
                          ),),
                      ),

                    ],),
                    SizedBox(height: 10,),
                      isBillPaid ==null ?Container(): isBillPaid ==true ? Container(
                        width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          border: Border.all(color: Colors.grey)
                      ),
                      child: Center(child: InkWell(
                          onTap: (){
                            showModalBottomSheet(context: context, builder: (context){
                              return billUploadOption();
                            },elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),

                            );
                          },
                          child: Text(imageDone?"Retake":"Upload Bill"))),
                    ):Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Reason for not paying E-bill"),
                        SizedBox(height: 4,),
                        TextFormField(
                          controller: billPaymentReasonController,
                          decoration: new InputDecoration(
                            hintText: "Reason for not payying E-bill",
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(7.0),
                              borderSide: new BorderSide(),
                            ),

                            //fillColor: Colors.green
                          ),
                          maxLines: 5,
                        ),
                      ],
                      ),


                    imageDone? Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Center(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              imageString,
                              fit: BoxFit.cover,
                              width: 130,

                            ),
                          ),
                      ),
                    ):Container(),

                  ],),

                ),
              ),



            ],),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        color: CustomTheme.appThemeContrast,
        child: TextButton(
          onPressed: (){

          },
          child: Text("Submit",style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),),
        ),
      ),
    );
  }
billUploadOption(){
    return Container(

padding: EdgeInsets.symmetric(vertical: 35,horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  border: Border.all(color: Colors.grey)
              ),
              child: TextButton.icon(

                onPressed: ()async{
                  RMSWidgets.showLoaderDialog(context: context, message: "Capturing Image");
                  final String? filePath =
                  await CapturePhotoPage.captureImageByCamera(
                    context: context,
                    function: (imagePath) async {},
                  );

                  if(filePath !=null){
                  setState((){
                    imageString=File(filePath);
                    imageDone=true;
                  });
                  log("file path camera  2$imageString");
                  Navigator.pop(context);
                  Navigator.pop(context);
                }},
                icon:Icon(Icons.camera,
                  size: 30,
                  color: CustomTheme.appThemeContrast,
                ),label: Text("Camera"),

              ),
            ),),
          Expanded(
            flex: 1,
            child:Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  border: Border.all(color: Colors.grey)
              ),
              child: TextButton.icon(

                onPressed: ()async {
                  RMSWidgets.showLoaderDialog(
                      context: context, message: "Capturing Image");

                  final String? filePath =
                  await CapturePhotoPage.captureImageByGallery(
                    context: context,
                    function: (imagePath) async {},
                  );

                  if (filePath != null) {
                    setState(() {
                      imageString = File(filePath);
                      imageDone=true;
                    });
                    log("file path 2$imageString");
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                icon:Icon(Icons.photo_album,
                  size: 30,
                  color: CustomTheme.appThemeContrast,
                ),label: Text("Gallery"),

              ),
            ),

          ),
        ],
      ),
    );
}
  Widget headerLabel({required String labelText}){
    return Text("$labelText",style: TextStyle(
      fontSize: 16,

    ),);
  }


}
class UploadBillOptions extends StatefulWidget {


  @override
  State<UploadBillOptions> createState() => _UploadBillOptionsState();
}

class _UploadBillOptionsState extends State<UploadBillOptions> {
  @override
  Widget build(BuildContext context) {
    return Container(


      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: TextButton.icon(

              onPressed: (){},
              icon:Icon(Icons.camera,
                size: 30,
                color: CustomTheme.appThemeContrast,
              ),label: Text("Camera"),

            ),),
          Expanded(
              flex: 1,
              child:TextButton.icon(

                onPressed: (){},
                icon:Icon(Icons.photo_album,
                  size: 30,
                  color: CustomTheme.appThemeContrast,
                ),label: Text("Gallery"),

              ),

          ),
        ],
      ),
    );
  }
}
