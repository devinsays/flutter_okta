import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:okta_flutter/models/user.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {

  Status _status = Status.Uninitialized;
  String _token;
  User _user;
  String _notification;

  Status get status => _status;
  String get token => _token;
  User get user => _user;
  String get notification => _notification;

  // Request headers.
  final Map<String, String> headers = {
    'Content-type': 'application/json', 
    'Accept': 'application/json',
  };

  // Update to use with your own Okta app.
  final String api = 'https://nanoapp.okta.com/api/v1';

  initAuthProvider() async {
    String token = await getToken();
    if (token != null) {
      _user = await getUser();
      _token = token;
      _status = Status.Authenticated;
    } else {
      _status = Status.Unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {

    _status = Status.Authenticating;
    _notification = '';
    notifyListeners();

    final url = "$api/authn";

    Map<String, String> body = {
      "username": email,
      "password": password
    };

    final response = await http.post(
      url,
      body: json.encode(body),
      headers: {
        'Content-type': 'application/json', 
        'Accept': 'application/json'
      }
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(response.body);

      _status = Status.Authenticated;
      _token = apiResponse['sessionToken'];
      _user = User.fromApiResponse(apiResponse);

      // Save values to local storage.
      SharedPreferences storage = await SharedPreferences.getInstance();
      await storage.setString('token', _token);
      await storage.setString('user', json.encode(_user.toJson()));

      notifyListeners();
      return true;
    }

    if (response.statusCode == 401) {
      _status = Status.Unauthenticated;
      _notification = 'Invalid email or password.';
      notifyListeners();
      return false;
    }

    _status = Status.Unauthenticated;
    _notification = 'Server error.';
    notifyListeners();
    return false;
  }

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

    final response = await http.post( url, body: body, );

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

  passwordReset(String email) async {
    final url = "$api/forgot-password";

    Map<String, String> body = {
      'email': email,
    };

    Map<String, dynamic> result = {
      "reset": false,
      "message": 'Unknown error.'
    };

    final response = await http.post( url, body: body, );

    if (response.statusCode == 200) {
      result['reset'] = true;
      result['message'] = "Reset successful. Please check your inbox.";
      return result;
    }

    if (response.statusCode == 422) {
      result['message'] = "We couldn't find an account with that email.";
      return result;
    }

    return result;
  }

  Future<String> getToken() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String token = storage.getString('token');
    return token;
  }

  Future<User> getUser() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String userString = storage.getString('user');
    Map<String, dynamic> storedUser = json.decode(userString);
    User user = User.fromJson(storedUser);
    return user;
  }


  logOut([bool tokenExpired = false]) async {
    _status = Status.Unauthenticated;
    if (tokenExpired == true) {
      _notification = 'Session expired. Please log in again.';
    }
    notifyListeners();

    SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.clear();
  }

}