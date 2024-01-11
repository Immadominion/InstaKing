import 'package:flutter/material.dart';
import 'dart:ui';

Widget blurTheStatusBar(BuildContext context) {
  double w = MediaQuery.of(context).size.width;
  return ClipRRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
      child: Container(
        height: w / 18,
        color: Colors.transparent,
      ),
    ),
  );
}
