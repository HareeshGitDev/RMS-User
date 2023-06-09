import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/my_stays/viewmodel/mystay_viewmodel.dart';

import 'package:RentMyStay_user/utils/view/rms_widgets.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/navigation_service.dart';
import '../../utils/service/shared_prefrences_util.dart';

class TicketListPage extends StatefulWidget {
  const TicketListPage({Key? key}) : super(key: key);

  @override
  _TicketListPageState createState() => _TicketListPageState();
}

class _TicketListPageState extends State<TicketListPage> {
  var _mainHeight;
  var _mainWidth;
  late MyStayViewModel _viewModel;
  late StreamSubscription<ConnectivityResult> _connectivitySubs;
  final Connectivity _connectivity = Connectivity();
  bool _connectionStatus = true;
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
  getLanguageData() async {
    await _viewModel.getLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'ticketPage');
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
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
    _viewModel.getTicketList(context: context);
    getLanguageData();
  }
  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;
  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus
        ? Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Text(nullCheck(
                  list: context.watch<MyStayViewModel>().ticketLang)
                  ? '${context.watch<MyStayViewModel>().ticketLang[0].name}'
                  : 'Created Tickets',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: false,
              backgroundColor: CustomTheme.appTheme,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.pushNamed(
                  context, AppRoutes.myStayListPage,
                  arguments: {
                    'fromBottom': false,
                  }),
              backgroundColor: CustomTheme.appTheme,
              splashColor: CustomTheme.myFavColor,
              tooltip: 'Create Ticket',
              child: Icon(Icons.add),
            ),
            body: Consumer<MyStayViewModel>(
              builder: (context, value, child) {
                return value.ticketResponseModel != null &&
                        value.ticketResponseModel?.data != null &&
                        value.ticketResponseModel?.data?.length != 0
                    ? Container(
                        height: _mainHeight,
                        width: _mainWidth,
                        padding: EdgeInsets.only(
                            left: _mainWidth * 0.03,
                            right: _mainWidth * 0.03,
                            top: _mainHeight * 0.01,
                            bottom: _mainHeight * 0.01),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  var data =
                                      value.ticketResponseModel?.data?[index];
                                  return GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                        context, AppRoutes.ticketDetailsPage,
                                        arguments: data ?? []).then((value) => _viewModel.getTicketList(context: context)),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                          height: _mainHeight * 0.05,
                                          // width: _mainWidth,
                                          padding: EdgeInsets.only(
                                            left: _mainWidth * 0.015,
                                            right: _mainWidth * 0.015,
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${index + 1}.',
                                                style: TextStyle(
                                                    color: CustomTheme.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                              ),
                                              Container(
                                                width: _mainWidth * 0.68,
                                                child: Text(
                                                  '${data?.description ?? ''}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                '${data?.status ?? ''}',
                                                style: TextStyle(
                                                    color: data?.status
                                                                ?.toLowerCase() ==
                                                            'resolved'
                                                        ? CustomTheme.myFavColor
                                                        : data?.status
                                                                    ?.toLowerCase() ==
                                                                'open'
                                                            ? CustomTheme
                                                                .appTheme
                                                            : CustomTheme
                                                                .appThemeContrast,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          )),
                                    ),
                                  );
                                },
                                itemCount:
                                    value.ticketResponseModel?.data?.length ??
                                        0,
                                separatorBuilder: (context, index) => SizedBox(
                                  height: _mainHeight * 0.008,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : value.ticketResponseModel != null &&
                            value.ticketResponseModel?.data != null &&
                            value.ticketResponseModel?.data?.length == 0
                        ? Center(
                            child: RMSWidgets.noData(
                            context: context,
                            message: 'No Tickets Found.',
                          ))
                        : Center(
                            child: RMSWidgets.getLoader(
                                color: CustomTheme.appTheme));
              },
            ),
          )
        : RMSWidgets.networkErrorPage(context: context);
  }
}
