import 'dart:developer';

import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/custom_theme.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../service/google_auth_service.dart';
import '../viewModel/login_viewModel.dart';

class AccountDeletion extends StatefulWidget {
  const AccountDeletion({Key? key}) : super(key: key);

  @override
  State<AccountDeletion> createState() => _AccountDeletionState();
}

class _AccountDeletionState extends State<AccountDeletion> {
  var _mainHeight;
  var accountType;
  late LoginViewModel _loginViewModel=LoginViewModel();
  var _mainWidth;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Delete/Deactivate My Account",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 15,top: 15,bottom: 15,right: 15),
child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Container(
      color: Colors.grey.shade200,
        padding: const EdgeInsets.only(left: 10,top: 15,bottom: 15,right: 10),
        child: const Text("If you want a break from Us, you can temporarily deactivate your account instead of deleting it.")

    ),
    SizedBox(height: 20,),
    Container(

        //padding: const EdgeInsets.only(left: 10,top: 15,bottom: 15,right: 10),
        child: const Text("Please select options below",
          style: TextStyle(fontSize: 16),
        )),
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio(
                groupValue: accountType,
                value: 'inactive',
                activeColor: CustomTheme.appTheme,
                onChanged: (value) {
                  setState(() => accountType = value as String);
                },
              ),
              Text(
                'I want to Deactivate My Acocunt',
                style: TextStyle(
                    fontSize: 16,
                    color: CustomTheme.black,
                    fontWeight: FontWeight.w600),
              ),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio(
                groupValue: accountType,
                value: 'delete',
                activeColor: CustomTheme.appTheme,
                onChanged: (value) {
                  setState(() => accountType = value as String);
                },
              ),
              Text(
                'I want to Delete My Account',
                style: TextStyle(
                    fontSize: 16,
                    color: CustomTheme.black,
                    fontWeight: FontWeight.w600),
              ),

            ],
          ),





  ],
),
      ),
      bottomNavigationBar: Container(
        color: CustomTheme.appThemeContrast,
width: double.infinity,

child: TextButton(
  onPressed: ()async{
if(accountType !=null && accountType.toString().length>0){
  RMSWidgets.showLoaderDialog(context: context, message: "$accountType your account");
var response=await _loginViewModel.deleteAccount(action: accountType, context: context);
RMSWidgets.getToast(message: response, color: Colors.green);

Navigator.pop(context);
  RMSWidgets.showLoaderDialog(
      context: context, message: 'Logging out');
  SharedPreferenceUtil shared = SharedPreferenceUtil();
  await GoogleAuthService.logOut();
  await GoogleAuthService.logoutFromFirebase();
  bool deletedAllValues = await shared.clearAll();
  Navigator.of(context).pop();
  if (deletedAllValues) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.loginPage, (route) => false,
        arguments: {
          'fromExternalLink': false,
        });
  } else {
    log('NOT ABLE TO DELETE VALUES FROM SP');
  }
}
else{
  RMSWidgets.showSnackbar(context: context, message: "Please Select the exact option", color: Colors.red);
}
  },
  child: const Text("Submit",
    style: TextStyle(color: Colors.white,
    fontSize: 16,
      fontWeight: FontWeight.bold
    ),
  ),
),
      ),

    );
  }
}
