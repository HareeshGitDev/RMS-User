import 'package:RentMyStay_user/theme/custom_theme.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/sp_constants.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../../utils/view/rms_widgets.dart';
import '../viewModel/login_viewModel.dart';

class InactiveUi extends StatefulWidget {
  const InactiveUi({Key? key}) : super(key: key);

  @override
  State<InactiveUi> createState() => _InactiveUiState();
}

class _InactiveUiState extends State<InactiveUi> {
  late LoginViewModel _loginViewModel=LoginViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(""),
        title: const Text("Account Activation"),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              color: Colors.grey.shade200,
              margin: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
child: const Text("Your account is in inactive mode. Please activate account to continue..",

style: TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 18
),
),
            ),
          ),
        ],
      ) ,
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(

                  color: CustomTheme.appThemeContrast2,
                  child: TextButton(


                      onPressed: (){
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.loginPage, (route) => false,
                            arguments: {
                              'fromExternalLink': false,
                            });
                      }
                      , child: Text("Go Back",
                    style: TextStyle(color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ))),
            ),
            Expanded(
              child: Container(

                  color: CustomTheme.appThemeContrast,
                  child: TextButton(onPressed: ()async{


                    RMSWidgets.showLoaderDialog(context: context, message: "Activating your account");
                    var response=await _loginViewModel.deleteAccount(action: "activate", context: context);
                    RMSWidgets.getToast(message: response, color: Colors.green);
                    SharedPreferenceUtil shared = SharedPreferenceUtil();
                    await shared.setString(rms_accountStatus, 'active');
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.dashboardPage,
                          (route) => false,
                    );
                  }, child: Text("Activate",
                    style: TextStyle(color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ))),
            )
          ],
        ),
      ),

    );
  }
}
