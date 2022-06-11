import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/theme/fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../language_module/model/language_model.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../../utils/view/rms_widgets.dart';
import '../viewModel/home_viewModel.dart';

class TenantLeadsPage extends StatefulWidget {
  const TenantLeadsPage({Key? key}) : super(key: key);

  @override
  _TenantLeadsPageState createState() => _TenantLeadsPageState();
}

class _TenantLeadsPageState extends State<TenantLeadsPage> {
  late StreamSubscription<ConnectivityResult> _connectivitySubs;
  final Connectivity _connectivity = Connectivity();
  bool _connectionStatus = true;
  late HomeViewModel _homeViewModel;
  var _mainHeight;
  var _mainWidth;
  SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();

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
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    _homeViewModel.getTenantLeads();
    getLanguageData();
  }

  getLanguageData() async {
    await _homeViewModel.getTenantLeadsLanguageData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'tenantLeads');
  }

  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

  @override
  void dispose() {
    _connectivitySubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus
        ? Scaffold(
            appBar: AppBar(
              centerTitle: false,
              titleSpacing: 0,
              title: Text(nullCheck(
                      list: context.watch<HomeViewModel>().tenantLeadsLang)
                  ? '${context.watch<HomeViewModel>().tenantLeadsLang[0].name}'
                  : 'Tenant Leads'),
            ),
            body: Consumer<HomeViewModel>(builder: (context, value, child) {
              if (value.tenantLeadsModel.msg != null &&
                  value.tenantLeadsModel.data != null &&
                  value.tenantLeadsModel.data?.length != 0) {
                return Container(
                  height: _mainHeight,
                  width: _mainWidth,
                  color: Colors.white,
                  child: ListView.separated(
                      itemBuilder: (_, index) {
                        var data = value.tenantLeadsModel.data?[index];
                        return Container(
                          color: Colors.amber,
                         height: _mainHeight * 0.15,
                          child: Card(
                            child: Container(

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 50,
                                    width: _mainWidth,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${nullCheck(list: value.tenantLeadsLang) ? value.tenantLeadsLang[2].name : 'Prop Name'} : ',
                                          style: TextStyle(
                                              height: getHeight(
                                                  context: context, height: 12),
                                              color: Colors.grey),
                                        ),
                                        Text(
                                          data?.propertyName ?? '',
                                          style: TextStyle(
                                              height: getHeight(
                                                  context: context, height: 14),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: _mainWidth,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${nullCheck(list: value.tenantLeadsLang) ? value.tenantLeadsLang[3].name : 'Site Visit Date'} : ',
                                          style: TextStyle(
                                              height: getHeight(
                                                  context: context, height: 12),
                                              color: Colors.grey),
                                        ),
                                        Text(
                                          data?.siteVisitDate ?? '',
                                          style: TextStyle(
                                              height: getHeight(
                                                  context: context, height: 14),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: _mainWidth,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${nullCheck(list: value.tenantLeadsLang) ? value.tenantLeadsLang[4].name : 'Contact Details'} : ',
                                          style: TextStyle(
                                              height: getHeight(
                                                  context: context, height: 12),
                                              color: Colors.grey),
                                        ),
                                        Text(
                                          data?.contactDetails ?? '',
                                          style: TextStyle(
                                              height: getHeight(
                                                  context: context, height: 14),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: _mainWidth,
                                    child: Row(
                                      children: [
                                        Text(
                                          '${nullCheck(list: value.tenantLeadsLang) ? value.tenantLeadsLang[5].name : 'Email'} : ',
                                          style: TextStyle(
                                              height: getHeight(
                                                  context: context, height: 12),
                                              color: Colors.grey),
                                        ),
                                        Text(
                                          data?.emailId ?? '',
                                          style: TextStyle(
                                              height: getHeight(
                                                  context: context, height: 14),
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => SizedBox(
                            height: 0,
                          ),
                      itemCount: value.tenantLeadsModel.data?.length ?? 0),
                );
              } else if ((value.tenantLeadsModel.msg != null &&
                      value.tenantLeadsModel.data != null &&
                      value.tenantLeadsModel.data?.length == 0) ||
                  (value.tenantLeadsModel.msg != null &&
                      value.tenantLeadsModel.data == null)) {
                return Center(
                    child: RMSWidgets.someError(
                        context: context, message: 'No Data Found.'));
              } else {
                return Center(
                  child: RMSWidgets.getLoader(),
                );
              }
            }),
          )
        : RMSWidgets.networkErrorPage(context: context);
  }
}
