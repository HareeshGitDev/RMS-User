import 'package:RentMyStay_user/images.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
class EditProfile extends StatefulWidget {
  static const routeName = "/editprofile";

  @override
  _EditProfilestate createState() => _EditProfilestate();
}
class _EditProfilestate extends State<EditProfile>  {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _panController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Your Profile",style: TextStyle(fontFamily: 'HKGrotesk-Light'),),
        elevation: 0.0,
        backgroundColor: CustomTheme.appTheme,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          //alignment: Alignment.center,
          children: [
            Column(
              //mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                    children: [
                      CustomPaint(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.1,
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
                                  fontFamily: 'HKGrotest-Light'
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
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
                          backgroundColor: CustomTheme.appTheme.withAlpha(20),radius: 15,
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: CustomTheme.appTheme,size: 15,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      )
                    ]),
                Container(
                  height: MediaQuery.of(context).size.height*0.5,
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 20,right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _textInput(hint: "Name",
                        icon: Icons.person_outline,
                        controller: _nameController,
                      ),
                  _textInput(hint: "Email",
                    icon: Icons.email_outlined,
                    controller: _emailController,),
                    _textInput(hint: "Mobile NUmber",
                      icon: Icons.phone_android_outlined,
                      controller: _phoneController,),
                      _textInput(hint: "Pan Number",
                        icon: Icons.credit_card_outlined,
                        controller: _panController,),
                      Container(
                        height: 55,
                        width: double.infinity,
                        child: ElevatedButton(onPressed: (){},
                          child: Text('Update'),
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  CustomTheme.appTheme),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10)),
                              )),),
                      )
                    ],
                  ),
                )
              ],
            ),

          ],
        ),
      ),
    );
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