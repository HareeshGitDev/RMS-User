import 'dart:async';
import 'dart:developer';

import 'package:RentMyStay_user/my_stays/model/ticket_response_model.dart';
import 'package:RentMyStay_user/utils/service/date_time_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/custom_theme.dart';
import '../../utils/view/rms_widgets.dart';
import '../viewmodel/mystay_viewmodel.dart';

class TicketDetailsPage extends StatefulWidget {
  final Data ticketModel;

  const TicketDetailsPage({Key? key, required this.ticketModel})
      : super(key: key);

  @override
  _TicketDetailsPageState createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  var _mainHeight;
  var _mainWidth;
  late MyStayViewModel _viewModel;
  late ValueNotifier<bool> showOpenButton;
  late ValueNotifier<bool> showResolvedButton;
  late ValueNotifier<bool> showCancelButton;
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

  TextStyle get getKeyStyle =>
      TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14);

  TextStyle get getValueStyle =>
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14);

  @override
  void initState() {
    super.initState();
    initConnectionStatus();
    _connectivitySubs =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
    showOpenButton = ValueNotifier(false);
    showResolvedButton = ValueNotifier(false);
    showCancelButton = ValueNotifier(false);
    if (widget.ticketModel.status?.toLowerCase() == 'open' ||
        widget.ticketModel.status?.toLowerCase() == 'reopen') {
      showResolvedButton.value = true;
      showCancelButton.value = true;
      showOpenButton.value = false;
    } else if (widget.ticketModel.status?.toLowerCase() == 'resolved') {
      showResolvedButton.value = false;
      showCancelButton.value = false;
      showOpenButton.value = true;
    } else if (widget.ticketModel.status?.toLowerCase() == 'cancelled') {
      showResolvedButton.value = false;
      showCancelButton.value = false;
      showOpenButton.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return _connectionStatus
        ? Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              centerTitle: false,
              title: Text(
                'Ticket Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: CustomTheme.appTheme,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
            ),
            body: Container(
              height: _mainHeight,
              width: _mainWidth,
              padding: EdgeInsets.only(
                  left: _mainWidth * 0.03,
                  right: _mainWidth * 0.03,
                  top: _mainHeight * 0.015,
                  bottom: _mainHeight * 0.01),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        // color: Colors.amber,
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.only(
                      left: _mainWidth * 0.05,
                      top: _mainHeight * 0.01,
                      bottom: _mainHeight * 0.01,
                      right: _mainWidth * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.ticketModel.category ?? ''}',
                          style: TextStyle(
                              color: CustomTheme.appTheme,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        ),
                        SizedBox(
                          height: _mainHeight * 0.005,
                        ),
                        Container(
                          //color: Colors.amber,
                          //height: _mainHeight * 0.03,
                          width: _mainWidth,
                          child: Row(
                            children: [
                              Text('Time : ',
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12)),
                              Text(
                                  '${DateTimeService.checkDateFormat(widget.ticketModel.date) ?? ''}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                              const Spacer(),
                              Text('Status : ',
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12)),
                              Text('${widget.ticketModel.status ?? ''}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14))
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 0.7,
                        ),
                        SizedBox(
                          height: _mainHeight * 0.001,
                        ),
                        widget.ticketModel.unitNumber != null &&
                            widget.ticketModel.unitNumber?.trim() != ''
                            ? Container(
                                //color: Colors.amber,
                                //height: _mainHeight * 0.03,
                                width: _mainWidth,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Unit No. : ',
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                    Text(
                                        '${widget.ticketModel.unitNumber ?? ''}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ],
                                ),
                              )
                           : Container(),
                        widget.ticketModel.unitNumber != null &&
                            widget.ticketModel.unitNumber?.trim() != ''
                            ?SizedBox(height: _mainHeight*0.005,):Container(),
                        Container(
                          //color: Colors.amber,
                          //height: _mainHeight * 0.03,
                          width: _mainWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Ticket Id : ',
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                              Text('${widget.ticketModel.id ?? ''}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: _mainHeight*0.005,
                        ),
                        Container(
                          // color: Colors.amber,
                          //height: _mainHeight * 0.03,
                          width: _mainWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Mobile : ',
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14)),
                              Text('${widget.ticketModel.mobileNumber ?? ''}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14))
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 0.7,
                        ),
                        Container(
                          //color: Colors.amber,
                          //height: _mainHeight * 0.03,
                          width: _mainWidth,
                          child: RichText(
                            text: TextSpan(children: [
                              const TextSpan(
                                text: "Issue Description : ",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              ),
                              TextSpan(
                                text:
                                    '${widget.ticketModel.description ?? ''} ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12),
                              ),
                            ]),
                          ),
                        ),
                        const Divider(
                          thickness: 0.7,
                        ),
                       showResolvedButton.value || showOpenButton.value || showCancelButton.value? Container(
                          height: _mainHeight * 0.035,
                          width: _mainWidth,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              showOpenButton.value
                                  ? ValueListenableBuilder(
                                      valueListenable: showOpenButton,
                                      builder: (context, bool value, child) {
                                        return ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .all<Color>(CustomTheme
                                                          .appThemeContrast),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              )),
                                          onPressed: () async {
                                            String status = 'ReOpen';
                                            String ticketId =
                                                widget.ticketModel.id ?? '';
                                            RMSWidgets.showLoaderDialog(
                                                context: context,
                                                message: 'Loading');
                                            int response = await _viewModel
                                                .updateTicketStatus(
                                                    status: status,
                                                    ticketId: ticketId);
                                            Navigator.of(context).pop();
                                            if (response == 200) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Center(
                                              child: Text(
                                            'Re-Open',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )),
                                        );
                                      })
                                  : Container(),
                              showOpenButton.value
                                  ? SizedBox(
                                      width: _mainWidth * 0.1,
                                    )
                                  : Container(),
                              showResolvedButton.value
                                  ? ValueListenableBuilder(
                                      valueListenable: showResolvedButton,
                                      builder: (context, bool value, child) {
                                        return ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      CustomTheme.myFavColor),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              )),
                                          onPressed: () async {
                                            String status = 'Resolved';

                                            String ticketId =
                                                widget.ticketModel.id ?? '';
                                            RMSWidgets.showLoaderDialog(
                                                context: context,
                                                message: 'Loading');
                                            int response = await _viewModel
                                                .updateTicketStatus(
                                                    status: status,
                                                    ticketId: ticketId);
                                            Navigator.of(context).pop();
                                            if (response == 200) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Center(
                                              child: Text(
                                            'Resolve',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )),
                                        );
                                      })
                                  : Container(),
                              SizedBox(
                                width: _mainWidth * 0.1,
                              ),
                              showCancelButton.value
                                  ? ValueListenableBuilder(
                                      valueListenable: showCancelButton,
                                      builder: (context, bool value, child) {
                                        return ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      CustomTheme.appTheme),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              )),
                                          onPressed: () async {
                                            String status = 'Cancelled';
                                            String ticketId =
                                                widget.ticketModel.id ?? '';
                                            RMSWidgets.showLoaderDialog(
                                                context: context,
                                                message: 'Loading');
                                            int response = await _viewModel
                                                .updateTicketStatus(
                                                    status: status,
                                                    ticketId: ticketId);
                                            Navigator.of(context).pop();
                                            if (response == 200) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Center(
                                              child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )),
                                        );
                                      })
                                  : Container()
                            ],
                          ),
                        ):Container(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  widget.ticketModel.images != null &&  widget.ticketModel.images?.length != 0
                      ? Container(
                          height: _mainHeight * 0.12,
                          width: _mainWidth,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return CachedNetworkImage(
                                imageUrl: widget.ticketModel.images?[index] ?? '',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: _mainWidth * 0.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                        child: Container(
                                          height: _mainHeight * 0.1,
                                          width: _mainWidth * 0.3,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                        baseColor: Colors.grey[200] as Color,
                                        highlightColor:
                                            Colors.grey[350] as Color),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              );
                            },
                            itemCount:
                                widget.ticketModel.images?.length ?? 0,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: 10,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          )
        : RMSWidgets.networkErrorPage(context: context);
  }
}
