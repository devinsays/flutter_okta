import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:okta_flutter/providers/auth.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Okta App'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Text('Okta App Dashboard'),
              FlatButton(
                child: Text('Log Out'),
                onPressed: () => Provider.of<AuthProvider>(context).logOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
