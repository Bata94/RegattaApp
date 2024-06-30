import 'package:flutter/material.dart';

class NavBar extends PreferredSize {
  NavBar(
    Key key,
    BuildContext context, {
    String title = "MRG Regatta",
    double height = 40.0,
    PreferredSizeWidget? bottom,
    double heightBottom = 48.0,
  }) : super(
          key: key,
          preferredSize: Size.fromHeight(
            bottom == null ? height : height + heightBottom,
          ),
          child: AppBar(
            key: const Key("appBar"),
            backgroundColor: Theme.of(context).primaryColor,
            bottom: bottom,
            title: Row(
              children: [
                Image.asset(
                  "assets/icons/mrg_logo.png",
                  width: 32,
                  height: 32,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        );
}

