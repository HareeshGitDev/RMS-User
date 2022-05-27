import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../theme/custom_theme.dart';
import '../../utils/constants/app_consts.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/view/rms_widgets.dart';
import '../model/owner_property_details_request_model.dart';
import '../viewModel/owner_property_viewModel.dart';

class PropertyRentPage extends StatefulWidget {
  final String propId;
  String? dailyRent;
  String? monthlyRent;
  String? longTermRent;
  String? longTermDeposit;
  final bool fromPropertyDetails;

   PropertyRentPage({Key? key,required this.propId,required this.fromPropertyDetails,this.monthlyRent,this.dailyRent,this.longTermDeposit,this.longTermRent}) : super(key: key);

  @override
  State<PropertyRentPage> createState() => _PropertyRentPageState();
}

class _PropertyRentPageState extends State<PropertyRentPage> {
  late OwnerPropertyViewModel _viewModel;
  final _dailyRentController=TextEditingController();
  final _monthlyRentController=TextEditingController();
  final _longTermRentController=TextEditingController();
  final _longTermDepositController=TextEditingController();
  final _monthlyDepositController=TextEditingController();
  bool dailyFlag = true;
  bool monthlyFlag = false;
  bool moreThanThreeFlag = false;
  var _mainHeight;
  var _mainWidth;


  @override
  void initState() {
    super.initState();
    _viewModel=Provider.of<OwnerPropertyViewModel>(context,listen: false);
    _monthlyDepositController.text='10000';
    if(widget.fromPropertyDetails){
    _dailyRentController.text=widget.dailyRent.toString();
    _monthlyRentController.text=widget.monthlyRent.toString();
    _longTermRentController.text=widget.longTermRent.toString();
    _longTermDepositController.text=widget.longTermDeposit.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Text('Add Rent'),

      ),
      body: Container(
        height: _mainHeight,
        width: _mainWidth,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: _mainHeight*0.02,
            ),
            Text('Rent & Deposit of Property',style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
             // fontStyle: FontStyle.italic

            ),),
            SizedBox(
              height: _mainHeight*0.02,
            ),
            _getAmountView(context: context, value: _viewModel),


          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: _mainHeight*0.05,
        width: _mainWidth,

