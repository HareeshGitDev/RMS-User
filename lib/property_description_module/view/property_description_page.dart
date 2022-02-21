import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class PropertyDescriptionPage extends StatefulWidget {
  @override
  _PropertyDescriptionPageState createState() => _PropertyDescriptionPageState();


}
class _PropertyDescriptionPageState extends State<PropertyDescriptionPage> {
  var _mainHeight;
  var _mainWidth;

  @override
  Widget build(BuildContext context) {
    _mainHeight = MediaQuery.of(context).size.height;
    _mainWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: _mainHeight,
        width: _mainWidth,
        child: Column(
          children: [

          ],
        )
      ),
    );
  }
}