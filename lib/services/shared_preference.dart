import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:regatta_app/models/user.dart';

class UserPreferences {
  Future saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("ulid", user.ulid);
    prefs.setString("username", user.username);
    prefs.setString("jwt", user.jwt);
    // prefs.setString("renewalToken", user.renewalToken);
  }

  Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String ulid = prefs.getString("ulid") ?? "";
    String username = prefs.getString("username") ?? "";
    String jwt = prefs.getString("jwt") ?? "";
    // String renewalToken = prefs.getString("renewalToken");

    if (ulid == "") {
     return null;
    }

    return User(
      ulid: ulid,
      username: username,
      jwt: jwt,
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("ulid");
    prefs.remove("username");
    prefs.remove("jwt");
  }

  Future<String> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("jwt") ?? "";
    return token;
  }
}
