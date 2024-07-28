import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:regatta_app/models/user.dart';

class UserPreferences {
  Future saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("jwtToken", user.jwt.token);
    prefs.setString("jwtExp", user.jwt.expiration.toString());
  }

  Future<JWT?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String jwtToken = prefs.getString("jwtToken") ?? "";
    String jwtExpStr = prefs.getString("jwtExp") ?? "";

    if (jwtToken == "" || jwtExpStr == "") {
      return null;
    }

    DateTime? jwtExp = DateTime.tryParse(jwtExpStr);

    if (jwtExp == null || jwtExp.isBefore(DateTime.now())) {
      return null;
    }

    return JWT(
      token: jwtToken,
      expiration: jwtExp,
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
    String token = prefs.getString("jwtToken") ?? "";
    return token;
  }
}
