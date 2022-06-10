import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmersPage{

  static Widget getSimilarPropsListShimmerView({required BuildContext context,required double height,required double width}){
    return Shimmer
        .fromColors(
        child:
        Container(
          height:height,
          color:
          Colors.amber,
        ),
        baseColor: Colors.grey[200]
        as Color,
        highlightColor:
        Colors.grey[350] as Color);
  }

}