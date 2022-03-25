import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../theme/custom_theme.dart';
import '../viewmodel/mystay_viewmodel.dart';

class TicketDetailsPage extends StatefulWidget {
  final String ticketId;

  const TicketDetailsPage({Key? key, required this.ticketId}) : super(key: key);

  @override
  _TicketDetailsPageState createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  var _mainHeight;
  var _mainWidth;
  late MyStayViewModel _viewModel;

  TextStyle get getKeyStyle =>
      TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14);

  TextStyle get getValueStyle =>
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14);

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<MyStayViewModel>(context, listen: false);
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
            Text('Issue Description : ', style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500
            )),
            Text('Beds are not proper--Testing', style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500
            )),
            SizedBox(
              height: 20,
            ),
            Container(
              height: _mainHeight * 0.2,
              width: _mainWidth,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      'https://wallpaperaccess.com/full/6175572.jpg',
                      fit: BoxFit.cover,
                      width: _mainWidth * 0.4,
                    ),
                  );
                },
                itemCount: 4,
                separatorBuilder: (context, index) => SizedBox(
                  width: 10,
                ),
              ),
            ),
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
                border: Border.all(color: CustomTheme.appTheme,width: 0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Table(
                children: [
                  TableRow(children: [
                    Text(
                      'Ticket Id : ',
                      style: getKeyStyle,
                    ),
                    Text(widget.ticketId, style: getValueStyle),
                    Text('Status : ', style: getKeyStyle),
                    Text('Resolved', style: getValueStyle)
                  ]),
                  TableRow(children: [
                    Text('Creation Time : ', style: getKeyStyle),
                    Text('December 24,2022', style: getValueStyle),
                    Text('Type : ', style: getKeyStyle),
                    Text('Furniture Type', style: getValueStyle)
                  ]),
                  TableRow(children: [
                    Text('Unit No. : ', style: getKeyStyle),
                    Text('G4', style: getValueStyle),
                    Text('Mobile : ', style: getKeyStyle),
                    Text('919794562047', style: getValueStyle)
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
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            CustomTheme.appThemeContrast),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        )),
                    onPressed: () async {
                      //
                    },
                    child: Center(
                        child: Text(
                      'Re-Open',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            CustomTheme.myFavColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        )),
                    onPressed: () async {
                      //
                    },
                    child: Center(
                        child: Text(
                      'Resolved',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            CustomTheme.appTheme),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        )),
                    onPressed: () async {
                      //
                    },
                    child: Center(
                        child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
