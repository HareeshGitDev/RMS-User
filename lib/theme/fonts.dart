import 'package:flutter/cupertino.dart';

const String getThemeFont='Montserrat';
double getHeight({required BuildContext context,required int height}){
  if(height ==10){
    return MediaQuery.of(context).size.height * 0.0115;
  }else if(height == 12){
    return MediaQuery.of(context).size.height * 0.0138;
  }else if(height ==14){
    return MediaQuery.of(context).size.height * 0.0161;
  }else if(height ==16){
    return MediaQuery.of(context).size.height * 0.0184;
  }else if(height == 18){
    return MediaQuery.of(context).size.height * 0.0207;
  }else if(height == 20){
    return MediaQuery.of(context).size.height * 0.0230;
  }
  return MediaQuery.of(context).size.height;
}