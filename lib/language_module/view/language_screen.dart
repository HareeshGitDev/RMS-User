import 'dart:developer';

import 'package:RentMyStay_user/utils/constants/sp_constants.dart';
import 'package:RentMyStay_user/utils/service/shared_prefrences_util.dart';
import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/custom_theme.dart';
import '../../utils/service/navigation_service.dart';
import '../viewModel/language_viewModel.dart';

class LanguageScreen extends StatefulWidget {
  String language;

  LanguageScreen({Key? key,required this.language}) : super(key: key);

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late LanguageViewModel _viewModel;
  var _mainHeight;
  var _mainWidth;

  SharedPreferenceUtil shared = SharedPreferenceUtil();



  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<LanguageViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.appTheme,
        titleSpacing: 0,
        title: Text('Select Language'),
      ),
      body: Container(
        height: _mainHeight,
        width: _mainWidth,
        padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
        child: Column(
          children: [
            Container(
                height: _mainHeight * 0.05,
                child: RadioListTile(
                    value: 'english',
                    groupValue: widget.language,
                    activeColor: CustomTheme.appTheme,
                    title: Text('English'),
                    onChanged: (lang) {
                      log(lang as String);
                      setState(() =>widget. language = lang);
                    })),
            Container(
                height: _mainHeight * 0.05,
                child: RadioListTile(
                    value: 'hindi',
                    groupValue: widget.language,
                    activeColor: CustomTheme.appTheme,
                    title: Text('Hindi'),
                    onChanged: (lang) {
                      log(lang as String);
                      setState(() => widget.language = lang);
                    })),
            Spacer(),
            Container(
              width: _mainWidth,
              height: 45,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(CustomTheme.appTheme),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    )),
                onPressed: () async {
                  RMSWidgets.showLoaderDialog(
                      context: context, message: 'Loading');

                  await shared.setString(rms_language, widget.language);
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .popAndPushNamed(AppRoutes.dashboardPage);
                },
                child: Center(child: Text("Save")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
