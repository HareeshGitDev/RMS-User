import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../images.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({Key? key}) : super(key: key);

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(Images.successfulIcon,height: 100,width: 200,),
      ),
    );
  }
}
