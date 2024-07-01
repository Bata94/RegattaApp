import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regatta_app/provider/auth.dart';

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
    flexibleSpace: AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      titleTextStyle: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white),
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
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            bool success = await Provider.of<AuthProvider>(context, listen: false).logout();

            if (success) {
              // TODO: fix this!

              // ignore: use_build_context_synchronously
              Navigator.popUntil(context, ModalRoute.withName('/home'));
              await Future.delayed(const Duration(milliseconds: 10));
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
        ),
      ],
    ),
  );
}
