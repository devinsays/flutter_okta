import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

import 'package:okta_flutter/providers/auth.dart';
import 'package:okta_flutter/styles/styles.dart';
import 'package:okta_flutter/widgets/styled_flat_button.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthorizationTokenResponse authorization =
        Provider.of<AuthProvider>(context).authorization;

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
        padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
        child: ListView(
          children: <Widget>[
            Text(
              'Okta Information',
              textAlign: TextAlign.center,
              style: Styles.h1,
            ),
            SizedBox(height: 45),
            dataRow('accessToken', authorization.accessToken),
            dataRow('refreshToken', authorization.refreshToken),
            dataRow('idToken', authorization.idToken),
            dataRow('tokenType', authorization.tokenType),
            dataRow('accessTokenExpirationDateTime',
                authorization.accessTokenExpirationDateTime.toString()),
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
