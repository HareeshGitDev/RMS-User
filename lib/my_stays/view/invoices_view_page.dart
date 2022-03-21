import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/app_consts.dart';
import '../model/Invoice_Details_Model.dart';
import '../viewmodel/mystay_viewmodel.dart';
class InvoicePage extends StatefulWidget {
  final String bookingId;
  const InvoicePage({Key? key, required this.bookingId}) : super(key: key);

  @override
  _InvoiceState createState() => _InvoiceState();
}
class _InvoiceState extends State<InvoicePage> {
  @override
  var _mainHeight;
  var _mainWidth;
  static const String fontFamily = 'hk-grotest';
  late MyStayViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
    _viewModel.getInvoiceDetails(bookingId: widget.bookingId);
  }
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
          appBar: AppBar(
            title: Text('Invoices '),
          ),
          body:
          Consumer<MyStayViewModel>(builder:(context, value, child) {
            return value.invoiceDetailsModel != null &&
                value.invoiceDetailsModel?.data != null
                ? Container(height: _mainHeight,color: Colors.white,
            width: _mainWidth,
            child: SingleChildScrollView(
              child: Column(
              children: [
              _Invoiceui(invoicedetails: value.invoiceDetailsModel?.data?.invoiceDetails,),
              ]),
            ),): Center(child: CircularProgressIndicator());
          },
          )
      );

  }
  Widget _Invoiceui({required List<InvoiceDetails>? invoicedetails}) {
    return invoicedetails != null && invoicedetails.isNotEmpty
    ? ListView.separated(
      itemBuilder: ( context, index) {
        var data = invoicedetails[index];
        return Container(height: _mainHeight*0.20,
        margin: EdgeInsets.all(10),
        width: _mainWidth,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
        border: Border.all(style: BorderStyle.solid)),
        child:
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
              Container(width: _mainWidth/2.5,
                  alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Invoice Id  :' ,style: TextStyle(fontSize: 16)),Text(' ${data.invoiceId}',style: TextStyle(fontSize: 16),)],)),
              Container(width: _mainWidth/2.5,padding: EdgeInsets.only(left: 10,right: 10),
                  alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Category  :' ,style: TextStyle(fontSize: 16)),Text('${data.transactionType}',style: TextStyle(fontSize: 16),maxLines: 2,)],)),
            ],),
          ),
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
              Container(width: _mainWidth/2.5,
                  alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('From  :' ,style: TextStyle(fontSize: 16)),Text('${data.fromDate}',style: TextStyle(fontSize: 16))],)),
              Container(width: _mainWidth/2.5,padding: EdgeInsets.only(left: 10,right: 10),
                  alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('To :' ,style: TextStyle(fontSize: 16)),Text('${data.tillDate}',style: TextStyle(fontSize: 16))],))],
            ),
          ),
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
              Container(width: _mainWidth/2.5,
                  alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Amount :' ,style: TextStyle(fontSize: 16)),Text('${data.amount}',style: TextStyle(fontSize: 16))],)),
              Container(width: _mainWidth/2.5,padding: EdgeInsets.only(left: 10,right: 10),
                  alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Received  :' ,style: TextStyle(fontSize: 16)),Text('${data.amountRecieved}',style: TextStyle(fontSize: 16))],))],
            ),
          ),
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
              Container(width: _mainWidth/2.5,
                  alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Referral :' ,style: TextStyle(fontSize: 16)),Text('${data.refferalDiscount}',style: TextStyle(fontSize: 16))],)),
              Container(width: _mainWidth/2.5,padding: EdgeInsets.only(left: 10,right: 10),
                  alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Pending  :' ,style: TextStyle(fontSize: 16)),Text('${data.pendingBalance}',style: TextStyle(fontSize: 16))],))],
            ),
          ),
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
              Container(width: _mainWidth/2.5,
                  alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Pay Now :' ,style: TextStyle(fontSize: 16)),Text('${data.totalAmount}',style: TextStyle(fontSize: 16))],)),
              Container(width: _mainWidth/2.5,padding: EdgeInsets.only(left: 10,right: 10),
                  alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Status  :' ,style: TextStyle(fontSize: 16)),Text('${data.status}',style: TextStyle(fontSize: 16))],))],
            ),
          ),
          ElevatedButton(onPressed:()=>{}, child:Text('Pay Now') ),
        ]
        ),
      );
  },
      separatorBuilder: (context, index) => SizedBox(
        height: 5,
      ),
      itemCount: invoicedetails.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
    ):
    Container();}
}
