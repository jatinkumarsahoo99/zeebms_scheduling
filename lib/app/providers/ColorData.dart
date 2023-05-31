import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

class ColorData {
  static const Color appleGreen = Color(0xFF65D965);
  static const Color appleGreen1 = Color(0xFF2EB35B);
  static const Color bgFormField = Color(0xFFECEFF1);
  static const Color hintColor = Color(0xFFCBC9D9);
  static const Color brandColor = Color(0xFF402b6c);
  static Color scaffoldBg = Colors.grey[200]!;
  static const Color deepSkyBlue = Color.fromARGB(255, 0, 191, 255);

  /*static cellColor(String value){
    // print("Here is the map"+jsonEncode(mapKey));
    if(value.toString()=="1"){
      return deepSkyBlue;
    }else{
      return null;
    }
  }*/

  static cellColor(String value, String key) {
    // print("All keys>>"+map.keys.toString());
    switch (key) {
      case "epsNo":
        if (value.toString() == "1") {
          return deepSkyBlue;
        } else {
          return null;
        }
      case "status":
        if (value.toString() != "Scheduled") {
          return deepSkyBlue;
        } else {
          return null;
        }
      case "tapeid":
        if (value.toString().toLowerCase() == "tba" || value.toString().toLowerCase() == "live" || value.toString().toLowerCase() == "news") {
          return deepSkyBlue;
        } else {
          return null;
        }
      default:
        return null;
    }
    /*if(map.containsKey("epsNo") && map["epsNo"]?.value.toString()=="1"){
      return deepSkyBlue;
    }else{
      return null;
    }*/
  }

  static Color getColorData(int? val) {
    switch (val) {
      case 0:
        return Color.fromARGB(255, 173, 216, 230);

      case 1:
        return Color.fromARGB(255, 240, 128, 128);

      case 2:
        return Color.fromARGB(255, 224, 255, 225);

      case 3:
        return Color.fromARGB(255, 250, 250, 210);

      case 4:
        return Color.fromARGB(255, 144, 238, 144);

      case 5:
        return Color.fromARGB(255, 255, 182, 193);

      case 6:
        return Color.fromARGB(255, 255, 160, 122);

      case 7:
        return Color.fromARGB(255, 32, 178, 170);

      case 8:
        return Color.fromARGB(255, 135, 206, 250);

      case 9:
        return Color.fromARGB(255, 176, 196, 222);

      case 10:
        return Color.fromARGB(255, 255, 255, 224);

      case 11:
        return Color.fromARGB(255, 119, 136, 153);

      case 12:
        return Color.fromARGB(255, 240, 255, 255);

      case 13:
        return Color.fromARGB(255, 0, 0, 225);

      case 14:
        return Color.fromARGB(255, 255, 127, 80);

      case 15:
        return Color.fromARGB(255, 0, 225, 255);

      case 16:
        return Color.fromARGB(255, 255, 225, 0);

      case 17:
        return Color.fromARGB(255, 0, 128, 0);

      case 18:
        return Color.fromARGB(255, 255, 192, 203);

      case 19:
        return Color.fromARGB(255, 250, 128, 114);

      case 20:
        return Color.fromARGB(255, 46, 139, 87);

      default:
        return Colors.white;

      /*colors(0) = Color.LightBlue        LightBlue - Color.fromARGB(255,173,216,230)
        colors(1) = Color.LightCoral    LightCoral - Color.fromARGB(255,240,128,128)
        colors(2) = Color.LightCyan        LightCyan - Color.fromARGB(255,224,255,225)
        colors(3) = Color.LightGolde    LightGoldenrodYellow - Color.fromARGB(255,250,250,210)
        colors(4) = Color.LightGreen    LightGreen - Color.fromARGB(255,144,238,144)
        colors(5) = Color.LightPink        LightPink - Color.fromARGB(255,255,182,193)
        colors(6) = Color.LightSalmo    LightSalmon - Color.fromARGB(255,255,160,122)
        colors(7) = Color.LightSeaGr    LightSeaGreen - Color.fromARGB(255,32,178,170)
        colors(8) = Color.LightSkyBl    LightSkyBlue - Color.fromARGB(255,135,206,250)
        colors(9) = Color.LightSteel    LightSteelBlue - Color.fromARGB(255,176,196,222)
        colors(10) = Color.LightYell    LightYellow - Color.fromARGB(255,255,255,224)
        colors(11) = Color.LightSlat    LightSlateGray - Color.fromARGB(255,119,136,153)
        colors(12) = Color.Azure        Azure - Color.fromARGB(255,240,255,255)
        colors(13) = Color.Blue            Blue - Color.fromARGB(255,0,0,225)
        colors(14) = Color.Coral           Coral - Color.fromARGB(255,255,127,80)
        colors(15) = Color.Cyan            Cyan - Color.fromARGB(255,0,225,255)
        colors(16) = Color.Yellow        Yellow - Color.fromARGB(255,255,225,0)
        colors(17) = Color.Green        Green - Color.fromARGB(255,0,128,0)
        colors(18) = Color.Pink            Pink - Color.fromARGB(255,255,192,203)
        colors(19) = Color.Salmon        Salmon - Color.fromARGB(255,250,128,114)
        colors(20) = Color.SeaGreen        SeaGreen - Color.fromARGB(255,46,139,87)*/
    }
  }
}
