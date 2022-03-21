import 'package:RentMyStay_user/my_stays/viewmodel/mystay_viewmodel.dart';
import 'package:RentMyStay_user/theme/app_theme.dart';
import 'package:RentMyStay_user/utils/constants/app_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
    _viewModel.getRefundSplitUpDetails(bookingId: widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Refund SplitUp '),
        ),
        body: Consumer<MyStayViewModel>(
          builder: (context, value, child)
          {
            return value.refundSplitUpModel != null &&
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
                                Text('Your Security Deposit'),
                                Text(
                                    '$rupee ${value.refundSplitUpModel?.data?.depositReceived}')
                              ]),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Your Deposit Refund'),
                                Text(
                                    '$rupee ${value.refundSplitUpModel?.data?.depositRefund}')
                              ]),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Text(
                                '* This is approximate deductions made from the security deposit amount.\n* The security deposit amount will be refundable within 3 - 5 working days after handing over keys and all scheduled deduction.\n* Kindly coordinate with caretaker and ensure that the flat inspection is done before your moveout in your presence to confirm about the damages so you are aware about the same. All damages will be charged accordingly. \n*In case of any queries please write to finance@rentmystay.com.'))
                      ]),
                    ),
                  )
                : Center(child: CircularProgressIndicator());
          },
        ));
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
