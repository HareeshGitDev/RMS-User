import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../images.dart';
import '../viewmodel/mystay_viewmodel.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackState createState() => _FeedbackState();
}
class _FeedbackState extends State<FeedbackPage> {
  @override
  final _nameController = TextEditingController();
  final _banknameController = TextEditingController();
  final _banknumberController = TextEditingController();
  final _bankIfscController = TextEditingController();
  final _suggestionController = TextEditingController();
  var _mainHeight;
  var _mainWidth;
  static const String fontFamily = 'hk-grotest';
  late MyStayViewModel _viewModel;

  Widget build(BuildContext context) {
    _mainHeight = MediaQuery
        .of(context)
        .size
        .height;
    _mainWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Feedback Form '),
        ),
        body: Container(height: _mainHeight, color: Colors.white,
          width: _mainWidth,
          margin: EdgeInsets.all(10),
          child: Column(
              children: [Row(
                children: [
                  Text('Shubham Kumar'),
                  Text('{shubhamkumar@rentmystay.com}')
                ],),
                Text('Fully Furnished ! BHK House For Long Term Stay Near Maruthi Nagar'),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                  children: [
                    Text('Select NA if no Deposit Paid'),
                    Icon(Icons.check_box_outline_blank),
                  ],),
                Text('Final Settlement amount to be sent to the following bank account within 3-5 working days after handling over keys and all scheduled deduction.',maxLines: 4,textAlign: TextAlign.start,),
             _textInput(controller: _nameController, hint: 'Enter Account Holder Name Here', ) ,
              _textInput(controller: _banknameController, hint: 'Enter Bank Name Here',),
            _textInput(controller: _banknumberController, hint: 'Enter Account Holder Name Here', ) ,
        _textInput(controller: _bankIfscController, hint: 'Enter Account Holder Name Here', ),
                SizedBox(height: 5,),
                Text('How was your exprience with RentMyStay ?'),
                Text('How do you Rate Building/flat '),
                Text('Would You Recommend our service to a friend / Colleague ?'),
                Container(margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                      Row(children: [Icon(Icons.thumb_up_alt_outlined,size: 40,color: myFavColor),SizedBox(width: 10,),Text('YES',style: TextStyle(fontSize: 18,color: myFavColor,fontWeight: FontWeight.w600)),]),
                      Row(children: [Icon(Icons.thumb_down_alt_outlined,size: 40,color: CustomTheme.appTheme,),SizedBox(width: 10),Text('NO',style: TextStyle(color: CustomTheme.appTheme,fontWeight: FontWeight.w600,fontSize: 18),),]),])),
                Text('Any Suggestion (Optional) ?'),
                _textInput(controller: _suggestionController, hint: 'Enter Your Suggestion here'),
                SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () {
                  },
                  child:
                  Text(
                    'Submit Feedback',
                    style: TextStyle(
                        fontFamily: fontFamily,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(
                        CustomTheme.appTheme,
                      ),
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10)),
                      )),
                ),
              ]
    ),
        )
    );
  }
  Widget _textInput(
      {required TextEditingController controller,
        required String hint,}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.all(
            Radius.circular(20)),
        color: Colors.white,
      ),
      child: Neumorphic(
        style: NeumorphicStyle(border: NeumorphicBorder(color: Colors.blueGrey),
          depth: -10,
          color: Colors.white,
        ),
        child: Container(margin: EdgeInsets.only(left: 10,right: 10),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
            ),
          ),
        ),
      ),
    );
  }
}