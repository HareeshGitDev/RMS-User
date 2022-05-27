import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/my_stays/viewmodel/mystay_viewmodel.dart';

import 'package:RentMyStay_user/utils/constants/app_consts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../language_module/model/language_model.dart';
import '../../theme/custom_theme.dart';
import '../../utils/constants/sp_constants.dart';
import '../../utils/service/shared_prefrences_util.dart';
import '../../utils/view/rms_widgets.dart';
import '../model/refund_splitup_model.dart';

class RefundSplitPage extends StatefulWidget {
  final String bookingId;

  const RefundSplitPage({Key? key, required this.bookingId}) : super(key: key);

  @override
  _RefundSplitPageState createState() => _RefundSplitPageState();
}

class _RefundSplitPageState extends State<RefundSplitPage> {
  @override
  var _mainHeight;
  var _mainWidth;
  late MyStayViewModel _viewModel;
  late SharedPreferenceUtil preferenceUtil = SharedPreferenceUtil();
  late StreamSubscription<ConnectivityResult> _connectivitySubs;
  final Connectivity _connectivity = Connectivity();
  bool _connectionStatus = true;

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
    _viewModel.getRefundSplitUpDetails(bookingId: widget.bookingId);
    getLanguageData();
  }

  getLanguageData() async {
    await _viewModel.getLanguagesData(
        language: await preferenceUtil.getString(rms_language) ?? 'english',
        pageName: 'Refundsplitup');
  }

  bool nullCheck({required List<LanguageModel> list}) =>
      list.isNotEmpty ? true : false;

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus?Scaffold(
        appBar: AppBar(
          title: Text(nullCheck(
                  list: context.watch<MyStayViewModel>().refundSplitUpLang)
              ? '${context.watch<MyStayViewModel>().refundSplitUpLang[3].name}'
              : 'Refund SplitUp '),
          titleSpacing: 0,
          centerTitle: false,
          backgroundColor: CustomTheme.appTheme,
        ),
        body: Consumer<MyStayViewModel>(
          builder: (context, value, child) {
            return value.refundSplitUpModel != null &&
                    value.refundSplitUpModel?.msg != null &&
                    value.refundSplitUpModel?.data != null
                ? Container(
                    height: _mainHeight,
                    color: Colors.white,
                    width: _mainWidth,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        getAdjustmentList(
                            adjustments:
                                value.refundSplitUpModel?.data?.adjustments),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(nullCheck(list: value.refundSplitUpLang)
                                    ? ' ${value.refundSplitUpLang[0].name} '
                                    : 'Your Security Deposit'),
                                Text(
                                    '$rupee ${value.refundSplitUpModel?.data?.depositReceived}')
                              ]),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(nullCheck(list: value.refundSplitUpLang)
                                    ? '${value.refundSplitUpLang[1].name} '
                                    : 'Your Deposit Refund'),
                                Text(
                                    '$rupee ${value.refundSplitUpModel?.data?.depositRefund}')
                              ]),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Text(nullCheck(list: value.refundSplitUpLang)
                                ? ' ${value.refundSplitUpLang[2].name} '
                                : '* This is approximate deductions made from the security deposit amount.\n* The security deposit amount will be refundable within 3 - 5 working days after handing over keys and all scheduled deduction.\n* Kindly coordinate with caretaker and ensure that the flat inspection is done before your moveout in your presence to confirm about the damages so you are aware about the same. All damages will be charged accordingly. \n*In case of any queries please write to finance@rentmystay.com.'))
                      ]),
                    ),
                  )
                : value.refundSplitUpModel != null &&
                        value.refundSplitUpModel?.msg != null &&
                        value.refundSplitUpModel?.data == null
                    ? RMSWidgets.noData(
                        context: context, message: 'Something went Wrong.')
                    : Center(child: RMSWidgets.getLoader());
          },
        )):RMSWidgets.networkErrorPage(context: context);
  }

  Widget getAdjustmentList({required List<Adjustments>? adjustments}) {
    return adjustments != null && adjustments.isNotEmpty
        ? Container(
            margin: EdgeInsets.all(10),
            child: ListView.separated(
              itemBuilder: (context, index) {
                var data = adjustments[index];
                return Neumorphic(
                  style: NeumorphicStyle(
                      color: Colors.white,
                      depth: 2,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(10))),
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    height: 40,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${data.transactionType}'),
                          Text('$rupee ${data.payable}'),
                        ]),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                height: 5,
              ),
              itemCount: adjustments.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ))
        : Container();
  }
}
