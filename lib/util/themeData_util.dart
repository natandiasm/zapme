import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeDataUtil {
  static ThemeData themeDefault() {
    return ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Rubik',
        primarySwatch: Colors.green,
        accentColor: Colors.white,
        buttonColor: Color.fromARGB(255, 104, 45, 189),
        focusColor: Color.fromARGB(255, 136, 55, 253),
        primaryColor: Color.fromARGB(255, 26, 188, 156),
        splashColor: Color.fromARGB(255, 23, 163, 135),
        backgroundColor: Colors.white,
        cardColor: Color.fromARGB(255, 244, 245, 247),
    );
  }

  static ThemeData themeDark() {
    return ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Rubik',
        primarySwatch: Colors.green,
        primaryColor: Color.fromARGB(255, 26, 188, 156),
        backgroundColor: Color.fromARGB(255, 18, 18, 18),
        cardColor: Color.fromARGB(255, 39, 39, 39),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 103, 125, 255)),
        textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)));
  }
}