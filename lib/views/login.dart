import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

import 'package:okta_flutter/providers/auth.dart';
import 'package:okta_flutter/utils/validate.dart';
import 'package:okta_flutter/styles/styles.dart';
import 'package:okta_flutter/styles/palette.dart';
import 'package:okta_flutter/widgets/styled_flat_button.dart';
import 'package:okta_flutter/widgets/notification_text.dart';

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> submit() async {
      FlutterAppAuth appAuth = FlutterAppAuth();

      try {
        AuthorizationTokenResponse authResponse =
            await appAuth.authorizeAndExchangeCode(
          AuthorizationTokenRequest(
            '0oao49otuaQgpXWtD0h7',
            'com.mynano://oauthredirect',
            discoveryUrl:
                'https://nanoapp.oktapreview.com/oauth2/auso4gulrq9ulEb7O0h7/.well-known/openid-configuration',
            scopes: ['openid', 'profile', 'email', 'offline_access'],
          ),
        );
        await Provider.of<AuthProvider>(context).login(authResponse);
      } catch(e) {
        print(e);
      }

    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Log in to the App',
                  textAlign: TextAlign.center,
                  style: Styles.h1,
                ),
                SizedBox(height: 10.0),
                Consumer<AuthProvider>(
                  builder: (context, provider, child) =>
                      provider.notification ?? NotificationText(''),
                ),
                StyledFlatButton(
                  'Sign In',
                  onPressed: submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
