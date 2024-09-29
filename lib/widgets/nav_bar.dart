// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regatta_app/provider/auth.dart';
import 'package:regatta_app/widgets/dialog.dart';

class NavBar extends AppBar {
  NavBar(
    BuildContext context, {
    String title = "MRG Regatta",
    double height = 44.0,
    PreferredSizeWidget? bottom,
    double heightBottom = 48.0,
  }) : super(
    key: Key("appBar-$title"),
    toolbarHeight: height,
    bottom: bottom,
    iconTheme: Theme.of(context).iconTheme.copyWith(color: Theme.of(context).colorScheme.onPrimary),
    backgroundColor: Theme.of(context).primaryColor,
    titleTextStyle: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.onPrimary),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          "assets/icons/mrg_logo.png",
          width: 32,
          height: 32,
        ),
        Text(
          title,
        ),
        const SizedBox(
          width: 32,
          height: 32,
        ),
      ],
    ),
    actions: Provider.of<AuthProvider>(context).user != null ? [
      IconButton(
        icon: const Icon(
          Icons.home,
        ),
        onPressed: () async {
          Navigator.popUntil(context, ModalRoute.withName('/home'));
          await Future.delayed(const Duration(milliseconds: 10));
          Navigator.of(context).pushNamed('/home');
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.logout,
        ),
        onPressed: () async {
          bool confirm = await dialogConfim(context, "Wollen Sie sich wirklich ausloggen?");
          if (!confirm) {
            return;
          }

          bool success = await Provider.of<AuthProvider>(context, listen: false).logout();

          if (success) {
            Navigator.popUntil(context, ModalRoute.withName('/home'));
            await Future.delayed(const Duration(milliseconds: 10));
            Navigator.of(context).pushReplacementNamed('/login');
          }
        },
      ),
    ] : [],
 );
}
