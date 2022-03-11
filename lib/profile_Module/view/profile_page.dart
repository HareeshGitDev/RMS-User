import 'dart:convert';
import 'dart:developer';

import 'package:RentMyStay_user/utils/service/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:provider/provider.dart';

import '../../Web_View_Container.dart';
import '../../home_module/viewModel/home_viewModel.dart';
import '../../theme/custom_theme.dart';
import '../model/profile_model.dart';
import '../viewmodel/profile_view_model.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileViewModel _profileViewModel ;
  late String update_kyc =
      "https://www.rentmystay.com/dashboard/userVerify/" ;
  String? userid="";
  String?token="";
 //+user_id.trim()+"/"+token+"?app=1");

  @override
  void initState() {
    super.initState();
    _profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    _profileViewModel.getProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(builder: (context, value, child) {
     userid=value.profileModel.result != null?value.profileModel.result![0].userId.toString():"";
     token=value.profileModel.result  != null && value.profileModel.result![0].appToken != null?value.profileModel.result![0].appToken.toString():"";
       return Scaffold(
        appBar: _getAppBar(context: context),
        backgroundColor: Colors.white,
        body: value.profileModel.result != null && value.profileModel.result!.isNotEmpty &&
                value.profileModel.profileCompletion != null
            ? Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                //borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image:NetworkImage(value.profileModel
                                            .result![0].picture.toString()))
                                // color: Colors.orange[100],
                                ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _profileName(
                        value.profileModel.result!.isNotEmpty && value.profileModel.result![0].firstname != null?value.profileModel.result![0].firstname.toString():"" ),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.80, //80% of width,
                      child: Text(
                        "Personal Details",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        child: Column(
                          children: [
                            //row for each deatails
                            ListTile(
                              leading: Icon(
                                Icons.email,
                                color: CustomTheme.skyBlue,
                              ),
                              title: Text(
                                   value.profileModel.result!.isNotEmpty && value.profileModel.result![0].email != null ?
                                   value.profileModel.result![0].email.toString():"",style: TextStyle(fontSize: 14),),
                            ),
                            Divider(
                              height: 0.6,
                              color: Colors.black87,
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.phone,
                                color: CustomTheme.skyBlue,
                              ),
                              title: Text(
                                  value.profileModel.result![0].contactNo ??
                                      "",style: TextStyle(fontSize: 14),),
                            ),
                            Divider(
                              height: 0.6,
                              color: Colors.black87,
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.location_on_outlined,
                                color: CustomTheme.skyBlue,
                              ),
                              title: Text(value.profileModel.result![0]
                                      .permanentAddress ??
                                  " ",style: TextStyle(fontSize: 14),),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.80, //80% of width,
                      child: Text(
                        "DashBoard",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    _settingsCard(),
                    Spacer(),
                    logoutButton()
                  ],
                ),
              )
            : Center(child:  CircularProgressIndicator(
            valueColor:AlwaysStoppedAnimation<Color>(CustomTheme.skyBlue))),
      );
    });
  }

  Widget _profileName(String name) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80, //80% of width,
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            color: Colors.black45,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _settingsCard() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            //row for each deatails
            ListTile(
              leading: Icon(
                Icons.home_outlined,
                color: CustomTheme.skyBlue,
              ),
              title: Text("My Stays",style: TextStyle(fontSize: 14),),
            ),

            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            GestureDetector(onTap: () =>
                _handleURLButtonPress(
                context, update_kyc, 'Update Your kyc'),
              child: ListTile(
                //onTap: () => _handleURLButtonPress(context, , title),
                leading: Icon(
                  Icons.topic,
                  color: CustomTheme.skyBlue,
                ),
                title: Text("Update KYC",style: TextStyle(fontSize: 14),),
              ),
            ),

            Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            ListTile(
              leading: Icon(
                Icons.camera_alt_outlined,
                color: CustomTheme.skyBlue,
              ),
              title: Text("Upload ID-proof",style: TextStyle(fontSize: 14),),
            ),
          ],
        ),
      ),
    );
  }

  Widget logoutButton() {
    return InkWell(
      onTap: () {},
      child: Container(
          color: CustomTheme.peach.withAlpha(99),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )
              ],
            ),
          )),
    );
  }

  AppBar _getAppBar({required BuildContext context}) {
    return AppBar(
      leading: BackButton(
        color: CustomTheme.skyBlue,
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.editProfilePage);
          },
          child: Container(
            child: Text(
              "EDIT",
              style: TextStyle(color: Colors.black45, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            margin: EdgeInsets.only(right: 20, top: 16),
          ),
        ),
      ],

      titleSpacing: 0,
      elevation: 0,
      backgroundColor: Colors.white,
      // centerTitle: true,
      title: Text('Profile', style: TextStyle(color: Colors.black45,fontSize: 16)),
    );
  }

  void _handleURLButtonPress(BuildContext context, String url, String title) {

    String urlwithparams=url+base64Encode(utf8.encode(userid!.trim()))+"/"+token!+"?app=1";

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Web_View_Container(urlwithparams, title)),
    );
  }
}
