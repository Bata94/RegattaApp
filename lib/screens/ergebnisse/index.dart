import 'package:flutter/material.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/layout_grid.dart';
import 'package:regatta_app/widgets/nav_btn.dart';

class ErgebnisseIndex extends StatelessWidget {
  const ErgebnisseIndex({super.key});

  @override
  Widget build(BuildContext context) {
      return BaseLayout(
      "Ergebnisse",
      LayoutGrid([
        NavBtn(
          context,
          Icons.navigation,
          "/ergebnisse/langstrecke",
          "Langstrecke",
        ),
        NavBtn(
          context,
          Icons.swap_calls,
          "/ergebnisse/slalom",
          "Slalom",
        ),
        NavBtn(
          context,
          Icons.view_column,
          "/ergebnisse/kurzstrecke",
          "Kurzstrecke",
        ),
        NavBtn(
          context,
          Icons.swap_horiz,
          "/ergebnisse/staffel",
          "Staffel",
        ),
      ])
    );
  }
}
