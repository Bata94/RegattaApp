import 'package:flutter/material.dart';
import 'package:regatta_app/widgets/base_layout.dart';
import 'package:regatta_app/widgets/layout_grid.dart';
import 'package:regatta_app/widgets/nav_btn.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      "MRG Regatta",
      LayoutGrid([
        NavBtn(
          context,
          Icons.watch,
          "/zeitnahme",
          "Zeitnahme",
        ),
        NavBtn(
          context,
          Icons.assignment,
          "/startlisten",
          "Startlisten",
        ),
        NavBtn(
          context,
          Icons.computer,
          "/ergebnisse",
          "Ergebnisse",
        ),
        NavBtn(
          context,
          Icons.person,
          "/leitung",
          "Regattaleiter",
        ),
        NavBtn(
          context,
          Icons.computer,
          "/buero",
          "Regattabüro",
        ),
        NavBtn(
          context,
          Icons.admin_panel_settings,
          "/admin",
          "Admin",
        ),
      ]),
    );
  }
}
