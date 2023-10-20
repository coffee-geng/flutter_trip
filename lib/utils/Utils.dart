import 'dart:ui';

import 'package:flutter/material.dart';

class Utils
{
  static Color StringToColor(String color)
  {
    if (color == ''){
      return Colors.black;
    }
    String colorStr = color;
    if (!colorStr.startsWith('0x')) {
      if (colorStr.length == 6) {
        colorStr = 'ff' + colorStr;
      }
      colorStr = '0x' + colorStr;
    } else {
      String str = colorStr.substring(2);
      if (str.length == 6) {
        str = 'ff' + str;
      }
      colorStr = '0x' + str;
    }
    return Color(int.parse(colorStr));
  }
}