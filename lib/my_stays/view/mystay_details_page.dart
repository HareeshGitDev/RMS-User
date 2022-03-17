import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/custom_theme.dart';
import '../viewmodel/mystay_viewmodel.dart';

class MyStayPage extends StatefulWidget {
  const MyStayPage({Key? key}) : super(key: key);

  @override
  _MyStayPageState createState() => _MyStayPageState();
}
  class _MyStayPageState extends State<MyStayPage> {
  static const String fontFamily = 'hk-grotest';
  late MyStayViewModel _viewModel;
  var _mainHeight;
  var _mainWidth;


  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      appBar: _getAppBar(context: context),
      body: SingleChildScrollView(
        child: Container(height: _mainHeight,color: Colors.white,
          width: _mainWidth,
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10,top: 10,right: 10),
                    child: Container(alignment: Alignment.bottomLeft,
                        child: Text('1BHK- Old Airport Road-Patels Residency-G1',style: TextStyle(fontSize: 14,fontWeight:FontWeight.w500,),textAlign: TextAlign.start, )),
                  ),
                  Container(padding: EdgeInsets.only(left: 10,top: 10,right: 10),child: Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      Text(' Map ')
                    ],
                  )),
                ],
              ),
              Divider(height: 10,thickness: 2,),
              Container(width: _mainWidth,
                margin: EdgeInsets.only(bottom: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Container(
                  height: 80,
                  width: _mainWidth*0.2,
                  margin:  EdgeInsets.only(left: 10,top: 10),
                  child: CachedNetworkImage(
                    imageUrl: "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/btm.png?alt=media&token=8a4a92fb-c0db-4c23-9c5b-e74166373827",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius:  BorderRadius.circular(10),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Shimmer.fromColors(
                        child: Container(
                          height: 70,
                          color: Colors.grey,
                        ),
                        baseColor: Colors.grey[200] as Color,
                        highlightColor: Colors.grey[350] as Color),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  ),
                ),
                  Container(width: _mainWidth*0.7,alignment: Alignment.topLeft,margin:EdgeInsets.only(left: 10,right: 10),child: Text("No.17, Nanjund Reddy Layout,!st Cross,konena Agrahara , H.A.L post, Bangalore - 560017",maxLines: 4,)),
                ],),
              ),
              Container(width: _mainWidth,color: Colors.red,
              height: _mainHeight*0.04,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 14, color: Colors.white,fontWeight: FontWeight.w500,
                        ),
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.people_alt_outlined,size: 20,color: Colors.white),
                          ),
                          TextSpan(
                            text: ' 2 Guest',
                          )
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 14, color: Colors.white,fontWeight: FontWeight.w500,
                        ),
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.calendar_today_outlined,size: 20,color: Colors.white),
                          ),
                          TextSpan(
                            text: ' 29 Night(s)',
                          )
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 14, color: Colors.white,fontWeight: FontWeight.w500,
                        ),
                        children: [
                          WidgetSpan(
                            child: Icon(Icons.outbond_outlined,size: 20,color: Colors.white),
                          ),
                          TextSpan(
                            text: ' Apr 04,2022',
                          )
                        ],
                      ),
                    ),
                ]
              ),),
              Divider(height: 10,),
              Container(width: _mainWidth,
                margin: EdgeInsets.only(left: 10,right: 10,),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text("Name : Shubham Kumar"),
                Text("Update Your Kyc",style: TextStyle(backgroundColor: CustomTheme.appTheme,color: Colors.white),)
                ,]),),
              SizedBox(height: 10,),
              Container(margin: EdgeInsets.only(left: 10,right: 10),alignment: Alignment.centerLeft,child: Text("Phone No : 919794562047",)),
              SizedBox(height: 10,),
              Container(width: _mainWidth,color: Colors.red,
                height: _mainHeight*0.05,alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Active Booking",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),),
                )),

              SizedBox(height: 10,),
              Container(margin: EdgeInsets.only(left: 10,right: 10,top: 10),width: _mainWidth,
                  child: Row(
                    children: [
                      Text("Booking From"),
                      Row(
                        children: [
                          Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: CustomTheme.appTheme),
                              child: Text(" Check In ")),
                          Text("Mar 06, 2022"),
                          Icon(Icons.keyboard_arrow_down_outlined)
                        ],
                      )],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,)
              ),
              Container(margin: EdgeInsets.only(left: 20,right: 20),width: _mainWidth,
                  child: Row(
                    children: [
                      Text("Check In Date",style:TextStyle(fontSize: 10,fontWeight: FontWeight.w600) ),
                      Row(
                        children: [
                          Text("Mar 06, 2022",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600),),
                        ],
                      )],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,)
              ),
              Container(margin: EdgeInsets.only(left: 20,right: 20),width: _mainWidth,
                  child: Row(
                    children: [
                      Text("Check In By",style:TextStyle(fontSize: 10,fontWeight: FontWeight.w600) ),
                      Row(
                        children: [
                          Text("Rent My Stay",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600),),
                        ],
                      )],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,)
              ),
              Divider(height: 10,thickness: 2,),
              Container(margin: EdgeInsets.only(left: 10,right: 10,top: 10),width: _mainWidth,
                  child: Row(
                    children: [
                      Text("Booking To"),
                      Row(
                        children: [Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: CustomTheme.appTheme),
          child: Text(" Check Out ")),
                          Text("Mar 06, 2022"),
                          Icon(Icons.keyboard_arrow_down_outlined)
                        ],
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,)
              ),
              Container(margin: EdgeInsets.only(left: 20,right: 20),width: _mainWidth,
                  child: Row(
                    children: [
                      Text("Check In Date",style:TextStyle(fontSize: 10,fontWeight: FontWeight.w600) ),
                      Row(
                        children: [
                          Text("Mar 06, 2022",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600),),
                        ],
                      )],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,)
              ),
              Container(margin: EdgeInsets.only(left: 20,right: 20),width: _mainWidth,
                  child: Row(
                    children: [
                      Text("Check In By",style:TextStyle(fontSize: 10,fontWeight: FontWeight.w600) ),
                      Row(
                        children: [
                          Text("Rent My Stay",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600),),
                        ],
                      )],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,)
              ),
              Divider(height: 10,thickness: 2,),
              Container(margin: EdgeInsets.all(10),width: _mainWidth,
                  child: Row(
                    children: [
                      Text("Pending Details "),
                      Text("21600.00")],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,)
              ),
              Divider(height: 10,thickness: 2,),

              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _gridInput(hint: "Monthly Invoice(s)",
                    icon: Icons.line_weight_outlined,),
                  _gridInput(hint: "Agreement Sign",
                    icon: Icons.assignment_turned_in_outlined,),
                  _gridInput(hint: "Refund SplitUp",
                    icon: Icons.sticky_note_2_outlined,),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _gridInput(hint: "Raise Ticket",
                    icon: Icons.description_outlined,),
                  _gridInput(hint: "Refund Process",
                    icon: Icons.person_outline,),
                  _gridInput(hint: "Privacy Policies",
                    icon: Icons.person_outline,),
                ],
              ),
              ],
          ),),
      ),
    );
  }

} AppBar _getAppBar({required BuildContext context}) {
  return AppBar(
    leading: BackButton(
      color: Colors.white,
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15))),
    titleSpacing: 0,
    backgroundColor: CustomTheme.appTheme,
    title: Padding(
      padding: EdgeInsets.all(10),
      child: Text('Booking Id : 50144'),
      ),
  );
}
Widget _gridInput({required String hint,
  required IconData icon})
{
  return SafeArea(
    child: Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              /*  image: DecorationImage(
                    image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/btm.png?alt=media&token=8a4a92fb-c0db-4c23-9c5b-e74166373827"),
                    fit: BoxFit.cover
                ) */
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                /*  gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(.4),
                        Colors.black.withOpacity(.2),
                      ]
                  )*/
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[Icon(icon,size: 40),
                  SizedBox(height: 5,),
                  Text(hint, style: TextStyle(color: Colors.black, fontSize: 14,),textAlign: TextAlign.center),
                  SizedBox(height: 5,),
                 /* Container(
                    height: 30,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                    ),
                    child: Center(child: Text("Shop Now", style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),)),
                  ),*/

                ],
              ),
            ),
          ),

        ],
      ),
    ),
  );
}