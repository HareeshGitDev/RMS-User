import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../theme/custom_theme.dart';

class EditProfile extends StatefulWidget {
  static const routeName = "/editprofile";

  @override
  _EditProfilestate createState() => _EditProfilestate();
}

class _EditProfilestate extends State<EditProfile> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
   var _mainHeight;
  var _mainWidth;
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
    super.dispose();
  }

@override
  void initState() {

    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }


  @override
  Widget build(BuildContext context) {
    _mainHeight=MediaQuery.of(context).size.height;
    _mainWidth=MediaQuery.of(context).size.width;
    return _connectionStatus?Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Your Profile",
          style: TextStyle(fontFamily: 'HKGrotesk-Light'),
        ),
        elevation: 0.0,
        backgroundColor: CustomTheme.appTheme,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(children: [
                CustomPaint(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  painter: HeaderCurvedContainer(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Profile",
                        style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'HKGrotest-Light'),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _getHeader(),
                    /*  Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: CircleAvatar(radius: 10,
                )
              ), */
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 230, left: 230),
                  child: CircleAvatar(
                    backgroundColor: CustomTheme.appTheme.withAlpha(20),
                    radius: 15,
                    child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: CustomTheme.appTheme,
                        size: 15,
                      ),
                      onPressed: () {},
                    ),
                  ),
                )
              ]),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: _mainWidth,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                 children: [

                    Container(
                      height: _mainHeight*0.045,

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
                                color: Colors.grey, size: 20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: _mainHeight*0.045,

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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email_outlined,
                                color: Colors.grey, size: 20),
                          ),
                        ),
                      ),
                    ),
                   SizedBox(height: 20),
                    Container(
                      height: _mainHeight*0.045,

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
                          controller: _phoneController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Mobile Number',
                            prefixIcon: Icon(Icons.phone_android_outlined,
                                color: Colors.grey, size: 20),
                          ),
                        ),
                      ),
                    ),
                   SizedBox(height: 30),


                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar:  Container(
        height: 40,
        margin: EdgeInsets.only(left: 20,right: 20,bottom: 15),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          child: Text('Update'),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  CustomTheme.appTheme),
              shape: MaterialStateProperty.all<
                  RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              )),
        ),
      ),
    ):RMSWidgets.networkErrorPage(context: context);
  }

  Widget _getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                //borderRadius: BorderRadius.all(Radius.circular(10.0)),
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/rms_home.png?alt=media&token=77f8c180-2d7b-47f5-a0bb-d60bdb49d03b"))
                // color: Colors.orange[100],
                ),
          ),
        ),
      ],
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = CustomTheme.appTheme.withAlpha(50);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
