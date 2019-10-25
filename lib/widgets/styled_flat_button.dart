import 'package:flutter/material.dart';

import 'package:okta_flutter/styles/palette.dart';
import 'package:okta_flutter/styles/styles.dart';

class StyledFlatButton extends StatelessWidget {
  final String text;
  final onPressed;
  final bool loading;

  StyledFlatButton(this.text, {this.onPressed, this.loading = false, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator = SizedBox(
      height: 16.0,
      width: 16.0,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Palette.primary100),
      ),
    );

    Text buttonText = Text(
      this.text,
      style: Styles.p.copyWith(
        color: Palette.white,
        height: 1,
        fontWeight: FontWeight.w500,
      ),
    );

    return FlatButton(
      color: Palette.primary500,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.0),
        child: loading ? progressIndicator : buttonText,
      ),
      onPressed: () {
        this.onPressed();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: BorderSide(
          color: Palette.primary500,
          width: 2,
        ),
      ),
    );
  }
}
