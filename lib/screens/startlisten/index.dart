import 'package:flutter/material.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/layout_grid.dart';
import 'package:regatta_app/widgets/nav_btn.dart';

class StartlistenIndex extends StatelessWidget {
  const StartlistenIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      "Startlisten",
      LayoutGrid([
        NavBtn(
          context,
          Icons.navigation,
          "/startlisten/langstrecke",
          "Langstrecke",
        ),
        NavBtn(
          context,
          Icons.swap_calls,
          "/startlisten/slalom",
          "Slalom",
        ),
        NavBtn(
          context,
          Icons.view_column,
          "/startlisten/kurzstrecke",
          "Kurzstrecke",
        ),
        NavBtn(
          context,
          Icons.swap_horiz,
          "/startlisten/staffel",
          "Staffel",
        ),
      ]),
    );
  }
}
