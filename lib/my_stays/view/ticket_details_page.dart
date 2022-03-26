import 'package:RentMyStay_user/my_stays/model/ticket_response_model.dart';
import 'package:RentMyStay_user/utils/service/date_time_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  TextStyle get getKeyStyle =>
      TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14);

  TextStyle get getValueStyle =>
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14);

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
    showOpenButton = ValueNotifier(false);
    showResolvedButton = ValueNotifier(false);
    showCancelButton = ValueNotifier(false);
    if (widget.ticketModel.status?.toLowerCase() == 'open' || widget.ticketModel.status?.toLowerCase() =='reopen') {
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
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
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
            Text('Issue Description : ',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
            Text('${widget.ticketModel.description ?? ''}',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500)),
            SizedBox(
              height: 20,
            ),
            widget.ticketModel.issueImage != null
                ? Container(
                    height: _mainHeight * 0.2,
                    width: _mainWidth,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl:
                              widget.ticketModel.issueImage?[index].imageLink ??
                                  '',
                          imageBuilder: (context, imageProvider) => Container(
                            height: _mainHeight * 0.1,
                            width: _mainWidth * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Shimmer.fromColors(
                              child: Container(
                                height: _mainHeight * 0.1,
                                width: _mainWidth * 0.4,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              baseColor: Colors.grey[200] as Color,
                              highlightColor: Colors.grey[350] as Color),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        );
                      },
                      itemCount: widget.ticketModel.issueImage?.length ?? 0,
                      separatorBuilder: (context, index) => SizedBox(
                        width: 10,
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 25,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: _mainWidth * 0.01,
                  right: _mainWidth * 0.01,
                  top: _mainHeight * 0.007,
                  bottom: _mainHeight * 0.007),
              decoration: BoxDecoration(
                border: Border.all(color: CustomTheme.appTheme, width: 0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Table(
                children: [
                  TableRow(children: [
                    Text(
                      'Ticket Id : ',
                      style: getKeyStyle,
                    ),
                    Text('${widget.ticketModel.id ?? ''}',
                        style: getValueStyle),
                    Text('Status : ', style: getKeyStyle),
                    Text('${widget.ticketModel.status ?? ''}',
                        style: getValueStyle)
                  ]),
                  TableRow(children: [
                    Text('Time : ', style: getKeyStyle),
                    Text(
                        '${DateTimeService.checkDateFormat(widget.ticketModel.date) ?? ''}',
                        style: getValueStyle),
                    Text('Type : ', style: getKeyStyle),
                    Text('${widget.ticketModel.category ?? ''}',
                        style: getValueStyle)
                  ]),
                  TableRow(children: [
                    Text('Unit No. : ', style: getKeyStyle),
                    Text('${widget.ticketModel.unitNumber ?? ''}',
                        style: getValueStyle),
                    Text('Mobile : ', style: getKeyStyle),
                    Text('${widget.ticketModel.mobileNumber ?? ''}',
                        style: getValueStyle)
                  ]),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 35,
              width: _mainWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ValueListenableBuilder(
                      valueListenable: showOpenButton,
                      builder: (context, bool value, child) {
                        return value
                            ? ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            CustomTheme.appThemeContrast),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    )),
                                onPressed: () async {
                                  String status = 'ReOpen';
                                  String ticketId =
                                      widget.ticketModel.id ?? '';
                                  RMSWidgets.showLoaderDialog(context: context, message: 'Loading');
                                 int response= await _viewModel.updateTicketStatus(status: status, ticketId: ticketId);
                                  Navigator.of(context).pop();
                                  if(response==200){
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
                              )
                            : Container();
                      }),
                  ValueListenableBuilder(valueListenable: showResolvedButton, builder:(context,bool value,child){
                    return value ? ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              CustomTheme.myFavColor),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          )),
                      onPressed: () async {
                        String status = 'Resolved';

                        String ticketId = widget.ticketModel.id ?? '';
                        RMSWidgets.showLoaderDialog(context: context, message: 'Loading');
                       int response= await _viewModel.updateTicketStatus(status: status, ticketId: ticketId);
                        Navigator.of(context).pop();
                        if(response==200){
                          Navigator.of(context).pop();
                        }
                      },
                      child: Center(
                          child: Text(
                            'Resolved',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                    ):Container();
                  }),
                  ValueListenableBuilder(valueListenable: showCancelButton, builder: (context,bool value,child){
                   return value ? ElevatedButton(
                     style: ButtonStyle(
                         backgroundColor: MaterialStateProperty.all<Color>(
                             CustomTheme.appTheme),
                         shape:
                         MaterialStateProperty.all<RoundedRectangleBorder>(
                           RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10)),
                         )),
                     onPressed: () async {
                       String status = 'Cancelled';
                       String ticketId = widget.ticketModel.id ?? '';
                       RMSWidgets.showLoaderDialog(context: context, message: 'Loading');
                       int response=await _viewModel.updateTicketStatus(status: status, ticketId: ticketId);
                       Navigator.of(context).pop();
                       if(response==200){
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
                   ):Container();  
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
