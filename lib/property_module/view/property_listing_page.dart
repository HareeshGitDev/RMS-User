import 'dart:developer';
import 'dart:ui';

import 'package:RentMyStay_user/utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class PropertyListingPage extends StatefulWidget {
  const PropertyListingPage({Key? key}) : super(key: key);

  @override
  _PropertyListingPageState createState() => _PropertyListingPageState();
}

class _PropertyListingPageState extends State<PropertyListingPage> {
  var _mainHeight;
  var _mainWidth;

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _getAppBar(context: context),
      body: Container(
        color: Colors.white,
        height: _mainHeight,
        width: _mainWidth,
        padding: EdgeInsets.only(left: 15, right: 15,top: 15,bottom:0),
        child: Stack(
          children: [
            Container(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Container(

                    child: Card(
                      elevation: 5,
                      shadowColor: myFavColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),

                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                "https://foyr.com/learn/wp-content/uploads/2021/08/design-your-dream-home.jpg",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Container(

                                  width: _mainWidth*0.75,
                                  child: Text(
                                      'Fully Furnished 1 BHK Family Flat For Rents By RMS',overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(
                                    fontSize: 16
                                  ),),
                                ),
                              ),
                              SizedBox(
                                height: 0,
                              ),
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
                                    )*/),
                                icon: Icon(Icons.my_location_outlined,size: 20,color:myFavColor,),
                                label: Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text('BTM Layout',style: TextStyle(
                                    color: Colors.black
                                  ),),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(color: myFavColor,),
                              ),

                              Container(
                                height: 40,
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
                                height: 40,
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    radius:10,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.check,size: 15,color: myFavColor,)),
                                Container(
                                    color:myFavColor,
                                    child: Text('Certified By RMS',style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      fontSize: 16
                                    ),)),
                                Spacer(),
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.grey.shade300,
                                  child: Icon(
                                    Icons.favorite,
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
  }

  AppBar _getAppBar({required BuildContext context}) {
    return AppBar(
      leading: Icon(Icons.article_outlined),
      titleSpacing: 0,
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
