// ignore_for_file: constant_identifier_names
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:regatta_app/services/api_request.dart';
import 'package:regatta_app/models/user.dart';
import 'package:regatta_app/services/shared_preference.dart';


enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Authenticating,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status get loggedInStatus => _loggedInStatus;
  
  User? _user;
  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void unsetUser() {
    _user = null;
    notifyListeners();
  }

  Future<User?> getUserFromApi(JWT jwt) async {
    ApiResponse res = await ApiRequester(
      baseUrl: ApiUrl.me,
      securedEndpoint: false,
      headers: {
        'Authorization': 'Bearer ${jwt.token}',
      }).get();

    if (res.statusCode == 999) {
      // TODO: Handle properly!
      throw Exception('No Internet connection!');
    }

    if (!res.status) {
      unsetUser();
      return null;
    }

    try {
      User userData = User(
        ulid: res.data['ulid'],
        username: res.data['username'],
        jwt: jwt,
      );
      setUser(userData);
      return userData;
    } catch (e) {
      return null;
    }
  }

  Future<bool> login(String username, String password) async {
    final Map<String, dynamic> loginJson = {
      'username': username,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    ApiResponse res = await ApiRequester(
      baseUrl: ApiUrl.login,
      securedEndpoint: false)
    .post(
      body: loginJson,
    );

    if (res.statusCode == 200) {
      User authUser = User.fromJson(res.data);
      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      _user = User.fromJson(res.data);
      notifyListeners();
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
    }
    return res.status;
  }

  Future<bool> logout() async {
    // ApiResponse res = await ApiRequester(baseUrl: ApiUrl.logout).post();

    // if (res.status) {
    UserPreferences().removeUser();
    _user = null;
    _loggedInStatus = Status.NotLoggedIn;
    notifyListeners();
    return true;
    // }

    // return res.status;
  }

  Future<bool> validate() async {
    ApiResponse res = await ApiRequester(baseUrl: ApiUrl.userValidate).get();

    if (res.status) {
      return true;
    } else {
      logout();

      return false;
    }
  }
}