        margin: EdgeInsets.only(bottom:_mainHeight*0.02,left: _mainWidth*0.03,right: _mainWidth*0.03),

        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all<Color>(
                  CustomTheme.appTheme),
              shape: MaterialStateProperty.all<
                  RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              )),
          child: const Text('Save'),
          onPressed: () async{

              OwnerPropertyDetailsRequestModel model =
              OwnerPropertyDetailsRequestModel();
              model.rent=_dailyRentController.text;
              model.monthlyRent=_monthlyRentController.text;
              model.rmsRent=_longTermRentController.text;
              model.rmsDeposit=_longTermDepositController.text;
              model.propId = widget.propId;
              RMSWidgets.showLoaderDialog(
                  context: context, message: 'Loading');
              int data = await _viewModel.updatePropertyDetails(
                  requestModel: model);
              Navigator.of(context).pop();
              if (data == 200) {
                widget.fromPropertyDetails?Navigator.of(context).pop():Navigator.of(context)
                    .popAndPushNamed(AppRoutes.propertyRoomsBedsPage, arguments: {
                  'fromPropertyDetails': false,
                  'propId': widget.propId,
                });
              }


          },
        ),
      ),
    );
  }
  Widget _getAmountView(
      {required BuildContext context,
        required OwnerPropertyViewModel value}) {
    return Container(
        decoration: BoxDecoration(
          // color: Colors.amber,
          borderRadius: BorderRadius.circular(5),
        ),

        // height: _mainHeight * 0.17,
        width: _mainWidth,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: _mainWidth * 0.04,
                right: _mainWidth * 0.04,
              ),
              height: _mainHeight * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      if (dailyFlag) {
                        return;
                      } else if (monthlyFlag || moreThanThreeFlag) {
                        setState(() {
                          monthlyFlag = false;
                          moreThanThreeFlag = false;
                          dailyFlag = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: _mainHeight * 0.04,
                      width: _mainWidth * 0.3,
                      decoration: BoxDecoration(
                          color: dailyFlag
                              ? CustomTheme.appTheme
                              : Colors.blueGrey.shade100,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          )),
                      child: Text(
                        'Daily',
                        style: TextStyle(
                            fontSize: 14,
                            color: dailyFlag ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (monthlyFlag) {
                        return;
                      } else if (dailyFlag || moreThanThreeFlag) {
                        setState(() {
                          dailyFlag = false;
                          moreThanThreeFlag = false;
                          monthlyFlag = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: _mainHeight * 0.04,
                      width: _mainWidth * 0.3,
                      color: monthlyFlag
                          ? CustomTheme.appTheme
                          : Colors.blueGrey.shade100,
                      child: Text(
                        'Monthly',
                        style: TextStyle(
                            fontSize: 14,
                            color: monthlyFlag ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (moreThanThreeFlag) {
                        return;
                      } else if (dailyFlag || monthlyFlag) {
                        setState(() {
                          dailyFlag = false;
                          monthlyFlag = false;
                          moreThanThreeFlag = true;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: _mainHeight * 0.04,
                      width: _mainWidth * 0.3,
                      decoration: BoxDecoration(
                          color: moreThanThreeFlag
                              ? CustomTheme.appTheme
                              : Colors.blueGrey.shade100,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: Text(
                        '3+ Months',
                        style: TextStyle(
                            fontSize: 14,
                            color: moreThanThreeFlag
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: _mainHeight*0.02,
            ),
            Container(
                padding: EdgeInsets.only(
                  left: _mainWidth * 0.04,
                  right: _mainWidth * 0.04,
                ),
                child:
                _getRentView(context: context, value: value)),
            SizedBox(
              height: _mainHeight * 0.01,
            ),
          ],
        ));
  }

  Widget _getRentView(
      {required BuildContext context,
        required OwnerPropertyViewModel value}) {
    if (dailyFlag && (monthlyFlag == false && moreThanThreeFlag == false)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Rent',
            style:TextStyle(
                fontSize: 14, color: CustomTheme.appTheme, fontWeight: FontWeight.w500),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: _mainHeight * 0.060,
            width: _mainWidth*0.3,
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
                controller: _dailyRentController,
                keyboardType: TextInputType.number,

                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10),
                  hintText: "0",
                ),
              ),
            ),
          ),

        ],
      );
    } else if (monthlyFlag &&
        (dailyFlag == false && moreThanThreeFlag == false)) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rent',
                style:  TextStyle(
                    fontSize: 14,
                    color: CustomTheme.appTheme,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: _mainHeight * 0.060,
                width: _mainWidth*0.3,
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
                    controller: _monthlyRentController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      hintText: "0",
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Deposit',
                style:  TextStyle(
                    fontSize: 14,
                    color: CustomTheme.appThemeContrast,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: _mainHeight * 0.060,
                width: _mainWidth*0.3,
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
                    controller: _monthlyDepositController,
                    keyboardType: TextInputType.number,
                    enabled: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      hintText: "10000",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rent',
                style:  TextStyle(
                    fontSize: 14,
                    color: CustomTheme.appTheme,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                alignment: Alignment.centerLeft,
                height: _mainHeight * 0.060,
                width: _mainWidth*0.3,
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
                    controller: _longTermRentController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      hintText: "0",
                    ),
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: !dailyFlag,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deposit',
                  style:  TextStyle(
                      fontSize: 14,
                      color: CustomTheme.appThemeContrast,
                      fontWeight: FontWeight.w500),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: _mainHeight * 0.060,
                  width: _mainWidth*0.3,
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
                      controller: _longTermDepositController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        hintText: "0",
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      );
    }
  }
}
