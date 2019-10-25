import 'package:flutter/material.dart';

import 'package:okta_flutter/styles/palette.dart';

class NotificationText extends StatelessWidget {
  final String text;
  final String type;

  NotificationText(this.text, {this.type, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color color = Palette.danger500;

    if ('info' == type) {
      color = Palette.info500;
    }

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: color),
    );
  }
}
