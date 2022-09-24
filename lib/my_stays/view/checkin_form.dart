import 'dart:developer';
import 'package:RentMyStay_user/my_stays/model/amenities_check_model.dart';
import 'package:RentMyStay_user/my_stays/viewmodel/mystay_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/custom_theme.dart';

class CheckInForm extends StatefulWidget {
  String bookingId;
  CheckInForm({required this.bookingId});

  @override
  State<CheckInForm> createState() => _CheckInFormState();
}

class _CheckInFormState extends State<CheckInForm> {
  bool paymentTypeRent=false;
  bool paymentTypeDeposit=false;
  bool paymentTypOnBoarding=false;
  late MyStayViewModel myStayViewModel;
  bool ?isClean;
  bool ?isAmenities;
  bool ?isGasFilled;
  AmenitiesCheckModel updatedAmenities=AmenitiesCheckModel(data: Data(amenityList: []));
  late Map<String,dynamic> paymentTypeMap={};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myStayViewModel = Provider.of<MyStayViewModel>(context, listen: false);
myStayViewModel.getAmenitiesCheckInList(bookingId: widget.bookingId);

  }
 // final MultiSelectController<String> _controller = MultiSelectController();
  @override

  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  leading: const BackButton(
    color: Colors.white,
  ),
  centerTitle: false,
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15))),
  titleSpacing: -10,
  backgroundColor: CustomTheme.appTheme,
  title: const Padding(
    padding: EdgeInsets.all(10),
    child: Text("Check-In Form"),
  ),
),
      body: Consumer<MyStayViewModel>(builder: (context,dataValue,child){
        var dataCheck=dataValue.amenitiesCheckModel!.data!.amenityList;
        for(var data in dataCheck!) {
          if(data.key=="1"){
          setState((){
            updatedAmenities.data?.amenityList?.add(data);
          });
        }
        }
        log(">>>> $updatedAmenities");
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Card(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(7)),
                        border: Border.all(color: Colors.grey)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerLabel(labelText: "Was Property Clean While Check-In?"),
                        const SizedBox(height: 5,),
                        Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: [
                          InkWell(
                            onTap:(){
                              setState((){
                                isClean=true;
                              });
                            },
                            child: Container(padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color:isClean !=null && isClean ==true? CustomTheme.appThemeContrast2:Colors.white,
                                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                                  border: Border.all(color:isClean !=null && isClean ==true? CustomTheme.appThemeContrast2:Colors.grey)
                              ),

                              child: Text("YES",style: TextStyle(
                                  color: isClean !=null && isClean ==true?Colors.white:Colors.black
                              ),),),
                          ),
                          const SizedBox(width: 10,),
                          InkWell(
                            onTap: (){
                              setState((){
                                isClean=false;
                              });
                            },
                            child: Container(padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: isClean !=null && isClean !=true? CustomTheme.appThemeContrast2:Colors.white,
                                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                                  border: Border.all(color:isClean !=null && isClean !=true? CustomTheme.appThemeContrast2: Colors.grey)
                              ),

                              child: Text("NO",style: TextStyle(

                                  color: isClean !=null && isClean !=true? Colors.white:Colors.black
                              ),
                              ),
                            ),
                          )
                        ],
                        ),
                        const SizedBox(height: 10,),
                        headerLabel(labelText: "Payment Done During Check-In ?"),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(7)),
                              border: Border.all(color: Colors.grey)),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: [
                            CheckboxListTile(value:paymentTypeDeposit,  onChanged: (val){
                              setState((){
                                paymentTypeDeposit=val!;
                                if(paymentTypeDeposit){
                                  paymentTypeMap["Deposit"]="1";
                                }
                                else{
                                  paymentTypeMap["Deposit"]="0";
                                }
                              });
                              log(">>>$paymentTypeMap");
                            },title: const Text("Deposit"),
                              activeColor: CustomTheme.appTheme,
                              contentPadding: const EdgeInsets.all(0),
                              dense: true,
                            ),
                            CheckboxListTile(value:paymentTypeRent,  onChanged: (val){
                              setState((){
                                paymentTypeRent=val!;
                                if(paymentTypeRent){
                                  paymentTypeMap["Rent"]="1";
                                }
                                else{
                                  paymentTypeMap["Rent"]="0";
                                }
                              });
                              log(">>>$paymentTypeMap");
                            },title: const Text("Rent"),
                              activeColor: CustomTheme.appTheme,
                              contentPadding: const EdgeInsets.all(0),
                              dense: true,
                            ),
                            CheckboxListTile(value:paymentTypOnBoarding,  onChanged: (val){
                              setState((){
                                paymentTypOnBoarding=val!;
                                if(paymentTypOnBoarding){
                                  paymentTypeMap["On-Boarding"]="1";
                                }
                                else{
                                  paymentTypeMap["On-Boarding"]="0";
                                }
                              });
                              log(">>>$paymentTypeMap");
                            },title: const Text("On-Boarding"),
                              activeColor: CustomTheme.appTheme,
                              contentPadding: const EdgeInsets.all(0),
                              dense: true,
                            ),

                          ],),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10,),
                Card(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(7)),
                        border: Border.all(color: Colors.grey)
                    ),
                    child:   Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerLabel(labelText: "AMENITIES"),
                        const SizedBox(height: 5,),
                        Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: [
                          InkWell(
                            onTap:(){
                              setState((){
                                isAmenities=true;
                              });
                            },
                            child: Container(padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: isAmenities !=null && isAmenities ==true? CustomTheme.appThemeContrast2:Colors.white,
                                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                                  border: Border.all(color:isAmenities !=null && isAmenities ==true? CustomTheme.appThemeContrast2: Colors.grey)
                              ),

                              child:  Text("YES",style: TextStyle(

                                color: isAmenities !=null && isAmenities ==true?Colors.white:Colors.black,
                              ),),),
                          ),
                          const SizedBox(width: 10,),
                          InkWell(
                            onTap:(){
                              setState((){
                                isAmenities=false;
                              });
                            },
                            child: Container(padding: const EdgeInsets.all(10),

                              decoration: BoxDecoration(
                                  color: isAmenities !=null && isAmenities !=true? CustomTheme.appThemeContrast2:Colors.white,
                                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                                  border: Border.all( color:isAmenities !=null && isAmenities !=true? CustomTheme.appThemeContrast2:Colors.grey)
                              ),

                              child: Text("NO",style: TextStyle(color: isAmenities !=null && isAmenities !=true?Colors.white:Colors.black),),),
                          ),
                        ],),
                        const SizedBox(height: 10,),
                        isAmenities !=null && isAmenities ==true?Card(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(7)),
                                border: Border.all(color: Colors.grey)
                            ),
                            child:  Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:  [
                                const Text("Please Select Amenities from Below List"),
                                ListTileTheme.merge(
                                    dense: true,
                                    child: ListView.builder(
shrinkWrap: true,
                                    itemCount: updatedAmenities.data?.amenityList?.length,
                                    itemBuilder: (context,index){

log(">>>> $updatedAmenities");
return


  Container(child: Text("${updatedAmenities.data?.amenityList?[index].title}"),);
                                }))
                              ],
                            ),
                          ),
                        ):Container()

                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10,),
                Card(
                  child: Container(

                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(7)),
                        border: Border.all(color: Colors.grey)
                    ),
                    child:   Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerLabel(labelText: "GAS FILLED BY RMS"),
                        const SizedBox(height: 5,),
                        Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,children: [

                          InkWell(
                            onTap: (){
                              setState((){
                                isGasFilled=true;
                              });
                            },
                            child: Container(padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: isGasFilled !=null && isGasFilled ==true?CustomTheme.appThemeContrast2:Colors.white,

                                  //color: CustomTheme.appThemeContrast2,
                                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                                  border: Border.all(color:isGasFilled !=null && isGasFilled ==true?CustomTheme.appThemeContrast2: Colors.grey)

                                // border: Border.all(color: CustomTheme.appThemeContrast2)
                              ),

                              child:  Text("YES",style: TextStyle(
                                  color:isGasFilled !=null && isGasFilled ==true? Colors.white:Colors.black

                              ),),),
                          ),
                          const SizedBox(width: 10,),
                          InkWell(
                            onTap: (){
                              setState((){
                                isGasFilled=false;
                              });
                            },
                            child: Container(padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: isGasFilled !=null && isGasFilled !=true?CustomTheme.appThemeContrast2:Colors.white,
                                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                                  border: Border.all(color:isGasFilled !=null && isGasFilled !=true?CustomTheme.appThemeContrast2: Colors.grey)
                              ),

                              child:  Text("No",style: TextStyle(
                                  color:isGasFilled !=null && isGasFilled !=true? Colors.white:Colors.black

                              ),),),
                          ),

                        ],),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10,),
                Card(
                  child:   Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(7)),
                        border: Border.all(color: Colors.grey)
                    ),
                    child: Column(
                      children: [
                        noteLabel(note: "Note:", noteText: "E-bill should pay by the customer directly to the BESCOM"),
                        const SizedBox(height: 5,),
                        noteLabel(note: "Note:", noteText: "Cx have to pay standard amount RS 700 where separate meter is not provided (WITH GST)"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Card(
                  child: Container(

                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(7)),
                          border: Border.all(color: Colors.grey)
                      ),
                      child: contactLabel()),
                ),
                const SizedBox(height: 10,),
                Card(
                  child: Container(

                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(7)),
                        border: Border.all(color: Colors.grey)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Email:- ",style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Contact@rentmystay.com",

                              maxLines: 5,
                              style: TextStyle(
                                fontSize: 14,

                              ),),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              ],),
          ),
        );
      },

      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        color: CustomTheme.appThemeContrast,
        child: TextButton(
          onPressed: (){

          },
          child: const Text("Submit",style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),),
        ),
      ),
    );
  }

  Widget headerLabel({required String labelText}){
    return Text(labelText,style: const TextStyle(
      fontSize: 16,

    ),);
  }
  Widget noteLabel({required String note,required String noteText}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(note,style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),),
        Container(
          width: MediaQuery.of(context).size.width/1.35,
          child: Text(noteText,

            maxLines: 5,
            style: const TextStyle(
            fontSize: 14,

          ),
          ),
        ),
      ],
    );
  }

  Widget contactLabel(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("CONTACT:- ",style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){

                launch(
                    'tel:7204315482');

              },
              child: const Text("OPS NO :- 7204315482",

                maxLines: 5,
                style: TextStyle(
                  fontSize: 14,

                ),),
            ),
            InkWell(
              onTap: (){
                launch(
                    'tel:7411146474');
              },
              child: const Text("SALES NO :- 7411146474",

                maxLines: 5,
                style: TextStyle(
                  fontSize: 14,

                ),),
            ),
            InkWell(
              onTap: (){
                launch(
                    'tel:9164729897');
              },
             // width: MediaQuery.of(context).size.width/1.35,
              child: const Text("FINANCE NO :- 9164729897",

                maxLines: 5,
                style: TextStyle(
                  fontSize: 14,
                ),),
            ),
          ],
        ),
      ],
    );
  }
}

