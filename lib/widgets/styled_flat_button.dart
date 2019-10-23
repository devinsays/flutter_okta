import 'package:flutter/material.dart';

import 'package:okta_flutter/styles/palette.dart';
import 'package:okta_flutter/styles/styles.dart';

class StyledFlatButton extends StatelessWidget {
  final String text;
  final onPressed;
  final double radius;

  const StyledFlatButton(this.text, {this.onPressed, Key key, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Palette.primary500,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Text(
          this.text,
          style: Styles.p.copyWith(
            color: Palette.white,
            height: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      onPressed: () {
        this.onPressed();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 4.0),
        side: BorderSide(
          color: Palette.primary500,
          width: 2,
        ),
      ),
    );
  }
}