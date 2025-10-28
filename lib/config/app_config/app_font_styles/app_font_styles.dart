import 'package:flutter/material.dart';

class AppFontStyles {
  TextStyle? FirstFontStyleWidget(double? fontSize, Color? color) {
    return TextStyle(
      fontFamily: 'peyda',
      fontSize: fontSize,
      color: color,
    );
  }

  TextStyle? SecondFontStyleWidget(double? fontSize, Color? color){
    return TextStyle(
      fontFamily: 'kalameh',
      fontSize: fontSize,
      color: color,
    );
  }
}
