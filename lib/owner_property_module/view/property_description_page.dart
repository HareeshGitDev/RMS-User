
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

class PropertyDescriptionPage extends StatefulWidget {
  final String propId;
  String? description;
  final bool fromPropertyDetails;

  PropertyDescriptionPage(
      {Key? key,
      required this.propId,
      required this.fromPropertyDetails,
      this.description})
      : super(key: key);

  @override
  State<PropertyDescriptionPage> createState() =>
      _PropertyDescriptionPageState();
}

class _PropertyDescriptionPageState extends State<PropertyDescriptionPage> {
  late OwnerPropertyViewModel _viewModel;
  var _mainHeight;
  var _mainWidth;
  bool editable = false;
  final _detailsController = TextEditingController();
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
      String? description=widget.description
          ?.replaceAll('<ul><li>', '')
          .replaceAll('<li><ul>', '')
          .replaceAll('<li><li>', '')
          .replaceAll('</li><li>', '\n')
          .replaceAll('</li></ul>', '')
          .replaceAll('<ul><ul>', '');
      _detailsController.text = description ?? '';
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
            ? '${context.watch<OwnerPropertyViewModel>().ownerPropertyLang[27].name}'
            :'Details'),
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
                    '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[28].name :'Your Property Description '}',
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
                        controller: _detailsController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                          border: InputBorder.none,
                          hintText: '${nullCheck(list: value.ownerPropertyLang) ? value.ownerPropertyLang[29].name :"Any Comment"}...',
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
      bottomNavigationBar:   Container(
        height: _mainHeight * 0.05,
        width: _mainWidth ,

        margin: EdgeInsets.only(
            left: _mainWidth * 0.04,
            right: _mainWidth * 0.04,
            bottom: _mainHeight * 0.02
        ),
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
            model.description = _detailsController.text;
            model.propId = widget.propId;
            RMSWidgets.showLoaderDialog(
                context: context, message: 'Loading');
            int data = await _viewModel.updatePropertyDetails(
                requestModel: model);
            Navigator.of(context).pop();
            if (data == 200) {

              widget.fromPropertyDetails?Navigator.of(context).pop():Navigator.of(context)
                  .popAndPushNamed(AppRoutes.propertyRulesPage, arguments: {
                'fromPropertyDetails': false,
                'propId': widget.propId,
              });
            }
          },
        ),
      ),
    );
  }

}
