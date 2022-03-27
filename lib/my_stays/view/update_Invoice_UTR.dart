import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../theme/custom_theme.dart';
import '../viewmodel/mystay_viewmodel.dart';

class UpdateInvoiceUTRPage extends StatefulWidget {
  final String bookingId;

  const UpdateInvoiceUTRPage({Key? key, required this.bookingId}) : super(key: key);

  @override
  _UpdateInvoiceUTRPageState createState() => _UpdateInvoiceUTRPageState();
}

class _UpdateInvoiceUTRPageState extends State<UpdateInvoiceUTRPage> {
  @override
  final _updateUTRController = TextEditingController();
  var _mainHeight;
  var _mainWidth;
  late MyStayViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
   // _viewModel.getRefundSplitUpDetails(bookingId: widget.bookingId);
  }
  TextStyle get getKeyStyle =>
      TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14);

  TextStyle get getValueStyle =>
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14);
  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;

    return Scaffold(appBar: AppBar(
      title: Text('Update UTR '),
      titleSpacing: 0,
      backgroundColor: CustomTheme.appTheme,
    ),
      body: Container(

          margin: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Use Netbanking/UPI ID/QR Code to transfer amount directly to bank account and update the transaction details below:'),
              SizedBox(height: 10,),
              Text('Account Details : ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),textAlign: TextAlign.left),
              SizedBox(height: 10,),
              Table(
                children: [
                  TableRow(children: [
                    Text('A/C holder name :', style: getKeyStyle),
                    Text(' Brightpath Technology',
                      style: getValueStyle,
                      maxLines: 2,
                    ),
                  ]),

                  TableRow(children: [
                    Text('A/C type :', style: getKeyStyle),
                    Text(' Current Account',
                      style: getValueStyle,
                      maxLines: 2,
                    ),
                  ]),
                  TableRow(children: [
                    Text('A/C Number :', style: getKeyStyle),
                    Text(' 64140859192',
                      style: getValueStyle,
                      maxLines: 2,
                    ),
                  ]),
                  TableRow(children: [
                    Text('IFSC Code :', style: getKeyStyle),
                    Text(' SBIN0016213',
                      style: getValueStyle,
                      maxLines: 2,
                    ),
                  ]),
                  TableRow(children: [
                    Text('Bank name :', style: getKeyStyle),
                    Text(' State Bank of India',
                      style: getValueStyle,
                      maxLines: 2,
                    ),
                  ]),
                ],
              ),
              SizedBox(height: 10,),
              Text('Pay using UPI ID : ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),textAlign: TextAlign.left),
              SizedBox(height: 10,),
              Text('rentmystay@sbi ',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.grey),textAlign: TextAlign.left),
              SizedBox(height: 5,),
              Text('rentmystay@oksbi',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.grey,),textAlign: TextAlign.left),
              SizedBox(height: 10,),
              Text('Pay using QR Code  : ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),textAlign: TextAlign.left),
              Container(alignment:Alignment.center,child: Image.network('https://firebasestorage.googleapis.com/v0/b/rentmystay-new-1539065190327.appspot.com/o/qr_code_rentmystay.jpeg?alt=media&token=22b8d369-5be5-43dc-b113-b297fd44b4ad',width: 200,height: 200,)),
              SizedBox(height: 10,),
              Text('Payable Amount : ${widget.bookingId} ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),textAlign: TextAlign.left),
              SizedBox(height: 10,),
              Container(alignment:Alignment.center,child: Text('Update UTR/Transaction ID')),
              SizedBox(height: 10,),
              Container(
                height: 45,
                child: Neumorphic(
                  style: NeumorphicStyle(
                    // shadowLightColor: CustomTheme.appTheme.withAlpha(150),
                    shadowDarkColor: Colors.blueGrey.shade100,
                    // color: Colors.black26.withAlpha(40),
                    color: Colors.white,
                    border: NeumorphicBorder(
                        color: CustomTheme.appTheme, width: 1),
                    lightSource: LightSource.bottom,
                    intensity: 5,
                    depth: 2,
                    shape: NeumorphicShape.convex,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: _mainWidth * 0.78,
                        height: 44,
                        child: TextFormField(
                          controller: _updateUTRController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  //fontFamily: fontFamily,
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500),
                        ),
                      ),
                      )],
                  ),
                ),
              ),
              SizedBox(height: 10,),
        Container(alignment: Alignment.center,
            width: _mainWidth,
            height: _mainHeight * 0.05,
            child: ElevatedButton(
              onPressed: () async
              {},
              child: Text('Site Visit',style: TextStyle(
                  color: CustomTheme.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500
              ),),
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(
                      CustomTheme.appTheme),
                  shape: MaterialStateProperty.all<
                      RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10)),
                  )),
            ),
        ),
            ]
        ),
      ),
    );
  }
}
