import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:okta_flutter/utils/api_client.dart';
import 'package:okta_flutter/widgets/notification_text.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {
  Status _status = Status.Uninitialized;
  String _token;
  String _refreshToken;
  NotificationText _notification;

  Status get status => _status;
  String get token => _token;
  String get refreshToken => _refreshToken;
  NotificationText get notification => _notification;

  // Update to use with your own Okta app.
  final String api = 'https://nanoapp.oktapreview.com/oauth2/auso4gulrq9ulEb7O0h7/v1/token';
  final String applicationId = 'auso4gulrq9ulEb7O0h7';
  final String audienceId = '0oao49otuaQgpXWtD0h7';

  // Creates a client with application/json headers set.
  final apiClient = ApiClient();

  initAuthProvider() async {
    String token = await getToken();
    if (token != null) {
      _token = token;
      _status = Status.Authenticated;
    } else {
      _status = Status.Unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _status = Status.Authenticating;
    _notification = null;
    notifyListeners();

    Map<String, String> body;
    String authnApi = '$api/api/v1/authn';

    body = {
      "username": email,
      "password": password
    };

    final response = await apiClient.post(api, body: json.encode(body));


    String tokenApi = '$api/oauth2/$applicationId/v1/token';

    Map<String, String> body = {
      "grant_type": "password",
      "scope": "openid offline_access",
      "client_id": audienceId,
      "username": email,
      "password": password
    };

    final response = await apiClient.post(api, body: body);

    print(json.decode(response.body));

    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(response.body);

      _status = Status.Authenticated;
      _token = apiResponse['access_token'];
      _refreshToken = apiResponse['refresh_token'];

      // Save values to local storage.
      SharedPreferences storage = await SharedPreferences.getInstance();
      await storage.setString('token', _token);

      notifyListeners();
      return true;
    }

    if (response.statusCode == 401) {
      _status = Status.Unauthenticated;
      _notification = NotificationText('Invalid email or password.');
      notifyListeners();
      return false;
    }

    _status = Status.Unauthenticated;
    _notification = NotificationText('Server error.');
    notifyListeners();
    return false;
  }

  Future<bool> passwordReset(String email) async {
    final url = "$api/recovery/password";

    Map<String, String> body = {
      "username": email,
      "factorType": "EMAIL"
    };

    final response = await apiClient.post(url, body: json.encode(body));

    if (response.statusCode == 200) {
      _notification = NotificationText('Reset sent. Please check your inbox.', type: 'info');
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<String> getToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token');
    return token;
  }

  logOut([bool tokenExpired = false]) async {
    _status = Status.Unauthenticated;
    if (tokenExpired == true) {
      _notification = NotificationText('Session expired. Please log in again.', type: 'info');
    }
    notifyListeners();

    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.clear();
  }
}