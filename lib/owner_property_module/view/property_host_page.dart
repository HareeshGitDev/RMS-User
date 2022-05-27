import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../../theme/custom_theme.dart';

class HostPropertyPage extends StatefulWidget {
  const HostPropertyPage({Key? key}) : super(key: key);

  @override
  State<HostPropertyPage> createState() => _HostPropertyPageState();
}

class _HostPropertyPageState extends State<HostPropertyPage> {
  var _mainHeight;
  var _mainWidth;

  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  int units = 0;

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Host'),
        titleSpacing: 0,
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: ()=>FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          height: _mainHeight,
          width: _mainWidth,
          color: Colors.white,
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  // height: _mainHeight * 0.060,
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
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Owner Name",
                        prefixIcon:
                            Icon(Icons.person, color: Colors.grey, size: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: _mainHeight * 0.015,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  // height: _mainHeight * 0.060,
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
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "E-mail",
                        prefixIcon: Icon(Icons.email_outlined,
                            color: Colors.grey, size: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: _mainHeight * 0.015,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  //height: _mainHeight * 0.060,
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
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone Number",
                        prefixIcon:
                            Icon(Icons.phone_android, color: Colors.grey, size: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: _mainHeight * 0.015,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  //  height: _mainHeight * 0.060,
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
                      controller: _addressController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Property Address",
                        prefixIcon:
                            Icon(Icons.my_location, color: Colors.grey, size: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: _mainHeight*0.02,
                ),
                Container(

                  height: 50,
                  width: _mainWidth,
                  child: Row(
                    children: [
                      Text('Number of Units : ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,),),
                      SizedBox(width: 20,),

                      DropdownButton<int>(
                          borderRadius: BorderRadius.circular(20),
                          elevation: 65,
                          value: units,
                          iconEnabledColor: CustomTheme.appThemeContrast,

                          style: TextStyle(
                              color: CustomTheme.appTheme
                          ),
                          menuMaxHeight: _mainHeight*0.35,
                          items: List.generate(51, (index) => index)
                              .map((e) =>
                              DropdownMenuItem<int>(value: e, child: Text(e.toString(),style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16
                              ),),),)
                              .toList(),
                          onChanged: (int? val) {
                            setState(() {
                              units = int.parse(val.toString());
                            });

                          }),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: _mainHeight * 0.2,
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
                      maxLines: 5,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 10,top: 10),
                        border: InputBorder.none,
                        hintText: "Any Comment...",
                      ),
                    ),
                  ),
                ),
                Container(

                 height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(

                        height: 45,
                        child: ElevatedButton(

                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  CustomTheme.appThemeContrast),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              )),
                          onPressed: () async {


                          },
                          child: Center(child: Text("Capture Image")),
                        ),
                      ),Container(

                        height: 45,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  CustomTheme.appThemeContrast),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              )),
                          onPressed: () async {


                          },
                          child: Center(child: Text("Capture Location")),
                        ),
                      ),
                    ],
                  ),
                ),



              ],
            ),
          ),
        ),
      ),bottomNavigationBar: Container(
      margin: EdgeInsets.only(
          left: _mainWidth * 0.04,
          right: _mainWidth * 0.04,
          bottom: _mainHeight * 0.02),
      width: _mainWidth,
      height: _mainHeight * 0.05,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all<Color>(
                CustomTheme.appTheme),
            shape: MaterialStateProperty.all<
                RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
            )),
        onPressed: () async {


        },
        child: Center(child: Text("Submit")),
      ),
    ),
    );
  }
}
