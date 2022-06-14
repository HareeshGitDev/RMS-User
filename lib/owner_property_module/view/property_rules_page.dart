
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../../utils/view/rms_widgets.dart';
import '../../utils/view/webView_page.dart';
import '../model/owner_property_details_request_model.dart';
import '../viewModel/owner_property_viewModel.dart';

class PropertyRulesPage extends StatefulWidget {
  final String propId;
  String? houseRules;
  final bool fromPropertyDetails;

  PropertyRulesPage(
      {Key? key,
        required this.propId,
        required this.fromPropertyDetails,
        this.houseRules})
      : super(key: key);

  @override
  State<PropertyRulesPage> createState() =>
      _PropertyRulesPageState();
}

class _PropertyRulesPageState extends State<PropertyRulesPage> {
  late OwnerPropertyViewModel _viewModel;
  var _mainHeight;
  var _mainWidth;
  bool editable = false;
  final _houseRulesController = TextEditingController();
  SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();

  getLanguageData() async {
    await _viewModel.getLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'ownerPropertyPage');
  }
  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<OwnerPropertyViewModel>(context, listen: false);
    getLanguageData();
    if(widget.fromPropertyDetails){
      String? houseRules=widget.houseRules
          ?.replaceAll('<ul><li>', '')
          .replaceAll('<li><ul>', '')
          .replaceAll('<li><li>', '')
          .replaceAll('</li><li>', '\n')
          .replaceAll('</li></ul>', '')
          .replaceAll('<ul><ul>', '');
      _houseRulesController.text = houseRules ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        title: Text(nullCheck(
            list: context.watch<OwnerPropertyViewModel>().ownerPropertyLang)
            ? '${context.watch<OwnerPropertyViewModel>().ownerPropertyLang[30].name}'
            :'House Rules'),
      ),
      body: Consumer<OwnerPropertyViewModel>(
        builder: (context, value, child) {
          return Container(
            height: _mainHeight,
            width: _mainWidth,
            color: Colors.white,
            padding: EdgeInsets.only(
                left: _mainWidth * 0.04,
                right: _mainWidth * 0.04,
                top: _mainHeight * 0.02,
                bottom: _mainHeight * 0.02),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[31].name :'Your House Rules'}',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: _mainHeight * 0.02,
                  ),
                  Container(
                    alignment: Alignment.topLeft,

                    height: _mainHeight * 0.5,
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.all(Radius.circular(20)),

                    ),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: -2,
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        maxLines: 20,
                        controller: _houseRulesController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                          border: InputBorder.none,
                          hintText: "House Rules...",
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar:Container(
        margin: EdgeInsets.only(
            left: _mainWidth * 0.04,
            right: _mainWidth * 0.04,
            bottom: _mainHeight * 0.02
        ),
        child: Container(
          height: _mainHeight * 0.05,
          width: _mainWidth ,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    CustomTheme.appThemeContrast),
                shape:
                MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                )),
            child: Text(nullCheck(
                list: context.watch<OwnerPropertyViewModel>().ownerPropertyLang)
                ? '${context.watch<OwnerPropertyViewModel>().ownerPropertyLang[6].name}'
                :'Save'),
            onPressed: () async{
              OwnerPropertyDetailsRequestModel model =
              OwnerPropertyDetailsRequestModel();
              model.things2note = _houseRulesController.text;
              model.propId = widget.propId;
              RMSWidgets.showLoaderDialog(
                  context: context, message: 'Loading');
              int data = await _viewModel.updatePropertyDetails(
                  requestModel: model);
              Navigator.of(context).pop();
              if (data == 200) {

                widget.fromPropertyDetails?Navigator.of(context).pop():Navigator.of(context)
                    .popAndPushNamed(AppRoutes.propertyLocationPage, arguments: {
                  'fromPropertyDetails': false,
                  'propId': widget.propId,
                });
              }
            },
          ),
        ),
      ),
    );
  }

}
