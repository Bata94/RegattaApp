import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:regatta_app/models/user.dart';
import 'package:regatta_app/provider/user.dart';

class Welcome extends StatelessWidget {
  final User user;

  const Welcome({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).setUser(user);

    return const Scaffold(
      body: Center(
        child: Text("WELCOME PAGE"),
      ),
    );
  }
}
