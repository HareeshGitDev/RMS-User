import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../../utils/color.dart';

class HeaderContainer extends StatelessWidget {
  var text = "Welcone Back";

  HeaderContainer(this.text);



  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
      image: DecorationImage(
      image: AssetImage('assets/icons/signup.svg'),
      fit: BoxFit.fill,
      ),
          gradient: LinearGradient(
              colors: [onecolor, secondcolor],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 20,
              right: 20,
              child: Text(
            text,
            style: TextStyle(color: Colors.white,fontSize: 20),
          )),
          Center(
            child: Image.asset("assets/images/logormsblue.png"),
            
          ),
        ],
      ),
    );
  }
}
