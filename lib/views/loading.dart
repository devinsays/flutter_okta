import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:okta_flutter/providers/auth.dart';

class Loading extends StatelessWidget {

  initAuthProvider(context) async {
    Provider.of<AuthProvider>(context).initAuthProvider();
  }

  @override
  Widget build(BuildContext context) {

    initAuthProvider(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Okta App'),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}