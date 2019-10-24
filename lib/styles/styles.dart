import 'package:flutter/material.dart';

import 'package:okta_flutter/styles/palette.dart';

class Styles {
  static TextStyle defaultStyle = TextStyle(
    color: Palette.primary,
  );

  static TextStyle h1 = defaultStyle.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 18.0,
    height: 22 / 18,
  );

  static TextStyle p = defaultStyle.copyWith(
    fontSize: 16.0,
  );

  static TextStyle label = defaultStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
  );

  static TextStyle error = defaultStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 11.0,
    height: 14 / 11,
    color: Palette.danger500,
  );

  static InputDecoration input = InputDecoration(
    fillColor: Palette.white,
    focusColor: Palette.primary,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Palette.primary,
        width: 2.0,
      ),
    ),
    border: OutlineInputBorder(
      gapPadding: 1.0,
      borderSide: BorderSide(
        color: Palette.primary,
        width: 1.0,
      ),
    ),
    hintStyle: TextStyle(
      color: Palette.primary200,
    ),
  );

}
