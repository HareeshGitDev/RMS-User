import 'dart:developer';
import 'dart:ui';

import 'package:RentMyStay_user/property_module/viewModel/property_viewModel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/widgets/star_rating/star_rating.dart';
import 'package:provider/provider.dart';

import '../../images.dart';

class PropertyListingPage extends StatefulWidget {
  const PropertyListingPage({Key? key}) : super(key: key);

  @override
  _PropertyListingPageState createState() => _PropertyListingPageState();
}

class _PropertyListingPageState extends State<PropertyListingPage> {
  var _mainHeight;
  var _mainWidth;
  late PropertyViewModel _propertyViewModel;

  @override
  void initState() {
    _propertyViewModel=Provider.of<PropertyViewModel>(context,listen: false);
    _propertyViewModel.getPropertyDetailsList(address: 'BTM-Layout-Bengaluru-Karnataka-India');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Consumer<PropertyViewModel>(builder: (context, value, child) {
      if(value.propertyDetailsModel.data != null){
        return Scaffold(
          appBar: _getAppBar(context: context),
          body: Container(
            color: Colors.white,
            height: _mainHeight,
            width: _mainWidth,
            padding: EdgeInsets.only(left: 15, right: 15,top: 15,bottom:0),
            child: Stack(
              children: [
                Container
                  (
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: ()=>index % 2==0?log(index.toString()):(){},

                        child: Container(

                          height: 400,
                          child: Card(
                            color:index % 2==0? Colors.white:Colors.grey.shade500,
                            elevation: 5,
                            shadowColor: CustomTheme.skyBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            ),

                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 220,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                        image: DecorationImage(image: AssetImage(Images.img3),fit: BoxFit.cover),
                                      ),
                                      //child:
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [

                                        Expanded(
                                          child: Container(

                                            margin: EdgeInsets.only(left: 10),
                                            width: _mainWidth*0.75,
                                            child: Text(
                                              'Fully Furnished 1 BHK Family Flat For Rents By RMS',overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(
                                              fontSize: 14,
                                            ),
                                            ),
                                          ),
                                        ),
                                        Expanded(child: FxStarRating(
                                          activeColor: myFavColor,
                                          inactiveColor: Colors.white,
                                          spacing: 3,
                                          rating: 3.5,

                                          size: 20,
                                        )),
                                      ],
                                    ),
                                    Container(
                                      child:
                                      TextButton.icon(

                                        onPressed: () {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                          /*shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(40)),
                                        )*/
                                        ),
                                        icon: Icon(Icons.my_location_outlined,size: 20,color:myFavColor,),
                                        label: Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Text('BTM Layout',style: TextStyle(
                                              color: Colors.black
                                          ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(color: CustomTheme.skyBlue,),
                                    Container(
                                      height: 30,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.only(left: 15,right: 15,top: 0,bottom: 0),
                                        leading:  Text('Rent Per Day'),
                                        trailing:RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: 'Rs 1000',
                                                style: TextStyle(
                                                    color: Colors.grey, fontFamily: "Nunito",decoration: TextDecoration.lineThrough)),
                                            TextSpan(
                                                text: '  Rs 750',
                                                style: TextStyle(
                                                    color: myFavColor, fontFamily: "Nunito",fontSize: 16)),
                                          ]),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      height: 30,
                                      child: ListTile(

                                        contentPadding: EdgeInsets.only(left: 15,right: 15,top: 0,bottom: 0),
                                        leading:  Text('Rent (Stay < 3 Month)'),
                                        trailing:RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: 'Rs 1000',
                                                style: TextStyle(
                                                    color: Colors.grey, fontFamily: "Nunito",decoration: TextDecoration.lineThrough,fontSize: 14)),

                                            TextSpan(
                                                text: '  Rs 750',
                                                style: TextStyle(
                                                    color: myFavColor, fontFamily: "Nunito",fontSize: 16)),
                                          ]),
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 40,
                                  width: _mainWidth,
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: myFavColor,

                                        child: Row(
                                            children: [
                                              CircleAvatar(
                                                  radius:10,
                                                  backgroundColor: myFavColor.withAlpha(40),
                                                  child: Icon(Icons.check,size: 15,color: Colors.white,)),
                                              Container(
                                                  color:myFavColor.withAlpha(95),
                                                  child: Text('Managed by RMS',style: TextStyle(
                                                      fontStyle: FontStyle.italic,
                                                      color: Colors.white,
                                                      fontSize: 16
                                                  ),)),]
                                        ),
                                      ),
                                      Spacer(),
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: CustomTheme.peach.withAlpha(80),
                                        child: Icon(
                                          Icons.favorite_outline_rounded,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: 10,
                    separatorBuilder: (context,index)=>const SizedBox(height: 15,),
                  ),
                ),
                _getFilterSortSetting(context: context),
              ],
            ),
          ),
        );
      }else {
        return Scaffold(appBar:_getAppBar(context: context),body: Center(child: CircularProgressIndicator()));
      }

    },);
  }

  AppBar _getAppBar({required BuildContext context}) {
    return AppBar(
      leading:BackButton(color: Colors.white,),
      titleSpacing: 0,backgroundColor: CustomTheme.skyBlue,
      title: Padding(
        padding: EdgeInsets.only(right: 10),
        child: Container(
          height: 40,
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
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search by Area',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getFilterSortSetting({required BuildContext context}) {
    return Positioned(
      bottom: _mainHeight * 0.01,
      left: _mainWidth * 0.3,
      child: ElevatedButton(
        onPressed: () {
          log('Sort __ Filter');
        },
        child: Container(
          width: _mainWidth * 0.3,
          child: Row(
            children: [
              Icon(Icons.filter_alt_outlined),
              SizedBox(
                width: 15,
              ),
              Text(
                'Filter & Sort',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
