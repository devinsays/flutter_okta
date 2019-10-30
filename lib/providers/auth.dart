import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_appauth/flutter_appauth.dart';

import 'package:okta_flutter/models/user.dart';
import 'package:okta_flutter/utils/api_client.dart';
import 'package:okta_flutter/widgets/notification_text.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {
  Status _status = Status.Uninitialized;
  String _token;
  User _user;
  NotificationText _notification;
  AuthorizationTokenResponse _authorization;

  Status get status => _status;
  String get token => _token;
  User get user => _user;
  NotificationText get notification => _notification;
  AuthorizationTokenResponse get authorization => _authorization;

  // Update to use with your own Okta app.
  final String api = 'https://nanoapp.okta.com/api/v1/authn';

  // Creates a client with application/json headers set.
  final apiClient = ApiClient();

  initAuthProvider() async {
    _status = Status.Unauthenticated;
    notifyListeners();
  }

  Future<bool> login(AuthorizationTokenResponse authResponse) async {
    _status = Status.Authenticating;
    _notification = null;
    _authorization = authResponse;
    notifyListeners();

    if (authResponse?.accessToken != null) {
      _status = Status.Authenticated;
      notifyListeners();
      return true;
    }

    _status = Status.Unauthenticated;
    _notification = NotificationText('Token could not be issued.');
    notifyListeners();
    return false;
  }

  // @TODO: This is still in progress.
  // Looks like https://developer.okta.com/docs/reference/api/users/#create-user endpoint can be used.
  Future<Map> register(String name, String email, String password, String passwordConfirm) async {
    final url = "$api/register";

    Map<String, String> body = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirm,
    };

    Map<String, dynamic> result = {
      "success": false,
      "message": 'Unknown error.'
    };

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      result['success'] = true;
      result['message'] = 'Registration successful, please log in.';
      return result;
    }

    Map apiResponse = json.decode(response.body);

    if (response.statusCode == 422) {
      if (apiResponse['errors'].containsKey('email')) {
        result['message'] = apiResponse['errors']['email'][0];
        return result;
      }

      if (apiResponse['errors'].containsKey('password')) {
        result['message'] = apiResponse['errors']['password'][0];
        return result;
      }

      return result;
    }

    return result;
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

  logOut([bool tokenExpired = false]) async {
    _status = Status.Unauthenticated;
    if (tokenExpired == true) {
      _notification = NotificationText('Session expired. Please log in again.', type: 'info');
    }
    notifyListeners();
  }
}