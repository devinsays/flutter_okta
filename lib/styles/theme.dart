import 'package:flutter/material.dart';

final Map<int, Color> primarySwatch = const <int, Color> {
  900: Color(0xff2D2051),
  800: Color(0xff3B2F68),
  700: Color(0xff423974),
  600: Color(0xff4B4280),
  500: Color(0xff514A89),
  400: Color(0xff676499),
  300: Color(0xff807FAA),
  200: Color(0xffA2A3C3),
  100: Color(0xffC6C7DB),
  50: Color(0xffE8E9F0),
};

final ThemeData themeData = new ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Steradian',
  primarySwatch: MaterialColor(0xff514A89, primarySwatch),
);