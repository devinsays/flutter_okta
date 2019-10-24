import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:okta_flutter/providers/auth.dart';
import 'package:okta_flutter/models/user.dart';
import 'package:okta_flutter/styles/styles.dart';
import 'package:okta_flutter/widgets/styled_flat_button.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String token = Provider.of<AuthProvider>(context).token;
    User user = Provider.of<AuthProvider>(context).user;

    print(user);

    Widget dataRow(String label, String value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(label.toUpperCase(), style: Styles.label),
          SizedBox(height: 5),
          Text(value, style: Styles.p),
          SizedBox(height: 15),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Okta App'),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Okta Information',
              textAlign: TextAlign.center,
              style: Styles.h1,
            ),
            SizedBox(height: 45),
            dataRow('Token', token),
            dataRow('ID', user.id),
            dataRow('Login', user.login),
            dataRow('Name', '${user.firstName} ${user.lastName}'),
            dataRow('Locale', user.locale),
            dataRow('Time Zone', user.timeZone),
            SizedBox(height: 30),
            StyledFlatButton(
              'Log Out',
              onPressed: () => Provider.of<AuthProvider>(context).logOut(),
            ),
          ],
        ),
      ),
    );
  }
}
