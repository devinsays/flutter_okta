import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:okta_flutter/styles/theme.dart';
import 'package:okta_flutter/providers/auth.dart';
import 'package:okta_flutter/views/loading.dart';
import 'package:okta_flutter/views/login.dart';
import 'package:okta_flutter/views/register.dart';
import 'package:okta_flutter/views/password_reset.dart';
import 'package:okta_flutter/views/dashboard.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      builder: (context) => AuthProvider(),
      child: MaterialApp(
        theme: themeData,
        initialRoute: '/',
        routes: {
          '/': (context) => Router(),
          '/login': (context) => LogIn(),
          '/register': (context) => Register(),
          '/password-reset': (context) => PasswordReset(),
        },
      ),
    ),
  );
}

class Router extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Consumer<AuthProvider>(
      builder: (context, user, child) {
        switch (user.status) {
          case Status.Uninitialized:
            return Loading();
          case Status.Unauthenticated:
            return LogIn();
          case Status.Authenticated:
            return Dashboard();
          default:
            return LogIn();
        }
      },
    );
  }
}