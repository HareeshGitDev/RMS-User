import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../viewmodel/mystay_viewmodel.dart';
class InvoicePage extends StatefulWidget {
  const InvoicePage({Key? key}) : super(key: key);

  @override
  _InvoiceState createState() => _InvoiceState();
}
class _InvoiceState extends State<InvoicePage> {
  @override
  var _mainHeight;
  var _mainWidth;
  static const String fontFamily = 'hk-grotest';
  late MyStayViewModel _viewModel;
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
          appBar: AppBar(
            title: Text('Invoice '),
          ),
          body: Container(height: _mainHeight,color: Colors.white,
            width: _mainWidth,
    child: Column(
    children: [_Invoiceui(hint: 'sk')]),)
      );

  }
  Widget _Invoiceui({required String hint}) {
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
                alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Invoice Id  :' ,style: TextStyle(fontSize: 16)),Text('116896',style: TextStyle(fontSize: 16))],)),
            Container(width: _mainWidth/2.5,padding: EdgeInsets.only(left: 10,right: 10),
                alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Category  :' ,style: TextStyle(fontSize: 16)),Text('Rent',style: TextStyle(fontSize: 16))],))],
          ),
        ),
        Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
            Container(width: _mainWidth/2.5,
                alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('From  :' ,style: TextStyle(fontSize: 16)),Text('04-03-2022',style: TextStyle(fontSize: 16))],)),
            Container(width: _mainWidth/2.5,padding: EdgeInsets.only(left: 10,right: 10),
                alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('To :' ,style: TextStyle(fontSize: 16)),Text('04-03-2022',style: TextStyle(fontSize: 16))],))],
          ),
        ),
        Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
            Container(width: _mainWidth/2.5,
                alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Amount :' ,style: TextStyle(fontSize: 16)),Text('999',style: TextStyle(fontSize: 16))],)),
            Container(width: _mainWidth/2.5,padding: EdgeInsets.only(left: 10,right: 10),
                alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Received  :' ,style: TextStyle(fontSize: 16)),Text('0',style: TextStyle(fontSize: 16))],))],
          ),
        ),
        Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
            Container(width: _mainWidth/2.5,
                alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Referral :' ,style: TextStyle(fontSize: 16)),Text('0',style: TextStyle(fontSize: 16))],)),
            Container(width: _mainWidth/2.5,padding: EdgeInsets.only(left: 10,right: 10),
                alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Pending  :' ,style: TextStyle(fontSize: 16)),Text('999',style: TextStyle(fontSize: 16))],))],
          ),
        ),
        Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
            Container(width: _mainWidth/2.5,
                alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Pay Now :' ,style: TextStyle(fontSize: 16)),Text('999',style: TextStyle(fontSize: 16))],)),
            Container(width: _mainWidth/2.5,padding: EdgeInsets.only(left: 10,right: 10),
                alignment: Alignment.centerLeft,child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text('Status  :' ,style: TextStyle(fontSize: 16)),Text('Pending',style: TextStyle(fontSize: 16))],))],
          ),
        ),
        ElevatedButton(onPressed:()=>{}, child:Text('Pay Now') ),
      ]
      ),
    );}
}
