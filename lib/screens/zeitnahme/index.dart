import 'package:flutter/material.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/layout_grid.dart';
import 'package:regatta_app/widgets/nav_btn.dart';

class ZeitnahmeIndex extends StatelessWidget {
  const ZeitnahmeIndex({super.key});

  @override
  Widget build(BuildContext context) {
      return BaseLayout(
      "Zeitnahme",
      LayoutGrid([
        NavBtn(
          context,
          Icons.play_circle_fill_outlined,
          "/zeitnahme/start",
          "Startgericht",
        ),
        NavBtn(
          context,
          Icons.flag,
          "/zeitnahme/ziel",
          "Zielgericht",
        ),
      ],
      ),
    );
  }
}
